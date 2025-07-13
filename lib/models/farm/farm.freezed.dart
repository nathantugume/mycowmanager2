// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Farm {

 String get id; String get name; String get location; String get owner; String get ownerName;// Optional metadata
 String? get imageUrl; String? get description; String? get createdOn;// ISO‑8601 yyyy‑MM‑dd or full timestamp
 String? get updatedOn; String? get status;
/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmCopyWith<Farm> get copyWith => _$FarmCopyWithImpl<Farm>(this as Farm, _$identity);

  /// Serializes this Farm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Farm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,location,owner,ownerName,imageUrl,description,createdOn,updatedOn,status);

@override
String toString() {
  return 'Farm(id: $id, name: $name, location: $location, owner: $owner, ownerName: $ownerName, imageUrl: $imageUrl, description: $description, createdOn: $createdOn, updatedOn: $updatedOn, status: $status)';
}


}

/// @nodoc
abstract mixin class $FarmCopyWith<$Res>  {
  factory $FarmCopyWith(Farm value, $Res Function(Farm) _then) = _$FarmCopyWithImpl;
@useResult
$Res call({
 String id, String name, String location, String owner, String ownerName, String? imageUrl, String? description, String? createdOn, String? updatedOn, String? status
});




}
/// @nodoc
class _$FarmCopyWithImpl<$Res>
    implements $FarmCopyWith<$Res> {
  _$FarmCopyWithImpl(this._self, this._then);

  final Farm _self;
  final $Res Function(Farm) _then;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? location = null,Object? owner = null,Object? ownerName = null,Object? imageUrl = freezed,Object? description = freezed,Object? createdOn = freezed,Object? updatedOn = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,updatedOn: freezed == updatedOn ? _self.updatedOn : updatedOn // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Farm].
extension FarmPatterns on Farm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Farm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Farm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Farm value)  $default,){
final _that = this;
switch (_that) {
case _Farm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Farm value)?  $default,){
final _that = this;
switch (_that) {
case _Farm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String location,  String owner,  String ownerName,  String? imageUrl,  String? description,  String? createdOn,  String? updatedOn,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Farm() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.owner,_that.ownerName,_that.imageUrl,_that.description,_that.createdOn,_that.updatedOn,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String location,  String owner,  String ownerName,  String? imageUrl,  String? description,  String? createdOn,  String? updatedOn,  String? status)  $default,) {final _that = this;
switch (_that) {
case _Farm():
return $default(_that.id,_that.name,_that.location,_that.owner,_that.ownerName,_that.imageUrl,_that.description,_that.createdOn,_that.updatedOn,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String location,  String owner,  String ownerName,  String? imageUrl,  String? description,  String? createdOn,  String? updatedOn,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _Farm() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.owner,_that.ownerName,_that.imageUrl,_that.description,_that.createdOn,_that.updatedOn,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Farm implements Farm {
  const _Farm({required this.id, required this.name, required this.location, required this.owner, required this.ownerName, this.imageUrl, this.description, this.createdOn, this.updatedOn, this.status});
  factory _Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);

@override final  String id;
@override final  String name;
@override final  String location;
@override final  String owner;
@override final  String ownerName;
// Optional metadata
@override final  String? imageUrl;
@override final  String? description;
@override final  String? createdOn;
// ISO‑8601 yyyy‑MM‑dd or full timestamp
@override final  String? updatedOn;
@override final  String? status;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmCopyWith<_Farm> get copyWith => __$FarmCopyWithImpl<_Farm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Farm&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.updatedOn, updatedOn) || other.updatedOn == updatedOn)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,location,owner,ownerName,imageUrl,description,createdOn,updatedOn,status);

@override
String toString() {
  return 'Farm(id: $id, name: $name, location: $location, owner: $owner, ownerName: $ownerName, imageUrl: $imageUrl, description: $description, createdOn: $createdOn, updatedOn: $updatedOn, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FarmCopyWith<$Res> implements $FarmCopyWith<$Res> {
  factory _$FarmCopyWith(_Farm value, $Res Function(_Farm) _then) = __$FarmCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String location, String owner, String ownerName, String? imageUrl, String? description, String? createdOn, String? updatedOn, String? status
});




}
/// @nodoc
class __$FarmCopyWithImpl<$Res>
    implements _$FarmCopyWith<$Res> {
  __$FarmCopyWithImpl(this._self, this._then);

  final _Farm _self;
  final $Res Function(_Farm) _then;

/// Create a copy of Farm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? location = null,Object? owner = null,Object? ownerName = null,Object? imageUrl = freezed,Object? description = freezed,Object? createdOn = freezed,Object? updatedOn = freezed,Object? status = freezed,}) {
  return _then(_Farm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,updatedOn: freezed == updatedOn ? _self.updatedOn : updatedOn // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
