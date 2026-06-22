import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../translations/Translations.dart';

class TranslationProvider extends ChangeNotifier {
  static const String _langKey = 'selected_language';

  String _currentLanguage = 'es';

  String get currentLanguage => _currentLanguage;

  TranslationProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_langKey);

    if (saved != null) {
      // Si el usuario eligió un idioma manualmente, respetarlo
      _currentLanguage = saved;
    } else {
      // Si no, usar el idioma del dispositivo
      final deviceLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      _currentLanguage = Translations.translations.containsKey(deviceLang)
          ? deviceLang
          : 'es'; // fallback a español si el idioma no está soportado
    }

    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    if (_currentLanguage == langCode) return;
    _currentLanguage = langCode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  String translate(String key) {
    return Translations.translations[_currentLanguage]?[key]
        ?? Translations.translations['es']?[key]
        ?? key;
  }
}