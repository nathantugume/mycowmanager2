// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cattle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cattle {

/// Firestore document ID
 String get id;/// Foreign‑key to farm document
 String? get farmId; String get farmName; String get name; String get breed; String get tag;/// Dates are kept as ISO‑strings to match your Java model;
/// change to DateTime if you prefer.
 String get dob; String? get weight; String get gender; String get cattleGroup; String? get addGroup; String get source; String? get motherTag; String? get fatherTag; String get createdOn; String get updatedOn; String get status;
/// Create a copy of Cattle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CattleCopyWith<Cattle> get copyWith => _$CattleCopyWithImpl<Cattle>(this as Cattle, _$identity);

  /// Serializes this Cattle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cattle&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.name, name) || other.name == name)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.cattleGroup, cattleGroup) || other.cattleGroup == cattleGroup)&&(identical(other.addGroup, addGroup) || other.addGroup == addGroup)&&(identical(other.source, source) || other.source == source)&&(identical(other.motherTag, motherTag) || other.motherTag == motherTag)&&(identical(other.fatherTag, fatherTag) || other.fatherTag == fatherTag)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmId,farmName,name,breed,tag,dob,weight,gender,cattleGroup,addGroup,source,motherTag,fatherTag,createdOn,updatedOn,status);

@override
String toString() {
  return 'Cattle(id: $id, farmId: $farmId, farmName: $farmName, name: $name, breed: $breed, tag: $tag, dob: $dob, weight: $weight, gender: $gender, cattleGroup: $cattleGroup, addGroup: $addGroup, source: $source, motherTag: $motherTag, fatherTag: $fatherTag, createdOn: $createdOn, updatedOn: $updatedOn, status: $status)';
}


}

/// @nodoc
abstract mixin class $CattleCopyWith<$Res>  {
  factory $CattleCopyWith(Cattle value, $Res Function(Cattle) _then) = _$CattleCopyWithImpl;
@useResult
$Res call({
 String id, String? farmId, String farmName, String name, String breed, String tag, String dob, String? weight, String gender, String cattleGroup, String? addGroup, String source, String? motherTag, String? fatherTag, String createdOn, String updatedOn, String status
});




}
/// @nodoc
class _$CattleCopyWithImpl<$Res>
    implements $CattleCopyWith<$Res> {
  _$CattleCopyWithImpl(this._self, this._then);

  final Cattle _self;
  final $Res Function(Cattle) _then;

/// Create a copy of Cattle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmId = freezed,Object? farmName = null,Object? name = null,Object? breed = null,Object? tag = null,Object? dob = null,Object? weight = freezed,Object? gender = null,Object? cattleGroup = null,Object? addGroup = freezed,Object? source = null,Object? motherTag = freezed,Object? fatherTag = freezed,Object? createdOn = null,Object? updatedOn = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,cattleGroup: null == cattleGroup ? _self.cattleGroup : cattleGroup // ignore: cast_nullable_to_non_nullable
as String,addGroup: freezed == addGroup ? _self.addGroup : addGroup // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,motherTag: freezed == motherTag ? _self.motherTag : motherTag // ignore: cast_nullable_to_non_nullable
as String?,fatherTag: freezed == fatherTag ? _self.fatherTag : fatherTag // ignore: cast_nullable_to_non_nullable
as String?,createdOn: null == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String,updatedOn: null == updatedOn ? _self.updatedOn : updatedOn // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Cattle].
extension CattlePatterns on Cattle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cattle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cattle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cattle value)  $default,){
final _that = this;
switch (_that) {
case _Cattle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cattle value)?  $default,){
final _that = this;
switch (_that) {
case _Cattle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? farmId,  String farmName,  String name,  String breed,  String tag,  String dob,  String? weight,  String gender,  String cattleGroup,  String? addGroup,  String source,  String? motherTag,  String? fatherTag,  String createdOn,  String updatedOn,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cattle() when $default != null:
return $default(_that.id,_that.farmId,_that.farmName,_that.name,_that.breed,_that.tag,_that.dob,_that.weight,_that.gender,_that.cattleGroup,_that.addGroup,_that.source,_that.motherTag,_that.fatherTag,_that.createdOn,_that.updatedOn,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? farmId,  String farmName,  String name,  String breed,  String tag,  String dob,  String? weight,  String gender,  String cattleGroup,  String? addGroup,  String source,  String? motherTag,  String? fatherTag,  String createdOn,  String updatedOn,  String status)  $default,) {final _that = this;
switch (_that) {
case _Cattle():
return $default(_that.id,_that.farmId,_that.farmName,_that.name,_that.breed,_that.tag,_that.dob,_that.weight,_that.gender,_that.cattleGroup,_that.addGroup,_that.source,_that.motherTag,_that.fatherTag,_that.createdOn,_that.updatedOn,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? farmId,  String farmName,  String name,  String breed,  String tag,  String dob,  String? weight,  String gender,  String cattleGroup,  String? addGroup,  String source,  String? motherTag,  String? fatherTag,  String createdOn,  String updatedOn,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Cattle() when $default != null:
return $default(_that.id,_that.farmId,_that.farmName,_that.name,_that.breed,_that.tag,_that.dob,_that.weight,_that.gender,_that.cattleGroup,_that.addGroup,_that.source,_that.motherTag,_that.fatherTag,_that.createdOn,_that.updatedOn,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cattle implements Cattle {
  const _Cattle({required this.id, this.farmId, required this.farmName, required this.name, required this.breed, required this.tag, required this.dob, this.weight, required this.gender, required this.cattleGroup, this.addGroup, required this.source, this.motherTag, this.fatherTag, required this.createdOn, required this.updatedOn, required this.status});
  factory _Cattle.fromJson(Map<String, dynamic> json) => _$CattleFromJson(json);

/// Firestore document ID
@override final  String id;
/// Foreign‑key to farm document
@override final  String? farmId;
@override final  String farmName;
@override final  String name;
@override final  String breed;
@override final  String tag;
/// Dates are kept as ISO‑strings to match your Java model;
/// change to DateTime if you prefer.
@override final  String dob;
@override final  String? weight;
@override final  String gender;
@override final  String cattleGroup;
@override final  String? addGroup;
@override final  String source;
@override final  String? motherTag;
@override final  String? fatherTag;
@override final  String createdOn;
@override final  String updatedOn;
@override final  String status;

/// Create a copy of Cattle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CattleCopyWith<_Cattle> get copyWith => __$CattleCopyWithImpl<_Cattle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CattleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cattle&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.name, name) || other.name == name)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.cattleGroup, cattleGroup) || other.cattleGroup == cattleGroup)&&(identical(other.addGroup, addGroup) || other.addGroup == addGroup)&&(identical(other.source, source) || other.source == source)&&(identical(other.motherTag, motherTag) || other.motherTag == motherTag)&&(identical(other.fatherTag, fatherTag) || other.fatherTag == fatherTag)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmId,farmName,name,breed,tag,dob,weight,gender,cattleGroup,addGroup,source,motherTag,fatherTag,createdOn,updatedOn,status);

@override
String toString() {
  return 'Cattle(id: $id, farmId: $farmId, farmName: $farmName, name: $name, breed: $breed, tag: $tag, dob: $dob, weight: $weight, gender: $gender, cattleGroup: $cattleGroup, addGroup: $addGroup, source: $source, motherTag: $motherTag, fatherTag: $fatherTag, createdOn: $createdOn, updatedOn: $updatedOn, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CattleCopyWith<$Res> implements $CattleCopyWith<$Res> {
  factory _$CattleCopyWith(_Cattle value, $Res Function(_Cattle) _then) = __$CattleCopyWithImpl;
@override @useResult
$Res call({
 String id, String? farmId, String farmName, String name, String breed, String tag, String dob, String? weight, String gender, String cattleGroup, String? addGroup, String source, String? motherTag, String? fatherTag, String createdOn, String updatedOn, String status
});




}
/// @nodoc
class __$CattleCopyWithImpl<$Res>
    implements _$CattleCopyWith<$Res> {
  __$CattleCopyWithImpl(this._self, this._then);

  final _Cattle _self;
  final $Res Function(_Cattle) _then;

/// Create a copy of Cattle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmId = freezed,Object? farmName = null,Object? name = null,Object? breed = null,Object? tag = null,Object? dob = null,Object? weight = freezed,Object? gender = null,Object? cattleGroup = null,Object? addGroup = freezed,Object? source = null,Object? motherTag = freezed,Object? fatherTag = freezed,Object? createdOn = null,Object? updatedOn = null,Object? status = null,}) {
  return _then(_Cattle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,cattleGroup: null == cattleGroup ? _self.cattleGroup : cattleGroup // ignore: cast_nullable_to_non_nullable
as String,addGroup: freezed == addGroup ? _self.addGroup : addGroup // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,motherTag: freezed == motherTag ? _self.motherTag : motherTag // ignore: cast_nullable_to_non_nullable
as String?,fatherTag: freezed == fatherTag ? _self.fatherTag : fatherTag // ignore: cast_nullable_to_non_nullable
as String?,createdOn: null == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String,updatedOn: null == updatedOn ? _self.updatedOn : updatedOn // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
