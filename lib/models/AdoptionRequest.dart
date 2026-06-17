import 'package:freezed_annotation/freezed_annotation.dart';

part 'AdoptionRequest.freezed.dart';
part 'AdoptionRequest.g.dart';

@freezed
abstract class AdoptionRequest with _$AdoptionRequest {
  const factory AdoptionRequest({
    @Default('') String id,
    @Default('') String petId,
    @Default('') String petName,
    @Default('') String petImageUrl,
    @Default('') String requesterId,
    @Default('') String requesterName,
    @Default('') String ownerId,
    @Default('pending') String status,
    @Default(0) int timestamp,
  }) = _AdoptionRequest;

  factory AdoptionRequest.fromJson(Map<String, dynamic> json) =>
      _$AdoptionRequestFromJson(json);
}