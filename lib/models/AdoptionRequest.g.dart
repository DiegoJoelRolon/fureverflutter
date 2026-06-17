// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: file_names

part of 'AdoptionRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdoptionRequest _$AdoptionRequestFromJson(Map<String, dynamic> json) =>
    _AdoptionRequest(
      id: json['id'] as String? ?? '',
      petId: json['petId'] as String? ?? '',
      petName: json['petName'] as String? ?? '',
      petImageUrl: json['petImageUrl'] as String? ?? '',
      requesterId: json['requesterId'] as String? ?? '',
      requesterName: json['requesterName'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdoptionRequestToJson(_AdoptionRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'petId': instance.petId,
      'petName': instance.petName,
      'petImageUrl': instance.petImageUrl,
      'requesterId': instance.requesterId,
      'requesterName': instance.requesterName,
      'ownerId': instance.ownerId,
      'status': instance.status,
      'timestamp': instance.timestamp,
    };
