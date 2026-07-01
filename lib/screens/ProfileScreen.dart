import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fureverflutter/providers/TranslationProvider.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/AuthProvider.dart';
import '../providers/PetProvider.dart';
import '../models/PetPost.dart';
import 'AdoptionRequestsScreen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfileScreen
// ─────────────────────────────────────────────────────────────────────────────

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().fetchPendingRequests();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final petProvider = context.watch<PetProvider>();
    final user = authProvider.currentUser;
    final t = context.watch<TranslationProvider>();
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final myPets = petProvider.pets
        .where((p) => p.ownerId == user.email)
        .toList();
    final available = myPets
        .where((p) => p.adoptedStatus == 'Disponible')
        .toList();
    final adopted = myPets.where((p) => p.adoptedStatus == 'Adoptado').toList();
    final total = myPets.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── Header marrón ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _ProfileHeader(
                user: user,
                available: available.length,
                adopted: adopted.length,
                total: total,
                onSignOut: () => _confirmSignOut(context, authProvider),
              ),
            ),

            // ── Cuerpo ───────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── "My posts" ──────────────────────────────────────
                   _SectionTitle(title: t.translate('Myposts')),
                  const SizedBox(height: 12),

                  // ── Banner adopciones ────────────────────────────────────────────
                  _AdoptionRequestBanner(
                    pendingCount: petProvider.pendingRequests.length,
                  ),
                  const SizedBox(height: 20),

                  if (available.isEmpty && adopted.isEmpty)
                     _EmptyState(
                      icon: Icons.pets_outlined,
                      message: t.translate('nopetspublished'),
                    )
                  else ...[
                    ...available.map(
                      (pet) => _PetCard(
                        pet: pet,
                        onEdit: () => _openEditSheet(context, pet, petProvider),
                        onDelete: () =>
                            _confirmDelete(context, pet, petProvider),
                      ),
                    ),
                    if (adopted.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _SectionTitle(title: t.translate('adopteds')),
                      const SizedBox(height: 12),
                      ...adopted.map(
                        (pet) => _PetCard(
                          pet: pet,
                          dimmed: true,
                          onDelete: () =>
                              _confirmDelete(context, pet, petProvider),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmSignOut(context, authProvider),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Cerrar sesión'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Future<void> _confirmDelete(
    BuildContext context,
    PetPost pet,
    PetProvider petProvider,
  ) async {
    final t = context.read<TranslationProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar mascota'),
        content: Text(
          t.translate('erasepet') + ' ${pet.name}? ' + t.translate('erasepet2'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await petProvider.deletePet(pet.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pet.name} eliminado'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _openEditSheet(
    BuildContext context,
    PetPost pet,
    PetProvider petProvider,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditPetSheet(pet: pet, petProvider: petProvider),
    );
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final t = context.read<TranslationProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:  Text(t.translate('signout')),
        content:  Text(t.translate('signoutmessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text(t.translate('cancel')), // 'Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.brownDark),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (ok == true) authProvider.signOut();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header marrón con avatar centrado + stats
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final dynamic user;
  final int available;
  final int adopted;
  final int total;
  final VoidCallback onSignOut;

  const _ProfileHeader({
    required this.user,
    required this.available,
    required this.adopted,
    required this.total,
    required this.onSignOut,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _displayName(dynamic u) {
    final name = u.name as String? ?? '';
    final lastname = u.lastname as String? ?? '';
    final full = '$name $lastname'.trim();
    return full.isNotEmpty ? full : (u.email ?? 'Usuario');
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final name = _displayName(user);

    return Container(
      color: AppColors.brown,
      child: Column(
        children: [
          SizedBox(height: topPad + 8),

          // Título "My Profile" + logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Avatar
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brownLight,
                ),
                child: Center(
                  child: Text(
                    _initials(name),
                    style: const TextStyle(
                      color: AppColors.brownDark,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Pequeña insignia de verificación
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brownDark,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: AppColors.brownLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Nombre
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            user.email ?? '',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 4),

          // Ciudad
          if ((user.city ?? '').toString().isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 13, color: Colors.white54),
                const SizedBox(width: 2),
                Text(
                  user.city ?? '',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),

          const SizedBox(height: 4),
          Text(
            '$total published pets',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),

          const SizedBox(height: 20),

          // Tarjetas de estadísticas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatCard(value: '$available', label: 'Available'),
                const SizedBox(width: 10),
                _StatCard(value: '$adopted', label: 'Adopted'),
                const SizedBox(width: 10),
                _StatCard(value: '$total', label: 'Total'),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.brown),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Título de sección
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.brownDark,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tarjeta de mascota
// ─────────────────────────────────────────────────────────────────────────────

class _PetCard extends StatelessWidget {
  final PetPost pet;
  final bool dimmed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _PetCard({
    required this.pet,
    this.dimmed = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.65 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen cuadrada redondeada izquierda
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: _PetImage(imageUrl: pet.imageUrl, size: 84),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pet.species,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          pet.city,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    _StatusBadge(status: pet.adoptedStatus),
                  ],
                ),
              ),
            ),

            // Menú
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.grey,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (_) => [
                  if (onEdit != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: AppColors.brown,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Editar',
                            style: TextStyle(color: AppColors.brownDark),
                          ),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status badge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isAvailable = status == 'Disponible';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAvailable ? 'Available' : 'Adopted',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAvailable ? AppColors.green : AppColors.red,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Imagen de mascota
// ─────────────────────────────────────────────────────────────────────────────

class _PetImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  const _PetImage({required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageUrl.split(',').last);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      } catch (_) {
        return _placeholder();
      }
    }
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
    width: size,
    height: size,
    color: AppColors.brownPale,
    child: const Icon(Icons.pets, color: AppColors.brown, size: 32),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Estado vacío
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brownLight),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.greyLight),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: AppColors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Sheet de edición (sin cambios funcionales, solo colores actualizados)
// ─────────────────────────────────────────────────────────────────────────────

class _EditPetSheet extends StatefulWidget {
  final PetPost pet;
  final PetProvider petProvider;

  const _EditPetSheet({required this.pet, required this.petProvider});

  @override
  State<_EditPetSheet> createState() => _EditPetSheetState();
}

class _EditPetSheetState extends State<_EditPetSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _breedCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _cityCtrl;

  late String _species;
  late String _gender;
  late String _size;
  late String _ageGroup;

  static const _speciesOpts = ['Perro', 'Gato', 'Otro'];
  static const _genderOpts = ['Macho', 'Hembra'];
  static const _sizeOpts = ['Pequeño', 'Mediano', 'Grande'];
  static const _ageGroupOpts = ['Cachorro', 'Joven', 'Adulto', 'Senior'];

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    _nameCtrl = TextEditingController(text: p.name);
    _breedCtrl = TextEditingController(text: p.breed);
    _descCtrl = TextEditingController(text: p.description);
    _cityCtrl = TextEditingController(text: p.city);
    _species = _speciesOpts.contains(p.species)
        ? p.species
        : _speciesOpts.first;
    _gender = _genderOpts.contains(p.gender) ? p.gender : _genderOpts.first;
    _size = _sizeOpts.contains(p.size) ? p.size : _sizeOpts.first;
    _ageGroup = _ageGroupOpts.contains(p.ageGroup)
        ? p.ageGroup
        : _ageGroupOpts.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _descCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await widget.petProvider.updatePet(
      petId: widget.pet.id,
      name: _nameCtrl.text.trim(),
      breed: _breedCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      species: _species,
      gender: _gender,
      size: _size,
      ageGroup: _ageGroup,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameCtrl.text.trim()} actualizado'),
          backgroundColor: AppColors.brown,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.brownLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(
                    Icons.edit_rounded,
                    color: AppColors.brown,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Editar ${widget.pet.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brownDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _SheetField(
                controller: _nameCtrl,
                label: 'Nombre',
                icon: Icons.badge_outlined,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 14),

              _SheetField(
                controller: _breedCtrl,
                label: 'Raza',
                icon: Icons.info_outline_rounded,
              ),
              const SizedBox(height: 14),

              _SheetField(
                controller: _cityCtrl,
                label: 'Ciudad',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 14),

              _SheetField(
                controller: _descCtrl,
                label: 'Descripción',
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),
              const SizedBox(height: 14),

              _SheetDropdown(
                label: 'Especie',
                value: _species,
                items: _speciesOpts,
                onChanged: (v) => setState(() => _species = v ?? _species),
              ),
              const SizedBox(height: 14),

              _SheetDropdown(
                label: 'Género',
                value: _gender,
                items: _genderOpts,
                onChanged: (v) => setState(() => _gender = v ?? _gender),
              ),
              const SizedBox(height: 14),

              _SheetDropdown(
                label: 'Tamaño',
                value: _size,
                items: _sizeOpts,
                onChanged: (v) => setState(() => _size = v ?? _size),
              ),
              const SizedBox(height: 14),

              _SheetDropdown(
                label: 'Grupo etario',
                value: _ageGroup,
                items: _ageGroupOpts,
                onChanged: (v) => setState(() => _ageGroup = v ?? _ageGroup),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brownDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Guardar cambios',
                          style: TextStyle(fontSize: 15),
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

// ─────────────────────────────────────────────────────────────────────────────
// Widgets auxiliares del sheet
// ─────────────────────────────────────────────────────────────────────────────

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: AppColors.brown),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brownLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brownLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brownDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}

class _SheetDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _SheetDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brownLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brownLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brownDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}


class _AdoptionRequestBanner extends StatelessWidget {
  final int pendingCount;
  const _AdoptionRequestBanner({required this.pendingCount});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AdoptionRequestsScreen(),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícono con fondo rosado
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.pets_rounded,
                color: Colors.red,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
 
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adoption Requests',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brownDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pendingCount > 0
                        ? '$pendingCount pending '
                            '${pendingCount == 1 ? 'request' : 'requests'}'
                        : 'No pending requests',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          pendingCount > 0 ? Colors.red : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
 
            // Badge numérico (solo si hay pendientes)
            if (pendingCount > 0) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pendingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
 
            // Flecha
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
