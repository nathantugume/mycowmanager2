// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Breed {

 String get id; String get name;/// Foreign‑key to farm
 String get farmId; String get farmName;/// ISO‑8601 timestamps (nullable if not set yet)
 String? get createdOn; String? get updatedOn;
/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedCopyWith<Breed> get copyWith => _$BreedCopyWithImpl<Breed>(this as Breed, _$identity);

  /// Serializes this Breed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Breed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,farmId,farmName,createdOn,updatedOn);

@override
String toString() {
  return 'Breed(id: $id, name: $name, farmId: $farmId, farmName: $farmName, createdOn: $createdOn, updatedOn: $updatedOn)';
}


}

/// @nodoc
abstract mixin class $BreedCopyWith<$Res>  {
  factory $BreedCopyWith(Breed value, $Res Function(Breed) _then) = _$BreedCopyWithImpl;
@useResult
$Res call({
 String id, String name, String farmId, String farmName, String? createdOn, String? updatedOn
});




}
/// @nodoc
class _$BreedCopyWithImpl<$Res>
    implements $BreedCopyWith<$Res> {
  _$BreedCopyWithImpl(this._self, this._then);

  final Breed _self;
  final $Res Function(Breed) _then;

/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? farmId = null,Object? farmName = null,Object? createdOn = freezed,Object? updatedOn = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,updatedOn: freezed == updatedOn ? _self.updatedOn : updatedOn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Breed].
extension BreedPatterns on Breed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Breed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Breed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Breed value)  $default,){
final _that = this;
switch (_that) {
case _Breed():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Breed value)?  $default,){
final _that = this;
switch (_that) {
case _Breed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String farmId,  String farmName,  String? createdOn,  String? updatedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Breed() when $default != null:
return $default(_that.id,_that.name,_that.farmId,_that.farmName,_that.createdOn,_that.updatedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String farmId,  String farmName,  String? createdOn,  String? updatedOn)  $default,) {final _that = this;
switch (_that) {
case _Breed():
return $default(_that.id,_that.name,_that.farmId,_that.farmName,_that.createdOn,_that.updatedOn);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String farmId,  String farmName,  String? createdOn,  String? updatedOn)?  $default,) {final _that = this;
switch (_that) {
case _Breed() when $default != null:
return $default(_that.id,_that.name,_that.farmId,_that.farmName,_that.createdOn,_that.updatedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Breed implements Breed {
  const _Breed({required this.id, required this.name, required this.farmId, required this.farmName, this.createdOn, this.updatedOn});
  factory _Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);

@override final  String id;
@override final  String name;
/// Foreign‑key to farm
@override final  String farmId;
@override final  String farmName;
/// ISO‑8601 timestamps (nullable if not set yet)
@override final  String? createdOn;
@override final  String? updatedOn;

/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedCopyWith<_Breed> get copyWith => __$BreedCopyWithImpl<_Breed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Breed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,farmId,farmName,createdOn,updatedOn);

@override
String toString() {
  return 'Breed(id: $id, name: $name, farmId: $farmId, farmName: $farmName, createdOn: $createdOn, updatedOn: $updatedOn)';
}


}

/// @nodoc
abstract mixin class _$BreedCopyWith<$Res> implements $BreedCopyWith<$Res> {
  factory _$BreedCopyWith(_Breed value, $Res Function(_Breed) _then) = __$BreedCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String farmId, String farmName, String? createdOn, String? updatedOn
});




}
/// @nodoc
class __$BreedCopyWithImpl<$Res>
    implements _$BreedCopyWith<$Res> {
  __$BreedCopyWithImpl(this._self, this._then);

  final _Breed _self;
  final $Res Function(_Breed) _then;

/// Create a copy of Breed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? farmId = null,Object? farmName = null,Object? createdOn = freezed,Object? updatedOn = freezed,}) {
  return _then(_Breed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,updatedOn: freezed == updatedOn ? _self.updatedOn : updatedOn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
