import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/PetPost.dart';
import '../providers/AuthProvider.dart';
import '../providers/PetProvider.dart';

// ── Modelos del wizard ────────────────────────────────────────────────────────

class _WizardOption {
  final String value;
  final String label;
  final String subtitle;
  final String emoji;
  final Color bgColor;

  const _WizardOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.bgColor,
  });
}

class _WizardStep {
  final String key;
  final String question;
  final String subtitle;
  final String headerEmoji;
  final Color headerBgColor;
  final List<_WizardOption> options;

  const _WizardStep({
    required this.key,
    required this.question,
    required this.subtitle,
    required this.headerEmoji,
    required this.headerBgColor,
    required this.options,
  });
}

final _wizardSteps = [
  _WizardStep(
    key: 'species',
    question: '¿Qué mascota te imaginás?',
    subtitle: 'Elegí el tipo de compañero que buscás',
    headerEmoji: '🐾',
    headerBgColor: const Color(0xFFEDE0D4),
    options: [
      _WizardOption(value: 'Perro',           label: 'Perro',       subtitle: 'Fiel, juguetón y activo',   emoji: '🐕', bgColor: Color(0xFFE8F5E9)),
      _WizardOption(value: 'Gato',            label: 'Gato',        subtitle: 'Independiente y tranquilo', emoji: '🐈', bgColor: Color(0xFFE8EAF6)),
      _WizardOption(value: 'Otro',            label: 'Otro',        subtitle: 'Conejo, hurón y más',       emoji: '🐇', bgColor: Color(0xFFFFF3E0)),
      _WizardOption(value: 'Sin preferencia', label: 'Sorprendeme', subtitle: 'Cualquier tipo de mascota', emoji: '✨', bgColor: Color(0xFFF5F0EB)),
    ],
  ),
  _WizardStep(
    key: 'size',
    question: '¿De qué tamaño lo imaginás?',
    subtitle: 'Pensá en el espacio que tenés en casa',
    headerEmoji: '📏',
    headerBgColor: const Color(0xFFE1F5FE),
    options: [
      _WizardOption(value: 'Pequeño',         label: 'Pequeño',        subtitle: 'Menos de 10kg',   emoji: '🤏', bgColor: Color(0xFFE1F5FE)),
      _WizardOption(value: 'Mediano',         label: 'Mediano',        subtitle: 'Entre 10 y 25kg', emoji: '👐', bgColor: Color(0xFFE8F5E9)),
      _WizardOption(value: 'Grande',          label: 'Grande',         subtitle: 'Más de 25kg',     emoji: '🦮', bgColor: Color(0xFFFFEBEE)),
      _WizardOption(value: 'Sin preferencia', label: 'Sin preferencia',subtitle: 'Sin restricción', emoji: '✨', bgColor: Color(0xFFF5F0EB)),
    ],
  ),
  _WizardStep(
    key: 'age',
    question: '¿Qué etapa de vida preferís?',
    subtitle: 'Cada edad tiene su encanto',
    headerEmoji: '🎂',
    headerBgColor: const Color(0xFFFFF9C4),
    options: [
      _WizardOption(value: 'Cachorro',        label: 'Cachorro',       subtitle: 'Menos de 1 año',   emoji: '🍼', bgColor: Color(0xFFFFF9C4)),
      _WizardOption(value: 'Joven',           label: 'Joven',          subtitle: 'Entre 1 y 3 años', emoji: '⚡', bgColor: Color(0xFFFFEBEE)),
      _WizardOption(value: 'Adulto',          label: 'Adulto',         subtitle: 'Entre 3 y 8 años', emoji: '🌿', bgColor: Color(0xFFE8F5E9)),
      _WizardOption(value: 'Senior',          label: 'Senior',         subtitle: 'Más de 8 años',    emoji: '🧡', bgColor: Color(0xFFFCE4EC)),
      _WizardOption(value: 'Sin preferencia', label: 'Sin preferencia',subtitle: 'Sin restricción',  emoji: '✨', bgColor: Color(0xFFF5F0EB)),
    ],
  ),
  _WizardStep(
    key: 'gender',
    question: '¿Tenés preferencia de género?',
    subtitle: 'Solo para ayudarte a encontrar tu match ideal',
    headerEmoji: '💙',
    headerBgColor: const Color(0xFFE3F2FD),
    options: [
      _WizardOption(value: 'Macho',           label: 'Macho',       subtitle: 'Masculino',          emoji: '♂',  bgColor: Color(0xFFE3F2FD)),
      _WizardOption(value: 'Hembra',          label: 'Hembra',      subtitle: 'Femenino',           emoji: '♀',  bgColor: Color(0xFFFCE4EC)),
      _WizardOption(value: 'Sin preferencia', label: 'Sorprendeme', subtitle: 'Me da igual',        emoji: '✨', bgColor: Color(0xFFF5F0EB)),
    ],
  ),
];

// ── Pantalla principal ────────────────────────────────────────────────────────

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  Map<String, String> selections = {
    'species': '',
    'size': '',
    'age': '',
    'gender': '',
  };

  int currentStep    = 0;
  bool showResults   = false;
  bool saved         = false;
  bool favoritesAdded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        final hasPrefs = [
          user.prefSpecies,
          user.prefSize,
          user.prefAge,
          user.prefGender,
        ].any((p) => p.isNotEmpty);

        if (hasPrefs) {
          setState(() {
            selections = {
              'species': user.prefSpecies,
              'size':    user.prefSize,
              'age':     user.prefAge,
              'gender':  user.prefGender,
            };
            showResults = true;
          });
        }
      }
    });
  }

  List<PetPost> get matchingPets {
    final pets = context.read<PetProvider>().pets;
    return pets.where((pet) {
      if (pet.adoptedStatus != 'Disponible') return false;
      bool matches(String key, String petValue) {
        final sel = selections[key] ?? '';
        return sel.isEmpty || sel == 'Sin preferencia' || petValue == sel;
      }
      return matches('species', pet.species) &&
             matches('size',    pet.size)    &&
             matches('age',     pet.ageGroup) &&
             matches('gender',  pet.gender);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en pets para recalcular matchingPets
    context.watch<PetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          showResults ? 'Tu match perfecto' : '¿Cómo lo imaginás?',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF5C4033),
        foregroundColor: Colors.white,
        actions: [
          if (showResults)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {
                showResults    = false;
                currentStep    = 0;
                saved          = false;
                favoritesAdded = false;
              }),
            ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F0EB),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: showResults
            ? _ResultsView(
                key:                const ValueKey('results'),
                selections:         selections,
                matchingPets:       matchingPets,
                saved:              saved,
                favoritesAdded:     favoritesAdded,
                onSave:             _onSave,
                onAddAllToFavorites: _onAddAllToFavorites,
                onReset:            _onReset,
              )
            : _WizardView(
                key:         const ValueKey('wizard'),
                steps:       _wizardSteps,
                currentStep: currentStep,
                selections:  selections,
                onSelect:    _onSelect,
                onNext:      _onNext,
                onBack:      _onBack,
              ),
      ),
    );
  }

  void _onSelect(String key, String value) {
    setState(() {
      selections = Map.from(selections)..[key] = value;
      saved = false;
    });
  }

  void _onNext() {
    if (currentStep < _wizardSteps.length - 1) {
      setState(() => currentStep++);
    } else {
      setState(() => showResults = true);
    }
  }

  void _onBack() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  void _onSave() {
    context.read<AuthProvider>().savePreferences(
      prefSpecies: selections['species'] ?? '',
      prefSize:    selections['size']    ?? '',
      prefAge:     selections['age']     ?? '',
      prefGender:  selections['gender']  ?? '',
    );
    setState(() => saved = true);
  }

  void _onAddAllToFavorites() {
    context.read<AuthProvider>().addAllToFavorites(
      matchingPets.map((p) => p.id).toList(),
    );
    setState(() => favoritesAdded = true);
  }

  void _onReset() {
    setState(() {
      selections     = {'species': '', 'size': '', 'age': '', 'gender': ''};
      showResults    = false;
      currentStep    = 0;
      saved          = false;
      favoritesAdded = false;
    });
  }
}

// ── Wizard ────────────────────────────────────────────────────────────────────

class _WizardView extends StatelessWidget {
  final List<_WizardStep> steps;
  final int currentStep;
  final Map<String, String> selections;
  final void Function(String, String) onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _WizardView({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.selections,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final step         = steps[currentStep];
    final selected     = selections[step.key] ?? '';
    final hasSelection = selected.isNotEmpty;
    final isLast       = currentStep == steps.length - 1;
    final progress     = (currentStep + 1) / steps.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value:            progress,
              minHeight:        5,
              backgroundColor:  const Color(0xFFD7CCC8),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF5C4033)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Paso ${currentStep + 1} de ${steps.length}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
          ),

          const SizedBox(height: 16),

          // Header animado
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: _StepHeader(key: ValueKey(currentStep), step: step),
          ),

          const SizedBox(height: 14),

          // Opciones con weight(1) para llenar espacio disponible
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: step.options.map((option) {
                final isSelected = selected == option.value;
                final isSinPref  = option.value == 'Sin preferencia';

                return GestureDetector(
                  onTap: () => onSelect(step.key, option.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color:        isSelected ? const Color(0xFF5C4033) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? null
                          : Border.all(color: const Color(0xFFD7CCC8), width: 0.5),
                      boxShadow: isSelected
                          ? null
                          : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        // Ícono con fondo
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color:        isSelected ? Colors.white24 : option.bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(option.emoji, style: const TextStyle(fontSize: 18))),
                        ),
                        const SizedBox(width: 12),

                        // Textos
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.label,
                                style: TextStyle(
                                  fontSize:   14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color:      isSelected ? Colors.white : const Color(0xFF3E2723),
                                ),
                              ),
                              if (!isSinPref)
                                Text(
                                  option.subtitle,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:    isSelected
                                        ? Colors.white.withOpacity(0.8)
                                        : const Color(0xFF9E9E9E),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Check
                        if (isSelected)
                          Container(
                            width: 20, height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('✓',
                                style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Botones de navegación
          Row(
            children: [
              if (currentStep > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      minimumSize:  const Size.fromHeight(50),
                      shape:        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side:         const BorderSide(color: Color(0xFF5C4033), width: 1.5),
                      foregroundColor: const Color(0xFF5C4033),
                    ),
                    child: const Text('← Atrás', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: hasSelection ? onNext : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize:     const Size.fromHeight(50),
                    shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: hasSelection ? const Color(0xFF5C4033) : const Color(0xFFD7CCC8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD7CCC8),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast ? 'Ver resultados ✓' : 'Siguiente →',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          TextButton(
            onPressed: () {
              onSelect(step.key, 'Sin preferencia');
              onNext();
            },
            child: const Text('Saltar este paso', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12)),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final _WizardStep step;
  const _StepHeader({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: step.headerBgColor, shape: BoxShape.circle),
          child: Center(child: Text(step.headerEmoji, style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(height: 10),
        Text(
          step.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF3E2723), height: 1.35,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          step.subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
        ),
      ],
    );
  }
}

// ── Resultados ────────────────────────────────────────────────────────────────

class _ResultsView extends StatelessWidget {
  final Map<String, String> selections;
  final List<PetPost> matchingPets;
  final bool saved;
  final bool favoritesAdded;
  final VoidCallback onSave;
  final VoidCallback onAddAllToFavorites;
  final VoidCallback onReset;

  const _ResultsView({
    super.key,
    required this.selections,
    required this.matchingPets,
    required this.saved,
    required this.favoritesAdded,
    required this.onSave,
    required this.onAddAllToFavorites,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final activeTags = selections.values
        .where((v) => v.isNotEmpty && v != 'Sin preferencia')
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        // Banner
        Container(
          color: const Color(0xFF5C4033),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Buscás algo así...', style: TextStyle(fontSize: 13, color: Color(0xFFD7CCC8))),
              const SizedBox(height: 10),
              if (activeTags.isEmpty)
                const Text(
                  'Sin filtros — mostrando todas las mascotas',
                  style: TextStyle(fontSize: 13, color: Color(0xFFD7CCC8)),
                )
              else
                Wrap(
                  spacing: 8,
                  children: activeTags.map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                    backgroundColor: Colors.white24,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    side: BorderSide.none,
                  )).toList(),
                ),
            ],
          ),
        ),

        // Contador + botón cambiar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${matchingPets.length} mascotas encontradas',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                  ),
                  const Text('listas para ser adoptadas', style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
                ],
              ),
              OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Color(0xFF5C4033)),
                  foregroundColor: const Color(0xFF5C4033),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: const Text('Cambiar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),

        // Estado vacío
        if (matchingPets.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                const Text('🔍', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                const Text(
                  'No hay mascotas con esas características todavía',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: onReset,
                  child: const Text('Probar con otros filtros', style: TextStyle(color: Color(0xFF5C4033))),
                ),
              ],
            ),
          )
        else
          ...matchingPets.map((pet) => _ResultPetCard(pet: pet)),

        // Botones finales
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            children: [
              if (matchingPets.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onAddAllToFavorites,
                    icon: Icon(favoritesAdded ? Icons.favorite : Icons.favorite_border, size: 18),
                    label: Text(
                      favoritesAdded
                          ? '✓ Agregados a favoritos'
                          : 'Guardar los ${matchingPets.length} en favoritos',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: favoritesAdded ? const Color(0xFF5C4033) : const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onReset,
                child: const Text('Volver a configurar', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Card de resultado ─────────────────────────────────────────────────────────

class _ResultPetCard extends StatelessWidget {
  final PetPost pet;
  const _ResultPetCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pet.imageUrl,
                  width: 72, height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72, height: 72,
                    color: const Color(0xFFEDE0D4),
                    child: const Icon(Icons.pets, color: Color(0xFF5C4033)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF3E2723))),
                    Text(
                      pet.breed.isNotEmpty ? '${pet.species} · ${pet.breed}' : pet.species,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF795548)),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: [
                        if (pet.ageGroup.isNotEmpty) _ResultChip(pet.ageGroup),
                        if (pet.size.isNotEmpty)     _ResultChip(pet.size),
                        if (pet.gender.isNotEmpty)   _ResultChip(pet.gender),
                      ],
                    ),
                    if (pet.city.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('📍 ${pet.city}', style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  final String label;
  const _ResultChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:        const Color(0xFFF5F0EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF5C4033), fontWeight: FontWeight.w500)),
    );
  }
}