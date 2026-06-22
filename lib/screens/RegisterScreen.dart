// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fureverflutter/providers/TranslationProvider.dart';
import 'package:provider/provider.dart';

import '../models/UserFlutter.dart';
import '../auth/AuthService.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();

  bool loading = false;

  double latitude = 0;
  double longitude = 0;

  @override
  void dispose() {

    nameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    cityController.dispose();

    super.dispose();
  }

  Future<void> register() async {

    try {

      setState(() => loading = true);

      final user = UserFlutter(
        name: nameController.text.trim(),
        lastname: lastnameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
        latitude: latitude,
        longitude: longitude,
      );

      await AuthService().signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        user: user,
      );

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    } finally {

      if (mounted) {
        setState(() => loading = false);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<TranslationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F0EC),

      appBar: AppBar(
        title:  Text(t.translate('createaccount')),
      ),

      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: Card(
            elevation: 6,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),

            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [

                  TextField(
                    controller: nameController,
                    decoration:  InputDecoration(
                      hintText: t.translate('firstname'),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      hintText: t.translate('lastname'), //"Last Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      hintText: t.translate('password'), //"Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration:  InputDecoration(
                      hintText: t.translate('phone'), //"Phone",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          controller: cityController,
                          decoration:  InputDecoration(
                            hintText: t.translate('city'), //"City",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      OutlinedButton(
                        onPressed: () {

                          // Acá después agregás Geolocator

                        },
                        child: const Text("GPS"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: loading ? null : register,

                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: loading
                            ? const CircularProgressIndicator()
                            :  Text(t.translate('signup')),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:  Text(
                      t.translate('alreadyhaveaccount'), //"Already have an account? Sign in",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
