// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milking_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilkingRecord {

 String? get id;// Farm info
 String get farmName; String get farmId; String get owner;// Cow info
 String? get cowId; String? get cowName; String? get cattleGroupId;// <-- new field
 String? get cattleGroupName;// <-- new field
/// Date stored as ISO‑8601 `yyyy‑MM‑dd`.
 String get date;// Yield fields (litres)
 double get morning; double get afternoon; double get evening; double get milkForCalf;/// Cached total (could be computed in UI instead).
 double get total; String? get scope; String? get notes;
/// Create a copy of MilkingRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilkingRecordCopyWith<MilkingRecord> get copyWith => _$MilkingRecordCopyWithImpl<MilkingRecord>(this as MilkingRecord, _$identity);

  /// Serializes this MilkingRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilkingRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.cowId, cowId) || other.cowId == cowId)&&(identical(other.cowName, cowName) || other.cowName == cowName)&&(identical(other.cattleGroupId, cattleGroupId) || other.cattleGroupId == cattleGroupId)&&(identical(other.cattleGroupName, cattleGroupName) || other.cattleGroupName == cattleGroupName)&&(identical(other.date, date) || other.date == date)&&(identical(other.morning, morning) || other.morning == morning)&&(identical(other.afternoon, afternoon) || other.afternoon == afternoon)&&(identical(other.evening, evening) || other.evening == evening)&&(identical(other.milkForCalf, milkForCalf) || other.milkForCalf == milkForCalf)&&(identical(other.total, total) || other.total == total)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmName,farmId,owner,cowId,cowName,cattleGroupId,cattleGroupName,date,morning,afternoon,evening,milkForCalf,total,scope,notes);

@override
String toString() {
  return 'MilkingRecord(id: $id, farmName: $farmName, farmId: $farmId, owner: $owner, cowId: $cowId, cowName: $cowName, cattleGroupId: $cattleGroupId, cattleGroupName: $cattleGroupName, date: $date, morning: $morning, afternoon: $afternoon, evening: $evening, milkForCalf: $milkForCalf, total: $total, scope: $scope, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $MilkingRecordCopyWith<$Res>  {
  factory $MilkingRecordCopyWith(MilkingRecord value, $Res Function(MilkingRecord) _then) = _$MilkingRecordCopyWithImpl;
@useResult
$Res call({
 String? id, String farmName, String farmId, String owner, String? cowId, String? cowName, String? cattleGroupId, String? cattleGroupName, String date, double morning, double afternoon, double evening, double milkForCalf, double total, String? scope, String? notes
});




}
/// @nodoc
class _$MilkingRecordCopyWithImpl<$Res>
    implements $MilkingRecordCopyWith<$Res> {
  _$MilkingRecordCopyWithImpl(this._self, this._then);

  final MilkingRecord _self;
  final $Res Function(MilkingRecord) _then;

/// Create a copy of MilkingRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? farmName = null,Object? farmId = null,Object? owner = null,Object? cowId = freezed,Object? cowName = freezed,Object? cattleGroupId = freezed,Object? cattleGroupName = freezed,Object? date = null,Object? morning = null,Object? afternoon = null,Object? evening = null,Object? milkForCalf = null,Object? total = null,Object? scope = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,cowId: freezed == cowId ? _self.cowId : cowId // ignore: cast_nullable_to_non_nullable
as String?,cowName: freezed == cowName ? _self.cowName : cowName // ignore: cast_nullable_to_non_nullable
as String?,cattleGroupId: freezed == cattleGroupId ? _self.cattleGroupId : cattleGroupId // ignore: cast_nullable_to_non_nullable
as String?,cattleGroupName: freezed == cattleGroupName ? _self.cattleGroupName : cattleGroupName // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,morning: null == morning ? _self.morning : morning // ignore: cast_nullable_to_non_nullable
as double,afternoon: null == afternoon ? _self.afternoon : afternoon // ignore: cast_nullable_to_non_nullable
as double,evening: null == evening ? _self.evening : evening // ignore: cast_nullable_to_non_nullable
as double,milkForCalf: null == milkForCalf ? _self.milkForCalf : milkForCalf // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MilkingRecord].
extension MilkingRecordPatterns on MilkingRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilkingRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilkingRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilkingRecord value)  $default,){
final _that = this;
switch (_that) {
case _MilkingRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilkingRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MilkingRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String farmName,  String farmId,  String owner,  String? cowId,  String? cowName,  String? cattleGroupId,  String? cattleGroupName,  String date,  double morning,  double afternoon,  double evening,  double milkForCalf,  double total,  String? scope,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilkingRecord() when $default != null:
return $default(_that.id,_that.farmName,_that.farmId,_that.owner,_that.cowId,_that.cowName,_that.cattleGroupId,_that.cattleGroupName,_that.date,_that.morning,_that.afternoon,_that.evening,_that.milkForCalf,_that.total,_that.scope,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String farmName,  String farmId,  String owner,  String? cowId,  String? cowName,  String? cattleGroupId,  String? cattleGroupName,  String date,  double morning,  double afternoon,  double evening,  double milkForCalf,  double total,  String? scope,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _MilkingRecord():
return $default(_that.id,_that.farmName,_that.farmId,_that.owner,_that.cowId,_that.cowName,_that.cattleGroupId,_that.cattleGroupName,_that.date,_that.morning,_that.afternoon,_that.evening,_that.milkForCalf,_that.total,_that.scope,_that.notes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String farmName,  String farmId,  String owner,  String? cowId,  String? cowName,  String? cattleGroupId,  String? cattleGroupName,  String date,  double morning,  double afternoon,  double evening,  double milkForCalf,  double total,  String? scope,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _MilkingRecord() when $default != null:
return $default(_that.id,_that.farmName,_that.farmId,_that.owner,_that.cowId,_that.cowName,_that.cattleGroupId,_that.cattleGroupName,_that.date,_that.morning,_that.afternoon,_that.evening,_that.milkForCalf,_that.total,_that.scope,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilkingRecord implements MilkingRecord {
  const _MilkingRecord({this.id, required this.farmName, required this.farmId, required this.owner, this.cowId, this.cowName, this.cattleGroupId, this.cattleGroupName, required this.date, required this.morning, required this.afternoon, required this.evening, required this.milkForCalf, required this.total, this.scope, this.notes});
  factory _MilkingRecord.fromJson(Map<String, dynamic> json) => _$MilkingRecordFromJson(json);

@override final  String? id;
// Farm info
@override final  String farmName;
@override final  String farmId;
@override final  String owner;
// Cow info
@override final  String? cowId;
@override final  String? cowName;
@override final  String? cattleGroupId;
// <-- new field
@override final  String? cattleGroupName;
// <-- new field
/// Date stored as ISO‑8601 `yyyy‑MM‑dd`.
@override final  String date;
// Yield fields (litres)
@override final  double morning;
@override final  double afternoon;
@override final  double evening;
@override final  double milkForCalf;
/// Cached total (could be computed in UI instead).
@override final  double total;
@override final  String? scope;
@override final  String? notes;

/// Create a copy of MilkingRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilkingRecordCopyWith<_MilkingRecord> get copyWith => __$MilkingRecordCopyWithImpl<_MilkingRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilkingRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilkingRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.cowId, cowId) || other.cowId == cowId)&&(identical(other.cowName, cowName) || other.cowName == cowName)&&(identical(other.cattleGroupId, cattleGroupId) || other.cattleGroupId == cattleGroupId)&&(identical(other.cattleGroupName, cattleGroupName) || other.cattleGroupName == cattleGroupName)&&(identical(other.date, date) || other.date == date)&&(identical(other.morning, morning) || other.morning == morning)&&(identical(other.afternoon, afternoon) || other.afternoon == afternoon)&&(identical(other.evening, evening) || other.evening == evening)&&(identical(other.milkForCalf, milkForCalf) || other.milkForCalf == milkForCalf)&&(identical(other.total, total) || other.total == total)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmName,farmId,owner,cowId,cowName,cattleGroupId,cattleGroupName,date,morning,afternoon,evening,milkForCalf,total,scope,notes);

@override
String toString() {
  return 'MilkingRecord(id: $id, farmName: $farmName, farmId: $farmId, owner: $owner, cowId: $cowId, cowName: $cowName, cattleGroupId: $cattleGroupId, cattleGroupName: $cattleGroupName, date: $date, morning: $morning, afternoon: $afternoon, evening: $evening, milkForCalf: $milkForCalf, total: $total, scope: $scope, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$MilkingRecordCopyWith<$Res> implements $MilkingRecordCopyWith<$Res> {
  factory _$MilkingRecordCopyWith(_MilkingRecord value, $Res Function(_MilkingRecord) _then) = __$MilkingRecordCopyWithImpl;
@override @useResult
$Res call({
 String? id, String farmName, String farmId, String owner, String? cowId, String? cowName, String? cattleGroupId, String? cattleGroupName, String date, double morning, double afternoon, double evening, double milkForCalf, double total, String? scope, String? notes
});




}
/// @nodoc
class __$MilkingRecordCopyWithImpl<$Res>
    implements _$MilkingRecordCopyWith<$Res> {
  __$MilkingRecordCopyWithImpl(this._self, this._then);

  final _MilkingRecord _self;
  final $Res Function(_MilkingRecord) _then;

/// Create a copy of MilkingRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? farmName = null,Object? farmId = null,Object? owner = null,Object? cowId = freezed,Object? cowName = freezed,Object? cattleGroupId = freezed,Object? cattleGroupName = freezed,Object? date = null,Object? morning = null,Object? afternoon = null,Object? evening = null,Object? milkForCalf = null,Object? total = null,Object? scope = freezed,Object? notes = freezed,}) {
  return _then(_MilkingRecord(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,farmName: null == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,cowId: freezed == cowId ? _self.cowId : cowId // ignore: cast_nullable_to_non_nullable
as String?,cowName: freezed == cowName ? _self.cowName : cowName // ignore: cast_nullable_to_non_nullable
as String?,cattleGroupId: freezed == cattleGroupId ? _self.cattleGroupId : cattleGroupId // ignore: cast_nullable_to_non_nullable
as String?,cattleGroupName: freezed == cattleGroupName ? _self.cattleGroupName : cattleGroupName // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,morning: null == morning ? _self.morning : morning // ignore: cast_nullable_to_non_nullable
as double,afternoon: null == afternoon ? _self.afternoon : afternoon // ignore: cast_nullable_to_non_nullable
as double,evening: null == evening ? _self.evening : evening // ignore: cast_nullable_to_non_nullable
as double,milkForCalf: null == milkForCalf ? _self.milkForCalf : milkForCalf // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
