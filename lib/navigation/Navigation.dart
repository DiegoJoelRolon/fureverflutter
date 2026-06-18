import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/HomeScreen.dart';
import '../screens/FavoritesScreen.dart';
import '../screens/PreferencesScreen.dart';
import '../screens/ProfileScreen.dart';
import '../providers/PetProvider.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().fetchPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const FavoritesScreen(),
      const PreferencesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFF5F0EB),
        onDestinationSelected: (index) {
          setState(() => currentPageIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon:         Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label:        'Inicio',
          ),
          NavigationDestination(
            icon:         Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label:        'Favoritos',
          ),
          NavigationDestination(
            icon:         Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label:        'Mi match',
          ),
          NavigationDestination(
            icon:         Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label:        'Perfil',
          ),
        ],
      ),
    );
  }
}