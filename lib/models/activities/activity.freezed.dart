// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Activity {

// ─── Identifiers ────────────────────────────────────────────────
 String get id; String get farmId; String? get farmName; String get cattleId; String? get cattleName;// ─── Category & timing ──────────── ──────────────────────────────
 String get type;// e.g. “Vaccination”, “Breeding”, “Treatment”
 String get date;// ISO‑8601 string; change to DateTime if you prefer
 String? get createdOn;// when the record itself was created
 String? get performedBy;// ─── Medical / breeding details ────────────────────────────────
 String? get diagnosis; List<String>? get symptoms; List<String>? get medications; String? get treatmentMethod; String? get recoveryStatus; String? get nextCheckupDate;// Vaccination‑specific
 String? get vaccineName; String? get vaccineDose;// Breeding‑specific
 String? get breedingType;// e.g. “AI”, “Natural”
 String? get sireTag;// Weight check
 String? get weight; String? get weightUnit;// Misc
 String? get notes;
/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCopyWith<Activity> get copyWith => _$ActivityCopyWithImpl<Activity>(this as Activity, _$identity);

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Activity&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.cattleId, cattleId) || other.cattleId == cattleId)&&(identical(other.cattleName, cattleName) || other.cattleName == cattleName)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&const DeepCollectionEquality().equals(other.symptoms, symptoms)&&const DeepCollectionEquality().equals(other.medications, medications)&&(identical(other.treatmentMethod, treatmentMethod) || other.treatmentMethod == treatmentMethod)&&(identical(other.recoveryStatus, recoveryStatus) || other.recoveryStatus == recoveryStatus)&&(identical(other.nextCheckupDate, nextCheckupDate) || other.nextCheckupDate == nextCheckupDate)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.vaccineDose, vaccineDose) || other.vaccineDose == vaccineDose)&&(identical(other.breedingType, breedingType) || other.breedingType == breedingType)&&(identical(other.sireTag, sireTag) || other.sireTag == sireTag)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,farmId,farmName,cattleId,cattleName,type,date,createdOn,performedBy,diagnosis,const DeepCollectionEquality().hash(symptoms),const DeepCollectionEquality().hash(medications),treatmentMethod,recoveryStatus,nextCheckupDate,vaccineName,vaccineDose,breedingType,sireTag,weight,weightUnit,notes]);

@override
String toString() {
  return 'Activity(id: $id, farmId: $farmId, farmName: $farmName, cattleId: $cattleId, cattleName: $cattleName, type: $type, date: $date, createdOn: $createdOn, performedBy: $performedBy, diagnosis: $diagnosis, symptoms: $symptoms, medications: $medications, treatmentMethod: $treatmentMethod, recoveryStatus: $recoveryStatus, nextCheckupDate: $nextCheckupDate, vaccineName: $vaccineName, vaccineDose: $vaccineDose, breedingType: $breedingType, sireTag: $sireTag, weight: $weight, weightUnit: $weightUnit, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ActivityCopyWith<$Res>  {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) _then) = _$ActivityCopyWithImpl;
@useResult
$Res call({
 String id, String farmId, String? farmName, String cattleId, String? cattleName, String type, String date, String? createdOn, String? performedBy, String? diagnosis, List<String>? symptoms, List<String>? medications, String? treatmentMethod, String? recoveryStatus, String? nextCheckupDate, String? vaccineName, String? vaccineDose, String? breedingType, String? sireTag, String? weight, String? weightUnit, String? notes
});




}
/// @nodoc
class _$ActivityCopyWithImpl<$Res>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._self, this._then);

  final Activity _self;
  final $Res Function(Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmId = null,Object? farmName = freezed,Object? cattleId = null,Object? cattleName = freezed,Object? type = null,Object? date = null,Object? createdOn = freezed,Object? performedBy = freezed,Object? diagnosis = freezed,Object? symptoms = freezed,Object? medications = freezed,Object? treatmentMethod = freezed,Object? recoveryStatus = freezed,Object? nextCheckupDate = freezed,Object? vaccineName = freezed,Object? vaccineDose = freezed,Object? breedingType = freezed,Object? sireTag = freezed,Object? weight = freezed,Object? weightUnit = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: freezed == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String?,cattleId: null == cattleId ? _self.cattleId : cattleId // ignore: cast_nullable_to_non_nullable
as String,cattleName: freezed == cattleName ? _self.cattleName : cattleName // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,performedBy: freezed == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,symptoms: freezed == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<String>?,medications: freezed == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<String>?,treatmentMethod: freezed == treatmentMethod ? _self.treatmentMethod : treatmentMethod // ignore: cast_nullable_to_non_nullable
as String?,recoveryStatus: freezed == recoveryStatus ? _self.recoveryStatus : recoveryStatus // ignore: cast_nullable_to_non_nullable
as String?,nextCheckupDate: freezed == nextCheckupDate ? _self.nextCheckupDate : nextCheckupDate // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: freezed == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String?,vaccineDose: freezed == vaccineDose ? _self.vaccineDose : vaccineDose // ignore: cast_nullable_to_non_nullable
as String?,breedingType: freezed == breedingType ? _self.breedingType : breedingType // ignore: cast_nullable_to_non_nullable
as String?,sireTag: freezed == sireTag ? _self.sireTag : sireTag // ignore: cast_nullable_to_non_nullable
as String?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String?,weightUnit: freezed == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Activity].
extension ActivityPatterns on Activity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Activity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Activity value)  $default,){
final _that = this;
switch (_that) {
case _Activity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Activity value)?  $default,){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String farmId,  String? farmName,  String cattleId,  String? cattleName,  String type,  String date,  String? createdOn,  String? performedBy,  String? diagnosis,  List<String>? symptoms,  List<String>? medications,  String? treatmentMethod,  String? recoveryStatus,  String? nextCheckupDate,  String? vaccineName,  String? vaccineDose,  String? breedingType,  String? sireTag,  String? weight,  String? weightUnit,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.id,_that.farmId,_that.farmName,_that.cattleId,_that.cattleName,_that.type,_that.date,_that.createdOn,_that.performedBy,_that.diagnosis,_that.symptoms,_that.medications,_that.treatmentMethod,_that.recoveryStatus,_that.nextCheckupDate,_that.vaccineName,_that.vaccineDose,_that.breedingType,_that.sireTag,_that.weight,_that.weightUnit,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String farmId,  String? farmName,  String cattleId,  String? cattleName,  String type,  String date,  String? createdOn,  String? performedBy,  String? diagnosis,  List<String>? symptoms,  List<String>? medications,  String? treatmentMethod,  String? recoveryStatus,  String? nextCheckupDate,  String? vaccineName,  String? vaccineDose,  String? breedingType,  String? sireTag,  String? weight,  String? weightUnit,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Activity():
return $default(_that.id,_that.farmId,_that.farmName,_that.cattleId,_that.cattleName,_that.type,_that.date,_that.createdOn,_that.performedBy,_that.diagnosis,_that.symptoms,_that.medications,_that.treatmentMethod,_that.recoveryStatus,_that.nextCheckupDate,_that.vaccineName,_that.vaccineDose,_that.breedingType,_that.sireTag,_that.weight,_that.weightUnit,_that.notes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String farmId,  String? farmName,  String cattleId,  String? cattleName,  String type,  String date,  String? createdOn,  String? performedBy,  String? diagnosis,  List<String>? symptoms,  List<String>? medications,  String? treatmentMethod,  String? recoveryStatus,  String? nextCheckupDate,  String? vaccineName,  String? vaccineDose,  String? breedingType,  String? sireTag,  String? weight,  String? weightUnit,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.id,_that.farmId,_that.farmName,_that.cattleId,_that.cattleName,_that.type,_that.date,_that.createdOn,_that.performedBy,_that.diagnosis,_that.symptoms,_that.medications,_that.treatmentMethod,_that.recoveryStatus,_that.nextCheckupDate,_that.vaccineName,_that.vaccineDose,_that.breedingType,_that.sireTag,_that.weight,_that.weightUnit,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Activity implements Activity {
  const _Activity({required this.id, required this.farmId, this.farmName, required this.cattleId, this.cattleName, required this.type, required this.date, this.createdOn, this.performedBy, this.diagnosis, final  List<String>? symptoms, final  List<String>? medications, this.treatmentMethod, this.recoveryStatus, this.nextCheckupDate, this.vaccineName, this.vaccineDose, this.breedingType, this.sireTag, this.weight, this.weightUnit, this.notes}): _symptoms = symptoms,_medications = medications;
  factory _Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

// ─── Identifiers ────────────────────────────────────────────────
@override final  String id;
@override final  String farmId;
@override final  String? farmName;
@override final  String cattleId;
@override final  String? cattleName;
// ─── Category & timing ──────────── ──────────────────────────────
@override final  String type;
// e.g. “Vaccination”, “Breeding”, “Treatment”
@override final  String date;
// ISO‑8601 string; change to DateTime if you prefer
@override final  String? createdOn;
// when the record itself was created
@override final  String? performedBy;
// ─── Medical / breeding details ────────────────────────────────
@override final  String? diagnosis;
 final  List<String>? _symptoms;
@override List<String>? get symptoms {
  final value = _symptoms;
  if (value == null) return null;
  if (_symptoms is EqualUnmodifiableListView) return _symptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _medications;
@override List<String>? get medications {
  final value = _medications;
  if (value == null) return null;
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? treatmentMethod;
@override final  String? recoveryStatus;
@override final  String? nextCheckupDate;
// Vaccination‑specific
@override final  String? vaccineName;
@override final  String? vaccineDose;
// Breeding‑specific
@override final  String? breedingType;
// e.g. “AI”, “Natural”
@override final  String? sireTag;
// Weight check
@override final  String? weight;
@override final  String? weightUnit;
// Misc
@override final  String? notes;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCopyWith<_Activity> get copyWith => __$ActivityCopyWithImpl<_Activity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Activity&&(identical(other.id, id) || other.id == id)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.farmName, farmName) || other.farmName == farmName)&&(identical(other.cattleId, cattleId) || other.cattleId == cattleId)&&(identical(other.cattleName, cattleName) || other.cattleName == cattleName)&&(identical(other.type, type) || other.type == type)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&const DeepCollectionEquality().equals(other._symptoms, _symptoms)&&const DeepCollectionEquality().equals(other._medications, _medications)&&(identical(other.treatmentMethod, treatmentMethod) || other.treatmentMethod == treatmentMethod)&&(identical(other.recoveryStatus, recoveryStatus) || other.recoveryStatus == recoveryStatus)&&(identical(other.nextCheckupDate, nextCheckupDate) || other.nextCheckupDate == nextCheckupDate)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.vaccineDose, vaccineDose) || other.vaccineDose == vaccineDose)&&(identical(other.breedingType, breedingType) || other.breedingType == breedingType)&&(identical(other.sireTag, sireTag) || other.sireTag == sireTag)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,farmId,farmName,cattleId,cattleName,type,date,createdOn,performedBy,diagnosis,const DeepCollectionEquality().hash(_symptoms),const DeepCollectionEquality().hash(_medications),treatmentMethod,recoveryStatus,nextCheckupDate,vaccineName,vaccineDose,breedingType,sireTag,weight,weightUnit,notes]);

@override
String toString() {
  return 'Activity(id: $id, farmId: $farmId, farmName: $farmName, cattleId: $cattleId, cattleName: $cattleName, type: $type, date: $date, createdOn: $createdOn, performedBy: $performedBy, diagnosis: $diagnosis, symptoms: $symptoms, medications: $medications, treatmentMethod: $treatmentMethod, recoveryStatus: $recoveryStatus, nextCheckupDate: $nextCheckupDate, vaccineName: $vaccineName, vaccineDose: $vaccineDose, breedingType: $breedingType, sireTag: $sireTag, weight: $weight, weightUnit: $weightUnit, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ActivityCopyWith<$Res> implements $ActivityCopyWith<$Res> {
  factory _$ActivityCopyWith(_Activity value, $Res Function(_Activity) _then) = __$ActivityCopyWithImpl;
@override @useResult
$Res call({
 String id, String farmId, String? farmName, String cattleId, String? cattleName, String type, String date, String? createdOn, String? performedBy, String? diagnosis, List<String>? symptoms, List<String>? medications, String? treatmentMethod, String? recoveryStatus, String? nextCheckupDate, String? vaccineName, String? vaccineDose, String? breedingType, String? sireTag, String? weight, String? weightUnit, String? notes
});




}
/// @nodoc
class __$ActivityCopyWithImpl<$Res>
    implements _$ActivityCopyWith<$Res> {
  __$ActivityCopyWithImpl(this._self, this._then);

  final _Activity _self;
  final $Res Function(_Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmId = null,Object? farmName = freezed,Object? cattleId = null,Object? cattleName = freezed,Object? type = null,Object? date = null,Object? createdOn = freezed,Object? performedBy = freezed,Object? diagnosis = freezed,Object? symptoms = freezed,Object? medications = freezed,Object? treatmentMethod = freezed,Object? recoveryStatus = freezed,Object? nextCheckupDate = freezed,Object? vaccineName = freezed,Object? vaccineDose = freezed,Object? breedingType = freezed,Object? sireTag = freezed,Object? weight = freezed,Object? weightUnit = freezed,Object? notes = freezed,}) {
  return _then(_Activity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,farmName: freezed == farmName ? _self.farmName : farmName // ignore: cast_nullable_to_non_nullable
as String?,cattleId: null == cattleId ? _self.cattleId : cattleId // ignore: cast_nullable_to_non_nullable
as String,cattleName: freezed == cattleName ? _self.cattleName : cattleName // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,performedBy: freezed == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String?,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,symptoms: freezed == symptoms ? _self._symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<String>?,medications: freezed == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<String>?,treatmentMethod: freezed == treatmentMethod ? _self.treatmentMethod : treatmentMethod // ignore: cast_nullable_to_non_nullable
as String?,recoveryStatus: freezed == recoveryStatus ? _self.recoveryStatus : recoveryStatus // ignore: cast_nullable_to_non_nullable
as String?,nextCheckupDate: freezed == nextCheckupDate ? _self.nextCheckupDate : nextCheckupDate // ignore: cast_nullable_to_non_nullable
as String?,vaccineName: freezed == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String?,vaccineDose: freezed == vaccineDose ? _self.vaccineDose : vaccineDose // ignore: cast_nullable_to_non_nullable
as String?,breedingType: freezed == breedingType ? _self.breedingType : breedingType // ignore: cast_nullable_to_non_nullable
as String?,sireTag: freezed == sireTag ? _self.sireTag : sireTag // ignore: cast_nullable_to_non_nullable
as String?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String?,weightUnit: freezed == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
