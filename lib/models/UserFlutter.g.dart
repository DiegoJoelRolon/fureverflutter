// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

part of 'UserFlutter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserFlutter _$UserFlutterFromJson(Map<String, dynamic> json) => _UserFlutter(
  uid: json['uid'] as String? ?? '',
  name: json['name'] as String? ?? '',
  lastname: json['lastname'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  city: json['city'] as String? ?? '',
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
  profileImageUrl: json['profileImageUrl'] as String? ?? '',
  favorites:
      (json['favorites'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
  prefSpecies: json['prefSpecies'] as String? ?? '',
  prefSize: json['prefSize'] as String? ?? '',
  prefAge: json['prefAge'] as String? ?? '',
  prefGender: json['prefGender'] as String? ?? '',
);

Map<String, dynamic> _$UserFlutterToJson(_UserFlutter instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'lastname': instance.lastname,
      'email': instance.email,
      'phone': instance.phone,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'profileImageUrl': instance.profileImageUrl,
      'favorites': instance.favorites,
      'hasCompletedOnboarding': instance.hasCompletedOnboarding,
      'prefSpecies': instance.prefSpecies,
      'prefSize': instance.prefSize,
      'prefAge': instance.prefAge,
      'prefGender': instance.prefGender,
    };
