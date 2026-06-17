// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../models/PetPost.dart';

class PetCard extends StatefulWidget {
  final PetPost post;
  const PetCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: widget.post.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.post.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => _liked = !_liked),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _liked ? Icons.favorite : Icons.favorite_outline,
                      size: 18,
                      color: _liked ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF2C1A0E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.post.breed.isNotEmpty)
                  Text(
                    widget.post.breed,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (widget.post.ageGroup.isNotEmpty)
                      _Tag(Icons.cake_outlined, widget.post.ageGroup),
                    if (widget.post.size.isNotEmpty)
                      _Tag(Icons.straighten, widget.post.size),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: Colors.grey),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        widget.post.city,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE0D5CC),
      child: const Center(
        child: Icon(Icons.pets, size: 48, color: Colors.white),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: const Color(0xFF4A3728)),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF4A3728),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}