import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fureverflutter/providers/TranslationProvider.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/AdoptionRequest.dart';
import '../providers/PetProvider.dart';


class AdoptionRequestsScreen extends StatelessWidget {
  const AdoptionRequestsScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();
    final pending = petProvider.pendingRequests;
    final t = context.watch<TranslationProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar marrón ───────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.brown,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                const Text(
                  'Received Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (pending.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  _Badge(count: pending.length),
                ],
              ],
            ),
          ),

          // ── Subtítulo ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                t.translate('receivedRequests'),
                style: TextStyle(fontSize: 13, color: AppColors.grey),
              ),
            ),
          ),

          // ── Contenido ────────────────────────────────────────────────────
          if (pending.isEmpty)
            const SliverFillRemaining(child: _EmptyRequests())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _RequestCard(request: pending[i]),
                  childCount: pending.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Badge rojo
// ─────────────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card de una solicitud
// ─────────────────────────────────────────────────────────────────────────────

class _RequestCard extends StatefulWidget {
  final AdoptionRequest request;
  const _RequestCard({required this.request});

  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard> {
  bool _busy = false;

  Future<void> _handle(bool accept) async {
    setState(() => _busy = true);
    final provider = context.read<PetProvider>();

    try {
      if (accept) {
        await provider.acceptRequest(widget.request);
      } else {
        await provider.rejectRequest(widget.request);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              accept
                  ? '¡Solicitud de ${widget.request.petName} aceptada! 🎉'
                  : 'Solicitud de ${widget.request.petName} rechazada.',
            ),
            backgroundColor:
                accept ? AppColors.green : Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fila: imagen + datos ──────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _PetThumb(imageUrl: r.petImageUrl),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre de mascota
                      Text(
                        r.petName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brownDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // "Requested by"
                      Text(
                        'Requested by',
                        style: TextStyle(fontSize: 12, color: AppColors.grey),
                      ),
                      Text(
                        r.requesterName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brown,
                        ),
                      ),
                      Text(
                        r.requesterId,
                        style: TextStyle(fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Botones Reject / Accept ────────────────────────────────────
            if (_busy)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handle(false),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _handle(true),
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                      ),
                      label: const Text('Accept'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Miniatura de mascota (base64 o URL)
// ─────────────────────────────────────────────────────────────────────────────

class _PetThumb extends StatelessWidget {
  final String imageUrl;
  const _PetThumb({required this.imageUrl});

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageUrl.split(',').last);
        return Image.memory(
          bytes,
          width: _size,
          height: _size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      } catch (_) {}
    }
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: AppColors.brownPale,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.pets, color: AppColors.brown, size: 28),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Estado vacío
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();
  
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TranslationProvider>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppColors.greyLight),
          const SizedBox(height: 16),
          Text(
            t.translate('nopendingrequests'),
            style: TextStyle(color: AppColors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }
}