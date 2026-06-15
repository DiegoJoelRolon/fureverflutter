import 'package:flutter/material.dart';

import '../screens/HomeScreen.dart';
import '../screens/FavoritesScreen.dart';
import '../screens/ProfileScreen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int currentPageIndex = 0;

  final List<Widget> pages =[
    HomeScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[currentPageIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },

        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: "Favorites",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}