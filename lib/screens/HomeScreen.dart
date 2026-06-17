import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/AuthProvider.dart';
import '../providers/PetProvider.dart';
import '../models/PetPost.dart';
import 'PetDetailScreen.dart';
import 'UploadPetScreen.dart';

// ─── Utilidad de traducción (igual que en Android) ───────────────────────────

String getTranslation(String value) {
  const map = {
    'dog': 'Perro',
    'cat': 'Gato',
    'puppy': 'Cachorro',
    'kitten': 'Gatito',
    'male': 'Macho',
    'female': 'Hembra',
    'baby': 'Bebé',
    'young': 'Joven',
    'adult': 'Adulto',
    'senior': 'Senior',
    'small': 'Pequeño',
    'medium': 'Mediano',
    'large': 'Grande',
  };
  return map[value.toLowerCase()] ?? value;
}

// ─── HomeScreen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Equivalente a LaunchedEffect(Unit) { petViewModel.fetchPets() }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().fetchPets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final petProvider  = context.watch<PetProvider>();

    final currentUser  = authProvider.currentUser;
    final searchQuery  = petProvider.searchQuery;

    final nombre = (currentUser?.name?.isNotEmpty == true)
        ? currentUser!.name!
        : 'amigo';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),

      // ── AppBar + SearchBar ────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(108),
        child: Container(
          color: const Color(0xFF5C4033),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: const [
                      Icon(Icons.pets, color: Color(0xFFD7CCC8), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'FurEver',
                        style: TextStyle(
                          color:      Colors.white,
                          fontSize:   22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller:  _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      onChanged: (v) => petProvider.onSearchChanged(v),
                      decoration: InputDecoration(
                        hintText:  'Buscar por nombre, raza, ciudad…',
                        hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Colors.white, size: 18),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        filled:      true,
                        fillColor:   Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:   const BorderSide(color: Colors.white38),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:   const BorderSide(color: Colors.white38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:   const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5C4033),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UploadPetScreen()),
        ),
        child: const Icon(Icons.add),
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: searchQuery.isNotEmpty
          ? _buildSearchResults(petProvider, authProvider)
          : _buildMainFeed(petProvider, authProvider, nombre),
    );
  }

  // ── Resultados de búsqueda ────────────────────────────────────────────────

  Widget _buildSearchResults(PetProvider petProvider, AuthProvider authProvider) {
    final results = petProvider.filteredPets;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.pets, size: 48, color: Color(0xFFBCAAA4)),
            SizedBox(height: 12),
            Text(
              'No se encontraron mascotas',
              style: TextStyle(color: Color(0xFF9E9E9E), fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding:            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount:          results.length,
      separatorBuilder:   (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final pet   = results[i];
        final isFav = authProvider.currentUser?.favorites?.contains(pet.id) ?? false;
        return PetCardVertical(
          pet:         pet,
          isFav:       isFav,
          onToggleFav: () => authProvider.toggleFavorite(pet.id),
          onClick:     () => _goToDetail(pet.id),
        );
      },
    );
  }

  // ── Feed principal ────────────────────────────────────────────────────────

  Widget _buildMainFeed(PetProvider petProvider, AuthProvider authProvider, String nombre) {
    final recentPets = petProvider.recentPets;
    final dogs       = petProvider.dogs;
    final cats       = petProvider.cats;
    final puppies    = petProvider.puppies;
    final others     = petProvider.others;

    final isEmpty = recentPets.isEmpty && dogs.isEmpty && cats.isEmpty &&
                    puppies.isEmpty && others.isEmpty;

    if (petProvider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF5C4033)));
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [

        // Saludo
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, $nombre! 👋',
                style: const TextStyle(
                  fontSize:   22,
                  fontWeight: FontWeight.bold,
                  color:      Color(0xFF3E2723),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Encontrá tu compañero perfecto',
                style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
        ),

        // Estado vacío
        if (isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: const [
                Icon(Icons.pets, size: 48, color: Color(0xFFBCAAA4)),
                SizedBox(height: 12),
                Text(
                  'No hay mascotas disponibles aún',
                  style: TextStyle(color: Color(0xFF9E9E9E), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

        // Recientes
        if (recentPets.isNotEmpty) ...[
          SectionHeader(
            title:       'Recién llegados',
            count:       recentPets.length,
            icon:        Icons.auto_awesome,
            iconTint:    const Color(0xFFF57C00),
            iconBgColor: const Color(0xFFFFF3E0),
          ),
          _HorizontalPetRow(
            pets:        recentPets,
            authProvider: authProvider,
            onTap:       _goToDetail,
          ),
        ],

        // Perros
        if (dogs.isNotEmpty) ...[
          SectionHeader(
            title:       'Perros',
            count:       dogs.length,
            icon:        Icons.pets,
            iconTint:    const Color(0xFF388E3C),
            iconBgColor: const Color(0xFFE8F5E9),
          ),
          _HorizontalPetRow(
            pets:        dogs,
            authProvider: authProvider,
            onTap:       _goToDetail,
          ),
        ],

        // Cachorros
        if (puppies.isNotEmpty) ...[
          SectionHeader(
            title:       'Cachorros',
            count:       puppies.length,
            icon:        Icons.cruelty_free,
            iconTint:    const Color(0xFF7B1FA2),
            iconBgColor: const Color(0xFFEDE7F6),
          ),
          _HorizontalPetRow(
            pets:        puppies,
            authProvider: authProvider,
            onTap:       _goToDetail,
          ),
        ],

        // Gatos
        if (cats.isNotEmpty) ...[
          SectionHeader(
            title:       'Gatos',
            count:       cats.length,
            icon:        Icons.pets,
            iconTint:    const Color(0xFFC62828),
            iconBgColor: const Color(0xFFFFEBEE),
          ),
          _HorizontalPetRow(
            pets:        cats,
            authProvider: authProvider,
            onTap:       _goToDetail,
          ),
        ],

        // Otros
        if (others.isNotEmpty) ...[
          SectionHeader(
            title:       'Otros',
            count:       others.length,
            icon:        Icons.pets,
            iconTint:    const Color(0xFF5C4033),
            iconBgColor: const Color(0xFFEDE0D4),
          ),
          _HorizontalPetRow(
            pets:        others,
            authProvider: authProvider,
            onTap:       _goToDetail,
          ),
        ],
      ],
    );
  }

  void _goToDetail(String petId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PetDetailScreen(petId: petId)),
    );
  }
}

// ─── Fila horizontal de tarjetas (equivalente a LazyRow) ─────────────────────

class _HorizontalPetRow extends StatelessWidget {
  final List<PetPost> pets;
  final AuthProvider  authProvider;
  final void Function(String) onTap;

  const _HorizontalPetRow({
    required this.pets,
    required this.authProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection:  Axis.horizontal,
            padding:          const EdgeInsets.symmetric(horizontal: 16),
            itemCount:        pets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final pet   = pets[i];
              final isFav = authProvider.currentUser?.favorites?.contains(pet.id) ?? false;
              return PetCardHorizontal(
                pet:         pet,
                isFav:       isFav,
                onToggleFav: () => authProvider.toggleFavorite(pet.id),
                onClick:     () => onTap(pet.id),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── SectionHeader ────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final int    count;
  final IconData icon;
  final Color  iconTint;
  final Color  iconBgColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconTint,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width:  34,
                height: 34,
                decoration: BoxDecoration(
                  color:        iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconTint, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize:   15,
                  fontWeight: FontWeight.bold,
                  color:      Color(0xFF3E2723),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color:        const Color(0xFFEDE0D4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize:   11,
                color:      Color(0xFF5C4033),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PetCardHorizontal ────────────────────────────────────────────────────────

class PetCardHorizontal extends StatelessWidget {
  final PetPost  pet;
  final bool     isFav;
  final VoidCallback onToggleFav;
  final VoidCallback onClick;

  const PetCardHorizontal({
    super.key,
    required this.pet,
    required this.isFav,
    required this.onToggleFav,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        width: 160,
        child: Card(
          shape:     RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color:     Colors.white,
          elevation: 3,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: _buildImage(pet.imageUrl, height: 180),
                  ),
                  // Info
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:   14,
                            color:      Color(0xFF3E2723),
                          ),
                          maxLines:  1,
                          overflow:  TextOverflow.ellipsis,
                        ),
                        if (pet.breed?.isNotEmpty == true)
                          Text(
                            pet.breed!,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF795548)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (pet.ageGroup?.isNotEmpty == true)
                              _MiniChip(getTranslation(pet.ageGroup!), Icons.cake),
                            const SizedBox(width: 4),
                            if (pet.size?.isNotEmpty == true)
                              _MiniChip(getTranslation(pet.size!), Icons.straighten),
                          ],
                        ),
                        if (pet.city?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 12, color: Color(0xFF9E9E9E)),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  pet.city!,
                                  style:   const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              // Botón favorito
              Positioned(
                top:   4,
                right: 4,
                child: GestureDetector(
                  onTap: onToggleFav,
                  child: Container(
                    width:  36,
                    height: 36,
                    decoration: BoxDecoration(
                      color:  Colors.white.withOpacity(0.80),
                      shape:  BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size:  16,
                      color: isFav ? const Color(0xFFC62828) : const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PetCardVertical (para resultados de búsqueda) ────────────────────────────

class PetCardVertical extends StatelessWidget {
  final PetPost  pet;
  final bool     isFav;
  final VoidCallback onToggleFav;
  final VoidCallback onClick;

  const PetCardVertical({
    super.key,
    required this.pet,
    required this.isFav,
    required this.onToggleFav,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final disponible = pet.adoptedStatus == 'Disponible';

    return GestureDetector(
      onTap: onClick,
      child: Card(
        shape:     RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color:     Colors.white,
        elevation: 3,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen + badge de estado
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: _buildImage(pet.imageUrl, height: 180),
                    ),
                    Positioned(
                      top:  8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:        disponible ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pet.adoptedStatus ?? '',
                          style: TextStyle(
                            fontSize:   11,
                            fontWeight: FontWeight.w500,
                            color:      disponible ? const Color(0xFF388E3C) : const Color(0xFFC62828),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Datos
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize:   16,
                          fontWeight: FontWeight.bold,
                          color:      Color(0xFF3E2723),
                        ),
                      ),
                      Text(
                        [
                          getTranslation(pet.species ?? ''),
                          if (pet.breed?.isNotEmpty == true) pet.breed!,
                        ].join(' · '),
                        style: const TextStyle(fontSize: 13, color: Color(0xFF795548)),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (pet.gender?.isNotEmpty   == true) _MiniChip(getTranslation(pet.gender!),   Icons.person),
                          const SizedBox(width: 6),
                          if (pet.ageGroup?.isNotEmpty == true) _MiniChip(getTranslation(pet.ageGroup!), Icons.cake),
                          const SizedBox(width: 6),
                          if (pet.size?.isNotEmpty     == true) _MiniChip(getTranslation(pet.size!),     Icons.straighten),
                        ],
                      ),
                      if (pet.city?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Color(0xFF9E9E9E)),
                            const SizedBox(width: 2),
                            Text(pet.city!, style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Botón favorito
            Positioned(
              top:   4,
              right: 4,
              child: GestureDetector(
                onTap: onToggleFav,
                child: Container(
                  width:  36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.80),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size:  16,
                    color: isFav ? const Color(0xFFC62828) : const Color(0xFF9E9E9E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── MiniChip ─────────────────────────────────────────────────────────────────

class _MiniChip extends StatelessWidget {
  final String   label;
  final IconData icon;

  const _MiniChip(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color:        const Color(0xFFF5F0EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: const Color(0xFF5C4033)),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize:   10,
              color:      Color(0xFF5C4033),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildImage(String? imageUrl, {required double height}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      width: double.infinity, height: height,
      color: const Color(0xFFEDE0D4),
      child: const Center(child: Icon(Icons.pets, size: 40, color: Color(0xFF5C4033))),
    );
  }
  if (imageUrl.startsWith('data:image')) {
    final base64Str = imageUrl.split(',').last;
    return Image.memory(
      base64Decode(base64Str),
      width: double.infinity, height: height, fit: BoxFit.cover,
    );
  }
  return Image.network(
    imageUrl,
    width: double.infinity, height: height, fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      height: height, color: const Color(0xFFEDE0D4),
      child: const Center(child: Icon(Icons.pets, size: 40, color: Color(0xFF5C4033))),
    ),
  );
}