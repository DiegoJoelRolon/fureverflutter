// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'PetPost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetPost {

 String get id; String get name; String get species; String get breed; String get gender; String get size; String get ageGroup; String get description; String get imageUrl; List<String> get images; String get ownerId; String get ownerPhone; int get timestamp; String get adoptedStatus; String get city; double get latitude; double get longitude; String get adopterEmail; String get adopterPhone;
/// Create a copy of PetPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetPostCopyWith<PetPost> get copyWith => _$PetPostCopyWithImpl<PetPost>(this as PetPost, _$identity);

  /// Serializes this PetPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetPost&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.species, species) || other.species == species)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.size, size) || other.size == size)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerPhone, ownerPhone) || other.ownerPhone == ownerPhone)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.adoptedStatus, adoptedStatus) || other.adoptedStatus == adoptedStatus)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.adopterEmail, adopterEmail) || other.adopterEmail == adopterEmail)&&(identical(other.adopterPhone, adopterPhone) || other.adopterPhone == adopterPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,species,breed,gender,size,ageGroup,description,imageUrl,const DeepCollectionEquality().hash(images),ownerId,ownerPhone,timestamp,adoptedStatus,city,latitude,longitude,adopterEmail,adopterPhone]);

@override
String toString() {
  return 'PetPost(id: $id, name: $name, species: $species, breed: $breed, gender: $gender, size: $size, ageGroup: $ageGroup, description: $description, imageUrl: $imageUrl, images: $images, ownerId: $ownerId, ownerPhone: $ownerPhone, timestamp: $timestamp, adoptedStatus: $adoptedStatus, city: $city, latitude: $latitude, longitude: $longitude, adopterEmail: $adopterEmail, adopterPhone: $adopterPhone)';
}


}

/// @nodoc
abstract mixin class $PetPostCopyWith<$Res>  {
  factory $PetPostCopyWith(PetPost value, $Res Function(PetPost) _then) = _$PetPostCopyWithImpl;
@useResult
$Res call({
 String id, String name, String species, String breed, String gender, String size, String ageGroup, String description, String imageUrl, List<String> images, String ownerId, String ownerPhone, int timestamp, String adoptedStatus, String city, double latitude, double longitude, String adopterEmail, String adopterPhone
});




}
/// @nodoc
class _$PetPostCopyWithImpl<$Res>
    implements $PetPostCopyWith<$Res> {
  _$PetPostCopyWithImpl(this._self, this._then);

  final PetPost _self;
  final $Res Function(PetPost) _then;

/// Create a copy of PetPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? species = null,Object? breed = null,Object? gender = null,Object? size = null,Object? ageGroup = null,Object? description = null,Object? imageUrl = null,Object? images = null,Object? ownerId = null,Object? ownerPhone = null,Object? timestamp = null,Object? adoptedStatus = null,Object? city = null,Object? latitude = null,Object? longitude = null,Object? adopterEmail = null,Object? adopterPhone = null,}) {
  return _then(PetPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,ageGroup: null == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,ownerPhone: null == ownerPhone ? _self.ownerPhone : ownerPhone // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,adoptedStatus: null == adoptedStatus ? _self.adoptedStatus : adoptedStatus // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,adopterEmail: null == adopterEmail ? _self.adopterEmail : adopterEmail // ignore: cast_nullable_to_non_nullable
as String,adopterPhone: null == adopterPhone ? _self.adopterPhone : adopterPhone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PetPost].
extension PetPostPatterns on PetPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PetPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PetPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PetPost value)  $default,){
final _that = this;
switch (_that) {
case _PetPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PetPost value)?  $default,){
final _that = this;
switch (_that) {
case _PetPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String species,  String breed,  String gender,  String size,  String ageGroup,  String description,  String imageUrl,  List<String> images,  String ownerId,  String ownerPhone,  int timestamp,  String adoptedStatus,  String city,  double latitude,  double longitude,  String adopterEmail,  String adopterPhone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PetPost() when $default != null:
return $default(_that.id,_that.name,_that.species,_that.breed,_that.gender,_that.size,_that.ageGroup,_that.description,_that.imageUrl,_that.images,_that.ownerId,_that.ownerPhone,_that.timestamp,_that.adoptedStatus,_that.city,_that.latitude,_that.longitude,_that.adopterEmail,_that.adopterPhone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String species,  String breed,  String gender,  String size,  String ageGroup,  String description,  String imageUrl,  List<String> images,  String ownerId,  String ownerPhone,  int timestamp,  String adoptedStatus,  String city,  double latitude,  double longitude,  String adopterEmail,  String adopterPhone)  $default,) {final _that = this;
switch (_that) {
case _PetPost():
return $default(_that.id,_that.name,_that.species,_that.breed,_that.gender,_that.size,_that.ageGroup,_that.description,_that.imageUrl,_that.images,_that.ownerId,_that.ownerPhone,_that.timestamp,_that.adoptedStatus,_that.city,_that.latitude,_that.longitude,_that.adopterEmail,_that.adopterPhone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String species,  String breed,  String gender,  String size,  String ageGroup,  String description,  String imageUrl,  List<String> images,  String ownerId,  String ownerPhone,  int timestamp,  String adoptedStatus,  String city,  double latitude,  double longitude,  String adopterEmail,  String adopterPhone)?  $default,) {final _that = this;
switch (_that) {
case _PetPost() when $default != null:
return $default(_that.id,_that.name,_that.species,_that.breed,_that.gender,_that.size,_that.ageGroup,_that.description,_that.imageUrl,_that.images,_that.ownerId,_that.ownerPhone,_that.timestamp,_that.adoptedStatus,_that.city,_that.latitude,_that.longitude,_that.adopterEmail,_that.adopterPhone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PetPost implements PetPost {
  const _PetPost({this.id = '', this.name = '', this.species = '', this.breed = '', this.gender = '', this.size = '', this.ageGroup = '', this.description = '', this.imageUrl = '',  List<String> images = const [], this.ownerId = '', this.ownerPhone = '', this.timestamp = 0, this.adoptedStatus = 'Disponible', this.city = '', this.latitude = 0.0, this.longitude = 0.0, this.adopterEmail = '', this.adopterPhone = ''}): _images = images;
  factory _PetPost.fromJson(Map<String, dynamic> json) => _$PetPostFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String species;
@override@JsonKey() final  String breed;
@override@JsonKey() final  String gender;
@override@JsonKey() final  String size;
@override@JsonKey() final  String ageGroup;
@override@JsonKey() final  String description;
@override@JsonKey() final  String imageUrl;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override@JsonKey() final  String ownerId;
@override@JsonKey() final  String ownerPhone;
@override@JsonKey() final  int timestamp;
@override@JsonKey() final  String adoptedStatus;
@override@JsonKey() final  String city;
@override@JsonKey() final  double latitude;
@override@JsonKey() final  double longitude;
@override@JsonKey() final  String adopterEmail;
@override@JsonKey() final  String adopterPhone;

/// Create a copy of PetPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetPostCopyWith<_PetPost> get copyWith => __$PetPostCopyWithImpl<_PetPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetPost&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.species, species) || other.species == species)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.size, size) || other.size == size)&&(identical(other.ageGroup, ageGroup) || other.ageGroup == ageGroup)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerPhone, ownerPhone) || other.ownerPhone == ownerPhone)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.adoptedStatus, adoptedStatus) || other.adoptedStatus == adoptedStatus)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.adopterEmail, adopterEmail) || other.adopterEmail == adopterEmail)&&(identical(other.adopterPhone, adopterPhone) || other.adopterPhone == adopterPhone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,species,breed,gender,size,ageGroup,description,imageUrl,const DeepCollectionEquality().hash(_images),ownerId,ownerPhone,timestamp,adoptedStatus,city,latitude,longitude,adopterEmail,adopterPhone]);

@override
String toString() {
  return 'PetPost(id: $id, name: $name, species: $species, breed: $breed, gender: $gender, size: $size, ageGroup: $ageGroup, description: $description, imageUrl: $imageUrl, images: $images, ownerId: $ownerId, ownerPhone: $ownerPhone, timestamp: $timestamp, adoptedStatus: $adoptedStatus, city: $city, latitude: $latitude, longitude: $longitude, adopterEmail: $adopterEmail, adopterPhone: $adopterPhone)';
}


}

/// @nodoc
abstract mixin class _$PetPostCopyWith<$Res> implements $PetPostCopyWith<$Res> {
  factory _$PetPostCopyWith(_PetPost value, $Res Function(_PetPost) _then) = __$PetPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String species, String breed, String gender, String size, String ageGroup, String description, String imageUrl, List<String> images, String ownerId, String ownerPhone, int timestamp, String adoptedStatus, String city, double latitude, double longitude, String adopterEmail, String adopterPhone
});




}
/// @nodoc
class __$PetPostCopyWithImpl<$Res>
    implements _$PetPostCopyWith<$Res> {
  __$PetPostCopyWithImpl(this._self, this._then);

  final _PetPost _self;
  final $Res Function(_PetPost) _then;

/// Create a copy of PetPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? species = null,Object? breed = null,Object? gender = null,Object? size = null,Object? ageGroup = null,Object? description = null,Object? imageUrl = null,Object? images = null,Object? ownerId = null,Object? ownerPhone = null,Object? timestamp = null,Object? adoptedStatus = null,Object? city = null,Object? latitude = null,Object? longitude = null,Object? adopterEmail = null,Object? adopterPhone = null,}) {
  return _then(_PetPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,ageGroup: null == ageGroup ? _self.ageGroup : ageGroup // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,ownerPhone: null == ownerPhone ? _self.ownerPhone : ownerPhone // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,adoptedStatus: null == adoptedStatus ? _self.adoptedStatus : adoptedStatus // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,adopterEmail: null == adopterEmail ? _self.adopterEmail : adopterEmail // ignore: cast_nullable_to_non_nullable
as String,adopterPhone: null == adopterPhone ? _self.adopterPhone : adopterPhone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
