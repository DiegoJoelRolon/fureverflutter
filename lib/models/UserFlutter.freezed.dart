// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserFlutter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserFlutter {

 String get uid; String get name; String get lastname; String get email; String get phone; String get city; double get latitude; double get longitude; String get profileImageUrl; List<String> get favorites;// IDs de mascotas favoritas
 bool get hasCompletedOnboarding;// si ya hizo el onboarding
 String get prefSpecies;// preferencia especie
 String get prefSize;// preferencia tamaño
 String get prefAge;// preferencia edad
 String get prefGender;
/// Create a copy of UserFlutter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFlutterCopyWith<UserFlutter> get copyWith => _$UserFlutterCopyWithImpl<UserFlutter>(this as UserFlutter, _$identity);

  /// Serializes this UserFlutter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFlutter&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.lastname, lastname) || other.lastname == lastname)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&const DeepCollectionEquality().equals(other.favorites, favorites)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding)&&(identical(other.prefSpecies, prefSpecies) || other.prefSpecies == prefSpecies)&&(identical(other.prefSize, prefSize) || other.prefSize == prefSize)&&(identical(other.prefAge, prefAge) || other.prefAge == prefAge)&&(identical(other.prefGender, prefGender) || other.prefGender == prefGender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,lastname,email,phone,city,latitude,longitude,profileImageUrl,const DeepCollectionEquality().hash(favorites),hasCompletedOnboarding,prefSpecies,prefSize,prefAge,prefGender);

@override
String toString() {
  return 'UserFlutter(uid: $uid, name: $name, lastname: $lastname, email: $email, phone: $phone, city: $city, latitude: $latitude, longitude: $longitude, profileImageUrl: $profileImageUrl, favorites: $favorites, hasCompletedOnboarding: $hasCompletedOnboarding, prefSpecies: $prefSpecies, prefSize: $prefSize, prefAge: $prefAge, prefGender: $prefGender)';
}


}

/// @nodoc
abstract mixin class $UserFlutterCopyWith<$Res>  {
  factory $UserFlutterCopyWith(UserFlutter value, $Res Function(UserFlutter) _then) = _$UserFlutterCopyWithImpl;
@useResult
$Res call({
 String uid, String name, String lastname, String email, String phone, String city, double latitude, double longitude, String profileImageUrl, List<String> favorites, bool hasCompletedOnboarding, String prefSpecies, String prefSize, String prefAge, String prefGender
});




}
/// @nodoc
class _$UserFlutterCopyWithImpl<$Res>
    implements $UserFlutterCopyWith<$Res> {
  _$UserFlutterCopyWithImpl(this._self, this._then);

  final UserFlutter _self;
  final $Res Function(UserFlutter) _then;

/// Create a copy of UserFlutter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? name = null,Object? lastname = null,Object? email = null,Object? phone = null,Object? city = null,Object? latitude = null,Object? longitude = null,Object? profileImageUrl = null,Object? favorites = null,Object? hasCompletedOnboarding = null,Object? prefSpecies = null,Object? prefSize = null,Object? prefAge = null,Object? prefGender = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lastname: null == lastname ? _self.lastname : lastname // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<String>,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,prefSpecies: null == prefSpecies ? _self.prefSpecies : prefSpecies // ignore: cast_nullable_to_non_nullable
as String,prefSize: null == prefSize ? _self.prefSize : prefSize // ignore: cast_nullable_to_non_nullable
as String,prefAge: null == prefAge ? _self.prefAge : prefAge // ignore: cast_nullable_to_non_nullable
as String,prefGender: null == prefGender ? _self.prefGender : prefGender // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFlutter].
extension UserFlutterPatterns on UserFlutter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserFlutter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserFlutter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserFlutter value)  $default,){
final _that = this;
switch (_that) {
case _UserFlutter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserFlutter value)?  $default,){
final _that = this;
switch (_that) {
case _UserFlutter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String name,  String lastname,  String email,  String phone,  String city,  double latitude,  double longitude,  String profileImageUrl,  List<String> favorites,  bool hasCompletedOnboarding,  String prefSpecies,  String prefSize,  String prefAge,  String prefGender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserFlutter() when $default != null:
return $default(_that.uid,_that.name,_that.lastname,_that.email,_that.phone,_that.city,_that.latitude,_that.longitude,_that.profileImageUrl,_that.favorites,_that.hasCompletedOnboarding,_that.prefSpecies,_that.prefSize,_that.prefAge,_that.prefGender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String name,  String lastname,  String email,  String phone,  String city,  double latitude,  double longitude,  String profileImageUrl,  List<String> favorites,  bool hasCompletedOnboarding,  String prefSpecies,  String prefSize,  String prefAge,  String prefGender)  $default,) {final _that = this;
switch (_that) {
case _UserFlutter():
return $default(_that.uid,_that.name,_that.lastname,_that.email,_that.phone,_that.city,_that.latitude,_that.longitude,_that.profileImageUrl,_that.favorites,_that.hasCompletedOnboarding,_that.prefSpecies,_that.prefSize,_that.prefAge,_that.prefGender);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String name,  String lastname,  String email,  String phone,  String city,  double latitude,  double longitude,  String profileImageUrl,  List<String> favorites,  bool hasCompletedOnboarding,  String prefSpecies,  String prefSize,  String prefAge,  String prefGender)?  $default,) {final _that = this;
switch (_that) {
case _UserFlutter() when $default != null:
return $default(_that.uid,_that.name,_that.lastname,_that.email,_that.phone,_that.city,_that.latitude,_that.longitude,_that.profileImageUrl,_that.favorites,_that.hasCompletedOnboarding,_that.prefSpecies,_that.prefSize,_that.prefAge,_that.prefGender);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserFlutter implements UserFlutter {
  const _UserFlutter({this.uid = '', this.name = '', this.lastname = '', this.email = '', this.phone = '', this.city = '', this.latitude = 0.0, this.longitude = 0.0, this.profileImageUrl = '', final  List<String> favorites = const [], this.hasCompletedOnboarding = false, this.prefSpecies = '', this.prefSize = '', this.prefAge = '', this.prefGender = ''}): _favorites = favorites;
  factory _UserFlutter.fromJson(Map<String, dynamic> json) => _$UserFlutterFromJson(json);

@override@JsonKey() final  String uid;
@override@JsonKey() final  String name;
@override@JsonKey() final  String lastname;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String city;
@override@JsonKey() final  double latitude;
@override@JsonKey() final  double longitude;
@override@JsonKey() final  String profileImageUrl;
 final  List<String> _favorites;
@override@JsonKey() List<String> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}

// IDs de mascotas favoritas
@override@JsonKey() final  bool hasCompletedOnboarding;
// si ya hizo el onboarding
@override@JsonKey() final  String prefSpecies;
// preferencia especie
@override@JsonKey() final  String prefSize;
// preferencia tamaño
@override@JsonKey() final  String prefAge;
// preferencia edad
@override@JsonKey() final  String prefGender;

/// Create a copy of UserFlutter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserFlutterCopyWith<_UserFlutter> get copyWith => __$UserFlutterCopyWithImpl<_UserFlutter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserFlutterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserFlutter&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.lastname, lastname) || other.lastname == lastname)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&const DeepCollectionEquality().equals(other._favorites, _favorites)&&(identical(other.hasCompletedOnboarding, hasCompletedOnboarding) || other.hasCompletedOnboarding == hasCompletedOnboarding)&&(identical(other.prefSpecies, prefSpecies) || other.prefSpecies == prefSpecies)&&(identical(other.prefSize, prefSize) || other.prefSize == prefSize)&&(identical(other.prefAge, prefAge) || other.prefAge == prefAge)&&(identical(other.prefGender, prefGender) || other.prefGender == prefGender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,lastname,email,phone,city,latitude,longitude,profileImageUrl,const DeepCollectionEquality().hash(_favorites),hasCompletedOnboarding,prefSpecies,prefSize,prefAge,prefGender);

@override
String toString() {
  return 'UserFlutter(uid: $uid, name: $name, lastname: $lastname, email: $email, phone: $phone, city: $city, latitude: $latitude, longitude: $longitude, profileImageUrl: $profileImageUrl, favorites: $favorites, hasCompletedOnboarding: $hasCompletedOnboarding, prefSpecies: $prefSpecies, prefSize: $prefSize, prefAge: $prefAge, prefGender: $prefGender)';
}


}

/// @nodoc
abstract mixin class _$UserFlutterCopyWith<$Res> implements $UserFlutterCopyWith<$Res> {
  factory _$UserFlutterCopyWith(_UserFlutter value, $Res Function(_UserFlutter) _then) = __$UserFlutterCopyWithImpl;
@override @useResult
$Res call({
 String uid, String name, String lastname, String email, String phone, String city, double latitude, double longitude, String profileImageUrl, List<String> favorites, bool hasCompletedOnboarding, String prefSpecies, String prefSize, String prefAge, String prefGender
});




}
/// @nodoc
class __$UserFlutterCopyWithImpl<$Res>
    implements _$UserFlutterCopyWith<$Res> {
  __$UserFlutterCopyWithImpl(this._self, this._then);

  final _UserFlutter _self;
  final $Res Function(_UserFlutter) _then;

/// Create a copy of UserFlutter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? lastname = null,Object? email = null,Object? phone = null,Object? city = null,Object? latitude = null,Object? longitude = null,Object? profileImageUrl = null,Object? favorites = null,Object? hasCompletedOnboarding = null,Object? prefSpecies = null,Object? prefSize = null,Object? prefAge = null,Object? prefGender = null,}) {
  return _then(_UserFlutter(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lastname: null == lastname ? _self.lastname : lastname // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<String>,hasCompletedOnboarding: null == hasCompletedOnboarding ? _self.hasCompletedOnboarding : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
as bool,prefSpecies: null == prefSpecies ? _self.prefSpecies : prefSpecies // ignore: cast_nullable_to_non_nullable
as String,prefSize: null == prefSize ? _self.prefSize : prefSize // ignore: cast_nullable_to_non_nullable
as String,prefAge: null == prefAge ? _self.prefAge : prefAge // ignore: cast_nullable_to_non_nullable
as String,prefGender: null == prefGender ? _self.prefGender : prefGender // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
