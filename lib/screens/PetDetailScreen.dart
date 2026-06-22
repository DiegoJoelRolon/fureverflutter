import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fureverflutter/providers/TranslationProvider.dart';
import 'package:provider/provider.dart';
import '../models/PetPost.dart';
import '../providers/AuthProvider.dart';
import '../providers/PetProvider.dart';

// ─── Utilidad de traducción ───────────────────────────────────────────────────

String getTranslation(String value) {
  const map = {
    'Perro':     'Perro',
    'Gato':      'Gato',
    'Otro':      'Otro',
    'Macho':     'Macho',
    'Hembra':    'Hembra',
    'Pequeño':   'Pequeño',
    'Mediano':   'Mediano',
    'Grande':    'Grande',
    'Cachorro':  'Cachorro',
    'Joven':     'Joven',
    'Adulto':    'Adulto',
    'Senior':    'Senior',
    'dog':       'Perro',
    'cat':       'Gato',
    'puppy':     'Cachorro',
    'male':      'Macho',
    'female':    'Hembra',
    'small':     'Pequeño',
    'medium':    'Mediano',
    'large':     'Grande',
    'baby':      'Bebé',
    'young':     'Joven',
    'adult':     'Adulto',
    'senior':    'Senior',
  };
  return map[value] ?? value;
}

// ─── Widget helper de imagen (URL o Base64) ───────────────────────────────────

Widget buildPetImage(String? imageUrl, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      width: width, height: height,
      color: const Color(0xFFEDE0D4),
      child: const Center(child: Icon(Icons.pets, color: Color(0xFF5C4033), size: 48)),
    );
  }
  if (imageUrl.startsWith('data:image')) {
    final base64Str = imageUrl.split(',').last;
    return Image.memory(
      base64Decode(base64Str),
      width: width, height: height, fit: fit,
    );
  }
  return Image.network(
    imageUrl,
    width: width, height: height, fit: fit,
    errorBuilder: (_, __, ___) => Container(
      width: width, height: height,
      color: const Color(0xFFEDE0D4),
      child: const Center(child: Icon(Icons.pets, color: Color(0xFF5C4033), size: 48)),
    ),
  );
}

// ─── PetDetailScreen ──────────────────────────────────────────────────────────

class PetDetailScreen extends StatefulWidget {
  final String petId;
  const PetDetailScreen({super.key, required this.petId});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  int    _selectedPhoto     = 0;
  bool   _showConfirmDialog = false;
  bool   _showRequestDialog = false;
  bool   _requestSent       = false;
  String _requestError      = '';
  String _myRequestStatus   = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRequestStatus();
    });
  }

  Future<void> _checkRequestStatus() async {
    final status = await context.read<PetProvider>().checkMyRequestStatus(widget.petId);
    if (mounted) setState(() => _myRequestStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final petProvider  = context.watch<PetProvider>();
    final t = context.watch<TranslationProvider>();
    final pet = petProvider.pets.firstWhere(
      (p) => p.id == widget.petId,
      orElse: () => const PetPost(id: '', name: 'Cargando...'),
    );

    final currentUser  = authProvider.currentUser;
    final isFav        = currentUser?.favorites?.contains(pet.id) ?? false;
    final isAvailable  = pet.adoptedStatus == 'Disponible';
    final isOwner      = currentUser?.email == pet.ownerId;
    final hasLocation  = (pet.latitude) != 0.0 && (pet.longitude) != 0.0;

    final photos = (pet.images.isNotEmpty)
        ? pet.images!
        : [(pet.imageUrl)].where((u) => u.isNotEmpty).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor:    const Color(0xFF5C4033),
        foregroundColor:    Colors.white,
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? const Color(0xFFC62828) : Colors.white,
            ),
            onPressed: () => authProvider.toggleFavorite(pet.id),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ── Foto principal ────────────────────────────────────────────
            Stack(
              children: [
                SizedBox(
                  width:  double.infinity,
                  height: 300,
                  child:  buildPetImage(
                    photos.isNotEmpty ? photos[_selectedPhoto] : null,
                    width:  double.infinity,
                    height: 300,
                  ),
                ),
                // Gradiente inferior
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 120,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin:  Alignment.topCenter,
                        end:    Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC000000)],
                      ),
                    ),
                  ),
                ),
                // Badge estado
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:        isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAvailable ? 'Disponible' : 'Adoptado',
                      style: TextStyle(
                        fontSize:   12,
                        fontWeight: FontWeight.w500,
                        color:      isAvailable ? const Color(0xFF388E3C) : const Color(0xFFC62828),
                      ),
                    ),
                  ),
                ),
                // Nombre + especie sobre gradiente
                Positioned(
                  bottom: 16, left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize:   26,
                          fontWeight: FontWeight.bold,
                          color:      Colors.white,
                        ),
                      ),
                      Text(
                        [
                          getTranslation(pet.species),
                          if (pet.breed.isNotEmpty) pet.breed,
                        ].join(' · '),
                        style: const TextStyle(fontSize: 14, color: Color(0xCCFFFFFF)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Galería miniaturas ────────────────────────────────────────
            if (photos.length > 1)
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection:  Axis.horizontal,
                  padding:          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount:        photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => setState(() => _selectedPhoto = i),
                    child: Container(
                      width:  64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: _selectedPhoto == i
                            ? Border.all(color: const Color(0xFF5C4033), width: 2)
                            : null,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: buildPetImage(photos[i], width: 64, height: 64),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 8),

            // ── Contenido ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  // Chips de características
                  Row(
                    children: [
                      if (pet.gender.isNotEmpty)
                        Expanded(child: _InfoChip(
                          icon:      Icons.person,
                          label:     'Género',
                          value:     t.translate(pet.gender),
                          color:     const Color(0xFFE3F2FD),
                          iconColor: const Color(0xFF1565C0),
                        )),
                      if (pet.gender.isNotEmpty) const SizedBox(width: 8),
                      if (pet.ageGroup.isNotEmpty)
                        Expanded(child: _InfoChip(
                          icon:      Icons.cake,
                          label:     'Edad',
                          value:     t.translate(pet.ageGroup),
                          color:     const Color(0xFFFFF9C4),
                          iconColor: const Color(0xFFF57F17),
                        )),
                      if (pet.ageGroup.isNotEmpty) const SizedBox(width: 8),
                      if (pet.size.isNotEmpty)
                        Expanded(child: _InfoChip(
                          icon:      Icons.straighten,
                          label:     'Tamaño',
                          value:     t.translate(pet.size),
                          color:     const Color(0xFFE8F5E9),
                          iconColor: const Color(0xFF2E7D32),
                        )),
                    ],
                  ),

                  // Ubicación
                  if (pet.city.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width:   double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color:        const Color(0xFFEDE0D4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF5C4033), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            pet.city,
                            style: const TextStyle(
                              fontSize:   14,
                              color:      Color(0xFF5C4033),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Sobre la mascota
                  _SectionCard(
                    title: 'Sobre ${pet.name}',
                    icon:  Icons.pets,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.description.isNotEmpty
                              ? pet.description
                              : 'Sin descripción disponible.',
                          style: const TextStyle(
                            color:      Color(0xFF616161),
                            fontSize:   14,
                            height:     1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 13, color: Color(0xFFBCAAA4)),
                            const SizedBox(width: 4),
                            Text(
                              t.translate('publishedby') + ' ${pet.ownerId}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFFBCAAA4)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contacto del dueño
                  if (isAvailable && (pet.ownerId.isNotEmpty)) ...[
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: 'Contactar al dueño',
                      icon:  Icons.person,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.translate('areyouinterested'),
                            style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
                          ),
                          const SizedBox(height: 12),
                          _ContactRow(icon: Icons.email, label: 'Email', value: pet.ownerId),
                          if (pet.ownerPhone.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _ContactRow(icon: Icons.phone, label: 'Teléfono', value: pet.ownerPhone),
                          ],
                        ],
                      ),
                    ),
                  ],

                  // Adoptante (si ya fue adoptado)
                  if (!isAvailable && pet.adopterEmail.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: 'Datos del adoptante',
                      icon:  Icons.favorite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.translate('alreadyfoundhome'),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:      Color(0xFF3E2723),
                              fontSize:   14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFD7CCC8)),
                          const SizedBox(height: 12),
                          _ContactRow(icon: Icons.email, label: 'Email', value: pet.adopterEmail),
                          if (pet.adopterPhone.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _ContactRow(icon: Icons.phone, label: 'Teléfono', value: pet.adopterPhone),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Botón solicitar adopción ────────────────────────────
                  if (isAvailable && !isOwner) ...[
                    if (_myRequestStatus == 'pending')
                      Container(
                        width:   double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:        const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children:[
                            Icon(Icons.schedule, color: Color(0xFFF57C00), size: 20),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.translate('requestsent'),
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFF57C00), fontSize: 14)),
                                Text(t.translate('awaitingresponse'),
                                  style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
                              ],
                            ),
                          ],
                        ),
                      )
                    else if (_myRequestStatus == 'accepted')
                      Container(
                        width:   double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:        const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children:  [
                            Icon(Icons.check_circle, color: Color(0xFF388E3C), size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                t.translate('requestaccepted'),
                                style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF388E3C), fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      if (_requestError.isNotEmpty) ...[
                        Container(
                          width:   double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:        const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(_requestError,
                            style: const TextStyle(color: Color(0xFFC62828), fontSize: 13)),
                        ),
                        const SizedBox(height: 8),
                      ],
                      SizedBox(
                        width:  double.infinity,
                        height: 56,
                        child:  ElevatedButton.icon(
                          onPressed: () => _showAdoptionDialog(context, pet, petProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C4033),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon:  const Icon(Icons.favorite, size: 18),
                          label: const Text(
                            'Solicitar adopción',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdoptionDialog(BuildContext context, PetPost pet, PetProvider petProvider) {
    final t = context.watch<TranslationProvider>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(
          t.translate('requestadoption') + '${pet.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3E2723), fontSize: 18),
        ),
        content: Text(
          t.translate('requestmessage'),
          style: TextStyle(color: Color(0xFF616161), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.translate('cancel'), style: TextStyle(color: Color(0xFF9E9E9E))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await petProvider.sendAdoptionRequest(pet);
                if (mounted) setState(() => _myRequestStatus = 'pending');
              } catch (e) {
                if (mounted) setState(() => _requestError = e.toString());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C4033),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(t.translate('sendrequest'), style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── Componentes privados ─────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:     RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color:     Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width:  32, height: 32,
                  decoration: BoxDecoration(
                    color:        const Color(0xFFEDE0D4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF5C4033), size: 16),
                ),
                const SizedBox(width: 8),
                Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF3E2723))),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color    color;
  final Color    iconColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3E2723))),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;

  const _ContactRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width:  36, height: 36,
          decoration: const BoxDecoration(color: Color(0xFFEDE0D4), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF5C4033), size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
            Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF3E2723), fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}