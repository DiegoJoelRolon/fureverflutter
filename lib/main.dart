import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth/AuthGate.dart';
import 'providers/AuthProvider.dart';
import 'providers/PetProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// ── Colores de FurEver ────────────────────────────────────────────────────────
// Centralizados acá para usarlos desde cualquier pantalla con AppColors.brown
class AppColors {
  static const brown        = Color(0xFF5C4033);  // color principal
  static const brownDark    = Color(0xFF3E2723);  // títulos oscuros
  static const brownLight   = Color(0xFFD7CCC8);  // bordes y elementos suaves
  static const brownPale    = Color(0xFFEDE0D4);  // fondos de chips
  static const background   = Color(0xFFF5F0EB);  // fondo general de pantallas
  static const red          = Color(0xFFC62828);  // estado adoptado / eliminar
  static const green        = Color(0xFF388E3C);  // estado disponible
  static const grey         = Color(0xFF9E9E9E);  // textos secundarios
  static const greyLight    = Color(0xFFBCAAA4);  // textos terciarios
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FurEver',
        theme: _buildTheme(),
        home: const AuthGate(),
      ),
    );
  }

  ThemeData _buildTheme() {
    // ColorScheme define la paleta base que Material 3 usa internamente
    final colorScheme = ColorScheme.fromSeed(
      seedColor:   AppColors.brown,
      primary:     AppColors.brown,
      onPrimary:   Colors.white,
      surface:     Colors.white,
      onSurface:   AppColors.brownDark,
      background:  AppColors.background,
    );

    return ThemeData(
      useMaterial3:  true,
      colorScheme:   colorScheme,

      // ── AppBar ───────────────────────────────────────────────────────────
      // Todas las AppBar van a ser marrones con texto blanco por defecto
      appBarTheme: const AppBarTheme(
        backgroundColor:  AppColors.brown,
        foregroundColor:  Colors.white,
        centerTitle:      false,
        elevation:        0,
        titleTextStyle:   TextStyle(
          color:      Colors.white,
          fontSize:   20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // ── NavigationBar (barra inferior) ───────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:  Colors.white,
        indicatorColor:   AppColors.background,   // fondo del ícono seleccionado
        elevation:        4,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brown, size: 24);
          }
          return const IconThemeData(color: AppColors.brownLight, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color:      AppColors.brown,
              fontSize:   12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color:    AppColors.brownLight,
            fontSize: 12,
          );
        }),
      ),

      // ── ElevatedButton ───────────────────────────────────────────────────
      // Botones principales marrones con texto blanco
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: Colors.white,
          elevation:       0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),

      // ── OutlinedButton ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brown,
          side:            const BorderSide(color: AppColors.brown, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),

      // ── TextButton ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.brown),
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color:     Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),

      // ── Input / TextField ─────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: AppColors.brownLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: AppColors.brown, width: 2),
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.brown),
      ),

      // ── FloatingActionButton ──────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.brown,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // ── Scaffold ──────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Tipografía base ───────────────────────────────────────────────────
      textTheme: const TextTheme(
        titleLarge:  TextStyle(color: AppColors.brownDark, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppColors.brownDark, fontWeight: FontWeight.w600),
        bodyMedium:  TextStyle(color: AppColors.brownDark),
        bodySmall:   TextStyle(color: AppColors.grey),
      ),
    );
  }
}