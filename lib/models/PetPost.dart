import 'package:freezed_annotation/freezed_annotation.dart';

part 'PetPost.freezed.dart';
part 'PetPost.g.dart';

@freezed
abstract class PetPost with _$PetPost {
  const factory PetPost({
    @Default('') String id,
    @Default('') String name,
    @Default('') String species,
    @Default('') String breed,
    @Default('') String gender,
    @Default('') String size,
    @Default('') String ageGroup,
    @Default('') String description,
    @Default('') String imageUrl,
    @Default([]) List<String> images,
    @Default('') String ownerId,
    @Default('') String ownerPhone,
    @Default(0) int timestamp,
    @Default('Disponible') String adoptedStatus,
    @Default('') String city,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default('') String adopterEmail,
    @Default('') String adopterPhone,
  }) = _PetPost;

  factory PetPost.fromJson(Map<String, dynamic> json) =>
      _$PetPostFromJson(json);
}