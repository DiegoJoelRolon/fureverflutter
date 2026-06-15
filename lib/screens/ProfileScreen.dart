// ignore_for_file: file_names

import 'package:flutter/material.dart';


import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text("Cerrar sesión"),
        ),
      ),
    );
  }
}