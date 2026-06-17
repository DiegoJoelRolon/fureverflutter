// ignore_for_file: file_names, camel_case_types

import 'package:freezed_annotation/freezed_annotation.dart';

part 'AdoptionRequest.freezed.dart';
part 'AdoptionRequest.g.dart';

@freezed
abstract class AdoptionRequest with _$AdoptionRequest {
  const factory AdoptionRequest({

    @Default('')  String id,
    @Default('')  String petId,
    @Default('')  String petName,
    @Default('')  String petImageUrl,
    @Default('')  String requesterId,   // email del solicitante
    @Default('')  String requesterName, // nombre del solicitante
    @Default('')  String ownerId,       // email del dueño
    @Default('pending') String status, // pending / accepted / rejected
    @Default(0)   int timestamp,
  }) = _AdoptionRequest;

  factory AdoptionRequest.fromJson(Map<String, dynamic> json) =>
      _$AdoptionRequestFromJson(json);
}