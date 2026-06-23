// lib/utils/LocationHelper.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String city;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.city,
  });
}

class LocationHelper {
  /// Pide permiso, obtiene la posición actual y la convierte a ciudad.
  /// Lanza una excepción con un mensaje legible si algo falla.
  static Future<LocationResult> getCurrentLocation() async {
    // 1. Verificar que el GPS del dispositivo esté encendido
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('El GPS está desactivado. Activalo para continuar.');
    }

    // 2. Verificar y pedir permiso
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permiso de ubicación denegado.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'El permiso de ubicación está bloqueado. Habilitalo desde los ajustes del dispositivo.',
      );
    }

    // 3. Obtener coordenadas actuales
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    // 4. Geocoding inverso: de lat/lng a nombre de ciudad
    String city = '';
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // locality = ciudad; si viene vacío, se usa subAdministrativeArea
        city = place.locality?.isNotEmpty == true
            ? place.locality!
            : (place.subAdministrativeArea ?? '');
      }
    } catch (_) {
      // Si el geocoding falla, igual devolvemos las coordenadas sin ciudad
    }

    return LocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
    );
  }
}