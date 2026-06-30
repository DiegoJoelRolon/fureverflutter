import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/PetProvider.dart';
import '../providers/TranslationProvider.dart';
import 'PetDetailScreen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t           = context.watch<TranslationProvider>();
    final currentUser = context.watch<AuthProvider>().currentUser;
    final allPets     = context.watch<PetProvider>().pets;

    final favoritePets = allPets
        .where((pet) => currentUser?.favorites.contains(pet.id) == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.translate('myFavorites'),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: favoritePets.isEmpty
          ? _EmptyState()
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                Text(
                  '${favoritePets.length} mascota${favoritePets.length != 1 ? 's' : ''} '
                  'guardada${favoritePets.length != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
                ),
                const SizedBox(height: 12),
                ...favoritePets.map((pet) {
                  final isFav = currentUser?.favorites.contains(pet.id) ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FavoriteCard(
                      pet:         pet,
                      isFav:       isFav,
                      onTap:       () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PetDetailScreen(petId: pet.id),
                        ),
                      ),
                      onToggleFav: () =>
                          context.read<AuthProvider>().toggleFavorite(pet.id),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

// ── Estado vacío ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TranslationProvider>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Color(0xFFD7CCC8)),
          const SizedBox(height: 16),
          Text(
            t.translate('noFavorites'),
            style: const TextStyle(
              fontSize: 16, color: Color(0xFF9E9E9E), fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.translate('noFavorites2'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFFBCAAA4), height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ── Card de favorito ──────────────────────────────────────────────────────────

class _FavoriteCard extends StatelessWidget {
  final dynamic      pet;
  final bool         isFav;
  final VoidCallback onTap;
  final VoidCallback onToggleFav;

  const _FavoriteCard({
    required this.pet,
    required this.isFav,
    required this.onTap,
    required this.onToggleFav,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = pet.adoptedStatus == 'Disponible';

    return Card(
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen (soporta Base64 y URL)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildFavImage(pet.imageUrl as String?),
              ),

              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:   16,
                        color:      Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      (pet.breed as String).isNotEmpty
                          ? '${pet.species} · ${pet.breed}'
                          : pet.species as String,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF795548)),
                    ),
                    if ((pet.city as String).isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Color(0xFF9E9E9E)),
                          const SizedBox(width: 2),
                          Text(
                            pet.city as String,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pet.adoptedStatus as String,
                        style: TextStyle(
                          fontSize:   11,
                          fontWeight: FontWeight.w500,
                          color: isAvailable
                              ? const Color(0xFF388E3C)
                              : const Color(0xFFC62828),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Botón quitar favorito
              IconButton(
                onPressed: onToggleFav,
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? const Color(0xFFC62828) : const Color(0xFF9E9E9E),
                  size:  20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F0EB),
                  shape:           const CircleBorder(),
                  fixedSize:       const Size(40, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper imagen (Base64 + URL) ──────────────────────────────────────────────

Widget _buildFavImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      width: 80, height: 80,
      color: const Color(0xFFEDE0D4),
      child: const Icon(Icons.pets, color: Color(0xFF5C4033)),
    );
  }
  if (imageUrl.startsWith('data:image')) {
    final base64Str = imageUrl.split(',').last;
    return Image.memory(
      base64Decode(base64Str),
      width: 80, height: 80,
      fit:   BoxFit.cover,
    );
  }
  return Image.network(
    imageUrl,
    width: 80, height: 80,
    fit:   BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      width: 80, height: 80,
      color: const Color(0xFFEDE0D4),
      child: const Icon(Icons.pets, color: Color(0xFF5C4033)),
    ),
  );
}