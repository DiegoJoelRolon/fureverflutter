import 'package:freezed_annotation/freezed_annotation.dart';

part 'UserFlutter.freezed.dart';
part 'UserFlutter.g.dart';

@freezed
abstract class UserFlutter with _$UserFlutter {
  const factory UserFlutter({
    @Default('') String uid,
    @Default('') String name,
    @Default('') String lastname,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String city,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default('') String profileImageUrl,
    @Default([]) List<String> favorites,        // IDs de mascotas favoritas
    @Default(false) bool hasCompletedOnboarding, // si ya hizo el onboarding
    @Default('') String prefSpecies,             // preferencia especie
    @Default('') String prefSize,               // preferencia tamaño
    @Default('') String prefAge,                // preferencia edad
    @Default('') String prefGender,             // preferencia género
  }) = _UserFlutter;

  factory UserFlutter.fromJson(Map<String, dynamic> json) =>
      _$UserFlutterFromJson(json);
}