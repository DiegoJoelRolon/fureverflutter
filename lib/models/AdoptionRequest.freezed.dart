// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'AdoptionRequest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdoptionRequest {

 String get id; String get petId; String get petName; String get petImageUrl; String get requesterId;// email del solicitante
 String get requesterName;// nombre del solicitante
 String get ownerId;// email del dueño
 String get status;// pending / accepted / rejected
 int get timestamp;
/// Create a copy of AdoptionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdoptionRequestCopyWith<AdoptionRequest> get copyWith => _$AdoptionRequestCopyWithImpl<AdoptionRequest>(this as AdoptionRequest, _$identity);

  /// Serializes this AdoptionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdoptionRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.petId, petId) || other.petId == petId)&&(identical(other.petName, petName) || other.petName == petName)&&(identical(other.petImageUrl, petImageUrl) || other.petImageUrl == petImageUrl)&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,petId,petName,petImageUrl,requesterId,requesterName,ownerId,status,timestamp);

@override
String toString() {
  return 'AdoptionRequest(id: $id, petId: $petId, petName: $petName, petImageUrl: $petImageUrl, requesterId: $requesterId, requesterName: $requesterName, ownerId: $ownerId, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AdoptionRequestCopyWith<$Res>  {
  factory $AdoptionRequestCopyWith(AdoptionRequest value, $Res Function(AdoptionRequest) _then) = _$AdoptionRequestCopyWithImpl;
@useResult
$Res call({
 String id, String petId, String petName, String petImageUrl, String requesterId, String requesterName, String ownerId, String status, int timestamp
});




}
/// @nodoc
class _$AdoptionRequestCopyWithImpl<$Res>
    implements $AdoptionRequestCopyWith<$Res> {
  _$AdoptionRequestCopyWithImpl(this._self, this._then);

  final AdoptionRequest _self;
  final $Res Function(AdoptionRequest) _then;

/// Create a copy of AdoptionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? petId = null,Object? petName = null,Object? petImageUrl = null,Object? requesterId = null,Object? requesterName = null,Object? ownerId = null,Object? status = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,petId: null == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as String,petName: null == petName ? _self.petName : petName // ignore: cast_nullable_to_non_nullable
as String,petImageUrl: null == petImageUrl ? _self.petImageUrl : petImageUrl // ignore: cast_nullable_to_non_nullable
as String,requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdoptionRequest].
extension AdoptionRequestPatterns on AdoptionRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdoptionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdoptionRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdoptionRequest value)  $default,){
final _that = this;
switch (_that) {
case _AdoptionRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdoptionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AdoptionRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String petId,  String petName,  String petImageUrl,  String requesterId,  String requesterName,  String ownerId,  String status,  int timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdoptionRequest() when $default != null:
return $default(_that.id,_that.petId,_that.petName,_that.petImageUrl,_that.requesterId,_that.requesterName,_that.ownerId,_that.status,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String petId,  String petName,  String petImageUrl,  String requesterId,  String requesterName,  String ownerId,  String status,  int timestamp)  $default,) {final _that = this;
switch (_that) {
case _AdoptionRequest():
return $default(_that.id,_that.petId,_that.petName,_that.petImageUrl,_that.requesterId,_that.requesterName,_that.ownerId,_that.status,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String petId,  String petName,  String petImageUrl,  String requesterId,  String requesterName,  String ownerId,  String status,  int timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AdoptionRequest() when $default != null:
return $default(_that.id,_that.petId,_that.petName,_that.petImageUrl,_that.requesterId,_that.requesterName,_that.ownerId,_that.status,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdoptionRequest implements AdoptionRequest {
  const _AdoptionRequest({this.id = '', this.petId = '', this.petName = '', this.petImageUrl = '', this.requesterId = '', this.requesterName = '', this.ownerId = '', this.status = 'pending', this.timestamp = 0});
  factory _AdoptionRequest.fromJson(Map<String, dynamic> json) => _$AdoptionRequestFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String petId;
@override@JsonKey() final  String petName;
@override@JsonKey() final  String petImageUrl;
@override@JsonKey() final  String requesterId;
// email del solicitante
@override@JsonKey() final  String requesterName;
// nombre del solicitante
@override@JsonKey() final  String ownerId;
// email del dueño
@override@JsonKey() final  String status;
// pending / accepted / rejected
@override@JsonKey() final  int timestamp;

/// Create a copy of AdoptionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdoptionRequestCopyWith<_AdoptionRequest> get copyWith => __$AdoptionRequestCopyWithImpl<_AdoptionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdoptionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdoptionRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.petId, petId) || other.petId == petId)&&(identical(other.petName, petName) || other.petName == petName)&&(identical(other.petImageUrl, petImageUrl) || other.petImageUrl == petImageUrl)&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,petId,petName,petImageUrl,requesterId,requesterName,ownerId,status,timestamp);

@override
String toString() {
  return 'AdoptionRequest(id: $id, petId: $petId, petName: $petName, petImageUrl: $petImageUrl, requesterId: $requesterId, requesterName: $requesterName, ownerId: $ownerId, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AdoptionRequestCopyWith<$Res> implements $AdoptionRequestCopyWith<$Res> {
  factory _$AdoptionRequestCopyWith(_AdoptionRequest value, $Res Function(_AdoptionRequest) _then) = __$AdoptionRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String petId, String petName, String petImageUrl, String requesterId, String requesterName, String ownerId, String status, int timestamp
});




}
/// @nodoc
class __$AdoptionRequestCopyWithImpl<$Res>
    implements _$AdoptionRequestCopyWith<$Res> {
  __$AdoptionRequestCopyWithImpl(this._self, this._then);

  final _AdoptionRequest _self;
  final $Res Function(_AdoptionRequest) _then;

/// Create a copy of AdoptionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? petId = null,Object? petName = null,Object? petImageUrl = null,Object? requesterId = null,Object? requesterName = null,Object? ownerId = null,Object? status = null,Object? timestamp = null,}) {
  return _then(_AdoptionRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,petId: null == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as String,petName: null == petName ? _self.petName : petName // ignore: cast_nullable_to_non_nullable
as String,petImageUrl: null == petImageUrl ? _self.petImageUrl : petImageUrl // ignore: cast_nullable_to_non_nullable
as String,requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
