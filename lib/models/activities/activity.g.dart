// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  id: json['id'] as String,
  farmId: json['farmId'] as String,
  farmName: json['farmName'] as String?,
  cattleId: json['cattleId'] as String,
  cattleName: json['cattleName'] as String?,
  type: json['type'] as String,
  date: json['date'] as String,
  createdOn: json['createdOn'] as String?,
  performedBy: json['performedBy'] as String?,
  diagnosis: json['diagnosis'] as String?,
  symptoms: (json['symptoms'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  medications: (json['medications'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  treatmentMethod: json['treatmentMethod'] as String?,
  recoveryStatus: json['recoveryStatus'] as String?,
  nextCheckupDate: json['nextCheckupDate'] as String?,
  vaccineName: json['vaccineName'] as String?,
  vaccineDose: json['vaccineDose'] as String?,
  breedingType: json['breedingType'] as String?,
  sireTag: json['sireTag'] as String?,
  weight: json['weight'] as String?,
  weightUnit: json['weightUnit'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'id': instance.id,
  'farmId': instance.farmId,
  'farmName': instance.farmName,
  'cattleId': instance.cattleId,
  'cattleName': instance.cattleName,
  'type': instance.type,
  'date': instance.date,
  'createdOn': instance.createdOn,
  'performedBy': instance.performedBy,
  'diagnosis': instance.diagnosis,
  'symptoms': instance.symptoms,
  'medications': instance.medications,
  'treatmentMethod': instance.treatmentMethod,
  'recoveryStatus': instance.recoveryStatus,
  'nextCheckupDate': instance.nextCheckupDate,
  'vaccineName': instance.vaccineName,
  'vaccineDose': instance.vaccineDose,
  'breedingType': instance.breedingType,
  'sireTag': instance.sireTag,
  'weight': instance.weight,
  'weightUnit': instance.weightUnit,
  'notes': instance.notes,
};
