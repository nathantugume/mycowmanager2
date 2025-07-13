// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cattle_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CattleGroup {

 String get id; String get name;/// Foreign‑key to farm
 String get farmId; String get farmName;/// ISO‑8601 timestamps (nullable if you create them later)
 String? get createdOn; String? get updatedOn;
/// Create a copy of CattleGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CattleGroupCopyWith<CattleGroup> get copyWith => _$CattleGroupCopyWithImpl<CattleGroup>(this as CattleGroup, _$identity);

  /// Serializes this CattleGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CattleGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,farmId,farmName,createdOn,updatedOn);

@override
String toString() {
  return 'CattleGroup(id: $id, name: $name, farmId: $farmId, farmName: $farmName, createdOn: $createdOn, updatedOn: $updatedOn)';
}


}

/// @nodoc
abstract mixin class $CattleGroupCopyWith<$Res>  {
  factory $CattleGroupCopyWith(CattleGroup value, $Res Function(CattleGroup) _then) = _$CattleGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, String farmId, String farmName, String? createdOn, String? updatedOn
});




}
/// @nodoc
class _$CattleGroupCopyWithImpl<$Res>
    implements $CattleGroupCopyWith<$Res> {
  _$CattleGroupCopyWithImpl(this._self, this._then);

  final CattleGroup _self;
  final $Res Function(CattleGroup) _then;

/// Create a copy of CattleGroup
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


/// Adds pattern-matching-related methods to [CattleGroup].
extension CattleGroupPatterns on CattleGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CattleGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CattleGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CattleGroup value)  $default,){
final _that = this;
switch (_that) {
case _CattleGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CattleGroup value)?  $default,){
final _that = this;
switch (_that) {
case _CattleGroup() when $default != null:
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
case _CattleGroup() when $default != null:
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
case _CattleGroup():
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
case _CattleGroup() when $default != null:
return $default(_that.id,_that.name,_that.farmId,_that.farmName,_that.createdOn,_that.updatedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CattleGroup implements CattleGroup {
  const _CattleGroup({required this.id, required this.name, required this.farmId, required this.farmName, this.createdOn, this.updatedOn});
  factory _CattleGroup.fromJson(Map<String, dynamic> json) => _$CattleGroupFromJson(json);

@override final  String id;
@override final  String name;
/// Foreign‑key to farm
@override final  String farmId;
@override final  String farmName;
/// ISO‑8601 timestamps (nullable if you create them later)
@override final  String? createdOn;
@override final  String? updatedOn;

/// Create a copy of CattleGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CattleGroupCopyWith<_CattleGroup> get copyWith => __$CattleGroupCopyWithImpl<_CattleGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CattleGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CattleGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,farmId,farmName,createdOn,updatedOn);

@override
String toString() {
  return 'CattleGroup(id: $id, name: $name, farmId: $farmId, farmName: $farmName, createdOn: $createdOn, updatedOn: $updatedOn)';
}


}

/// @nodoc
abstract mixin class _$CattleGroupCopyWith<$Res> implements $CattleGroupCopyWith<$Res> {
  factory _$CattleGroupCopyWith(_CattleGroup value, $Res Function(_CattleGroup) _then) = __$CattleGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String farmId, String farmName, String? createdOn, String? updatedOn
});




}
/// @nodoc
class __$CattleGroupCopyWithImpl<$Res>
    implements _$CattleGroupCopyWith<$Res> {
  __$CattleGroupCopyWithImpl(this._self, this._then);

  final _CattleGroup _self;
  final $Res Function(_CattleGroup) _then;

/// Create a copy of CattleGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? farmId = null,Object? farmName = null,Object? createdOn = freezed,Object? updatedOn = freezed,}) {
  return _then(_CattleGroup(
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
