// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'UploadPetScreen.dart';
import '../models/PetPost.dart';
import '../services/PetPostService.dart';
import '../widgets/PetCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PetPostService _service = PetPostService();
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
             // ── AppBar ──────────────────────────────────────
            SliverToBoxAdapter(child: _buildHeader()),
            // ── Search bar ───────────────────────────────────
            SliverToBoxAdapter(
              
                
                child: _buildSearchBar(),
              
            ),
            // ── Greeting ─────────────────────────────────────
            SliverToBoxAdapter(
              
                child: _buildGreeting(),
              
            ),
             // ── Sección: New comers ──────────────────────────
            SliverToBoxAdapter(
              child: _buildSectionHeader('New comers', Icons.auto_awesome, 5),
            ),


            SliverToBoxAdapter(
              child: _buildHorizontalList(stream: _service.getPosts()),
            ),

            // ── Sección: Dogs ────────────────────────────────
            SliverToBoxAdapter(
              
              
                child: _buildSectionHeader('Dogs', Icons.pets, 2),
              
            ),
            SliverToBoxAdapter(
              child: _buildHorizontalList(
                stream: _service.getPostsBySpecies('Perro'),
              ),
            ),
            SliverToBoxAdapter(
              
                child: _buildSectionHeader('Gatos', Icons.cruelty_free, 3),
              
            ),

            // ── Sección: Cats ────────────────────────────────
            SliverToBoxAdapter(
              child: _buildHorizontalList(
                stream: _service.getPostsBySpecies('Gato'),
              ),
            ),
            // ── Sección: Others ────────────────────────────────
            SliverToBoxAdapter(
              child: _buildSectionHeader('Otro', Icons.pets_outlined, 1),
            ),
            SliverToBoxAdapter(
              child: _buildHorizontalList(
                stream: _service.getPostsBySpecies('Otro'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UploadPetScreen()),
        ),
        backgroundColor: const Color(0xFF4A3728),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF4A3728),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        children: [
          const Icon(Icons.pets, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Text(
            'FurEver',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ──────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search by name, breed or city',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ── Greeting ────────────────────────────────────────────────
  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello Dijoro',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C1A0E),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Find your soulmate',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  // ── Section header ──────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A3728), size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C1A0E),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4A3728),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ── Lista horizontal de cards ───────────────────────────────
  Widget _buildHorizontalList({required Stream<List<PetPost>> stream}) {
    return SizedBox(
      height: 280,
      child: StreamBuilder<List<PetPost>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A3728)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Sin publicaciones aún',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            );
          }
          final posts = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: posts.length,
            itemBuilder: (context, i) => PetCard(post: posts[i]),
          );
        },
      ),
    );
  }
}

