// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PetPost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetPost _$PetPostFromJson(Map<String, dynamic> json) => _PetPost(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  species: json['species'] as String? ?? '',
  breed: json['breed'] as String? ?? '',
  gender: json['gender'] as String? ?? '',
  size: json['size'] as String? ?? '',
  ageGroup: json['ageGroup'] as String? ?? '',
  description: json['description'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  ownerId: json['ownerId'] as String? ?? '',
  ownerPhone: json['ownerPhone'] as String? ?? '',
  timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
  adoptedStatus: json['adoptedStatus'] as String? ?? 'Disponible',
  city: json['city'] as String? ?? '',
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
  adopterEmail: json['adopterEmail'] as String? ?? '',
  adopterPhone: json['adopterPhone'] as String? ?? '',
);

Map<String, dynamic> _$PetPostToJson(_PetPost instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'species': instance.species,
  'breed': instance.breed,
  'gender': instance.gender,
  'size': instance.size,
  'ageGroup': instance.ageGroup,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'images': instance.images,
  'ownerId': instance.ownerId,
  'ownerPhone': instance.ownerPhone,
  'timestamp': instance.timestamp,
  'adoptedStatus': instance.adoptedStatus,
  'city': instance.city,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'adopterEmail': instance.adopterEmail,
  'adopterPhone': instance.adopterPhone,
};
