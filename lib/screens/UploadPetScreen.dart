import 'package:flutter/material.dart';
import 'package:fureverflutter/services/PetPostService.dart';
import '../models/PetPost.dart';


class UploadPetScreen extends StatefulWidget {
  const UploadPetScreen({Key? key}) : super(key: key);

  @override
  State<UploadPetScreen> createState() => _UploadPetScreenState();
}

class _UploadPetScreenState extends State<UploadPetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Pet")),
      body: const Center(child: UploadPetForm()),
    );
  }
}

class UploadPetForm extends StatefulWidget {
  const UploadPetForm({Key? key}) : super(key: key);

  @override
  State<UploadPetForm> createState() => _UploadPetFormState();
}

class _UploadPetFormState extends State<UploadPetForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _ownerPhoneController = TextEditingController();

  String _species = "Dog";
  String _gender = "Male";
  String _size = "Medium";
  String _ageGroup = "Puppy";

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final _service = PetPostService();

    //debugPrint("Submitting form...");
    if (!_formKey.currentState!.validate()){
      debugPrint("Form is not valid");
      return;
    }
    //debugPrint("Form is valid, creating PetPost object..."); 
    final newPetPost = PetPost(
      name: _nameController.text.trim(),
      species: _species,
      breed: _breedController.text.trim(),
      description: _descriptionController.text.trim(),
      city: _cityController.text.trim(),
      ownerPhone: _ownerPhoneController.text.trim(),
      gender: _gender,
      size: _size,
      ageGroup: _ageGroup,
    );
    try {
      await _service.createPetPost(newPetPost);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al publicar: $e')),
      );
    }
    }


    // Aca va la lógica para subir el post
    debugPrint(newPetPost.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Foto ──────────────────────────────────────────
          _SectionTitle('Photo'),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text("Add Photo"),
          ),
          const SizedBox(height: 16),

          // ── Nombre ────────────────────────────────────────
          _SectionTitle('Name'),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 16),
          // ── Especie ───────────────────────────────────────
          _SectionTitle('Specie'),
          _ChipSelector(
            options: const ['Dog', 'Cat', 'Other'],
            selected: _species,
            onChanged:(v) => setState(() => _species = v),
          ),
          const SizedBox(height: 16),
          // ── Raza ──────────────────────────────────────────
          _SectionTitle('Breed'),
          TextFormField(
            controller: _breedController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Breed',
            ),
          ),
          const SizedBox(height: 16),
          // ── Género ───────────────────────────────────────
          _SectionTitle('Gender'),
          _ChipSelector(
            options: const ['Male', 'Female'],
            selected: _gender,
            onChanged:(v) => setState(() => _gender = v),
          ),
          const SizedBox(height: 16),
          // ── Tamaño ───────────────────────────────────────
          _SectionTitle('Size'),
          _ChipSelector(
            options: const ['Small', 'Medium', 'Large'],
            selected: _size,
            onChanged:(v) => setState(() => _size = v),
          ),
          const SizedBox(height: 16),
          // ── Edad ─────────────────────────────────────────
          _SectionTitle('Age'),
          _ChipSelector(
            options: const ['Puppy', 'Adult', 'Senior'],
            selected: _ageGroup,
            onChanged:(v) => setState(() => _ageGroup = v),
          ),
          const SizedBox(height: 16),
          
          // ── Descripción ───────────────────────────────────
          _SectionTitle('Description'),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          const SizedBox(height: 16),
          // ── Ciudad ───────────────────────────────────────
          _SectionTitle('City'),
            TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'Ciudad *'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          // ── Telefono ─────────────────────────────────────
          _SectionTitle('Owner Phone'),
          TextFormField(
            controller: _ownerPhoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Owner Phone *'),
            validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 24),
          // ── Botón Submit ─────────────────────────────────
          FilledButton(
            onPressed: _submitForm,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("Submit"),
            ),
          ),

          
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 0.8,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _ChipSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  const _ChipSelector({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options
          .map(
            (o) => ChoiceChip(
              label: Text(o),
              selected: selected == o,
              onSelected: (_) => onChanged(o),
            ),
          )
          .toList(),
    );
  }
}
