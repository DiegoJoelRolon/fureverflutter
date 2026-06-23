import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/PetProvider.dart';
import '../location/LocationHelper.dart';

class UploadPetScreen extends StatefulWidget {
  const UploadPetScreen({super.key});

  @override
  State<UploadPetScreen> createState() => _UploadPetScreenState();
}

class _UploadPetScreenState extends State<UploadPetScreen> {
  final _nameController        = TextEditingController();
  final _breedController       = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController        = TextEditingController();

  String _selectedSpecies  = '';
  String _selectedGender   = '';
  String _selectedSize     = '';
  String _selectedAgeGroup = '';

  File? _imageFile;
  final _picker = ImagePicker();

  bool _isUploading = false;
  bool _loadingLocation = false;

  double _latitude  = 0.0;
  double _longitude = 0.0;

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _selectedSpecies.isNotEmpty &&
      _selectedGender.isNotEmpty &&
      _selectedSize.isNotEmpty &&
      _selectedAgeGroup.isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // ── Geolocalización ───────────────────────────────────────────────────────

  Future<void> _useCurrentLocation() async {
    setState(() => _loadingLocation = true);

    try {
      final result = await LocationHelper.getCurrentLocation();

      setState(() {
        _latitude  = result.latitude;
        _longitude = result.longitude;
        if (result.city.isNotEmpty) {
          _cityController.text = result.city;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ubicación obtenida correctamente'),
            backgroundColor: Color(0xFF388E3C),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  // ── Foto ──────────────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _showPhotoDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Foto de la mascota',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
              ),
              const SizedBox(height: 16),
              _PhotoOption(
                icon:  Icons.photo_library_outlined,
                label: 'Elegir de la galería',
                onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
              ),
              const SizedBox(height: 12),
              _PhotoOption(
                icon:  Icons.camera_alt_outlined,
                label: 'Tomar foto',
                onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar', style: TextStyle(color: Color(0xFF9E9E9E))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Publicar ──────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_isFormValid) return;
    setState(() => _isUploading = true);

    try {
      await context.read<PetProvider>().uploadPet(
        name:        _nameController.text.trim(),
        breed:       _breedController.text.trim(),
        description: _descriptionController.text.trim(),
        city:        _cityController.text.trim(),
        species:     _selectedSpecies,
        gender:      _selectedGender,
        size:        _selectedSize,
        ageGroup:    _selectedAgeGroup,
        imageFile:   _imageFile,
        latitude:    _latitude,
        longitude:   _longitude,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Mascota publicada con éxito!'),
            backgroundColor: Color(0xFF388E3C),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFC62828)),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        title: const Text(
          'Publicar mascota',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF5C4033),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Foto ───────────────────────────────────────────────────────
            _SectionTitle('Foto'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showPhotoDialog,
              child: Container(
                width:  double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color:        const Color(0xFFEDE0D4),
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: _imageFile != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(_imageFile!, fit: BoxFit.cover),
                          Positioned(
                            bottom: 10, right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:        const Color(0xCC5C4033),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Cambiar foto',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('📷', style: TextStyle(fontSize: 40)),
                          SizedBox(height: 8),
                          Text(
                            'Tocá para agregar una foto',
                            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Datos básicos ──────────────────────────────────────────────
            _SectionTitle('Datos básicos'),
            const SizedBox(height: 8),
            _Field(controller: _nameController, label: 'Nombre *'),
            const SizedBox(height: 12),
            _Field(controller: _breedController, label: 'Raza'),
            const SizedBox(height: 12),
            _Field(
              controller: _descriptionController,
              label:      'Descripción',
              maxLines:   4,
            ),

            const SizedBox(height: 24),

            // ── Ubicación ──────────────────────────────────────────────────
            _SectionTitle('Ubicación'),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _Field(controller: _cityController, label: 'Ciudad'),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _loadingLocation ? null : _useCurrentLocation,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5C4033),
                      side: const BorderSide(color: Color(0xFF5C4033)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loadingLocation
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location, size: 20),
                  ),
                ),
              ],
            ),
            if (_latitude != 0 && _longitude != 0) ...[
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.check_circle, size: 14, color: Color(0xFF388E3C)),
                  SizedBox(width: 4),
                  Text(
                    'Ubicación guardada',
                    style: TextStyle(fontSize: 12, color: Color(0xFF388E3C)),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // ── Especie ────────────────────────────────────────────────────
            _SectionTitle('Especie *'),
            const SizedBox(height: 8),
            _ChipGroup(
              options:  const ['Perro', 'Gato', 'Otro'],
              selected: _selectedSpecies,
              onSelect: (v) => setState(() => _selectedSpecies = v),
            ),

            const SizedBox(height: 20),

            // ── Género ─────────────────────────────────────────────────────
            _SectionTitle('Género *'),
            const SizedBox(height: 8),
            _ChipGroup(
              options:  const ['Macho', 'Hembra'],
              selected: _selectedGender,
              onSelect: (v) => setState(() => _selectedGender = v),
            ),

            const SizedBox(height: 20),

            // ── Tamaño ─────────────────────────────────────────────────────
            _SectionTitle('Tamaño *'),
            const SizedBox(height: 8),
            _ChipGroup(
              options:  const ['Pequeño', 'Mediano', 'Grande'],
              selected: _selectedSize,
              onSelect: (v) => setState(() => _selectedSize = v),
            ),

            const SizedBox(height: 20),

            // ── Edad ───────────────────────────────────────────────────────
            _SectionTitle('Edad *'),
            const SizedBox(height: 8),
            _ChipGroup(
              options:  const ['Cachorro', 'Joven', 'Adulto', 'Senior'],
              selected: _selectedAgeGroup,
              onSelect: (v) => setState(() => _selectedAgeGroup = v),
            ),

            const SizedBox(height: 32),

            // ── Botón publicar ─────────────────────────────────────────────
            SizedBox(
              width:  double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_isFormValid && !_isUploading) ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:         const Color(0xFF5C4033),
                  disabledBackgroundColor: const Color(0xFFBCAAA4),
                  foregroundColor:         Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Publicar mascota',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets privados ─────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize:   14,
      color:      Color(0xFF5C4033),
    ),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int    maxLines;

  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines:   maxLines,
      decoration: InputDecoration(
        labelText:    label,
        labelStyle:   const TextStyle(color: Color(0xFF795548)),
        filled:       true,
        fillColor:    Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Color(0xFFD7CCC8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Color(0xFFD7CCC8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Color(0xFF5C4033), width: 1.5),
        ),
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  final List<String> options;
  final String       selected;
  final void Function(String) onSelect;

  const _ChipGroup({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((value) {
        final isSelected = selected == value;
        return GestureDetector(
          onTap: () => onSelect(value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:        isSelected ? const Color(0xFF5C4033) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:       Border.all(color: const Color(0xFF5C4033)),
            ),
            child: Text(
              value,
              style: TextStyle(
                color:      isSelected ? Colors.white : const Color(0xFF5C4033),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize:   13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String   label;
  final VoidCallback onTap;

  const _PhotoOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:        onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width:   double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          border:       Border.all(color: const Color(0xFF5C4033)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5C4033)),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Color(0xFF5C4033), fontSize: 15)),
          ],
        ),
      ),
    );
  }
}