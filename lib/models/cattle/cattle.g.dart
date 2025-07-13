// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cattle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cattle _$CattleFromJson(Map<String, dynamic> json) => _Cattle(
  id: json['id'] as String,
  farmId: json['farmId'] as String?,
  farmName: json['farmName'] as String,
  name: json['name'] as String,
  breed: json['breed'] as String,
  tag: json['tag'] as String,
  dob: json['dob'] as String,
  weight: json['weight'] as String?,
  gender: json['gender'] as String,
  cattleGroup: json['cattleGroup'] as String,
  addGroup: json['addGroup'] as String?,
  source: json['source'] as String,
  motherTag: json['motherTag'] as String?,
  fatherTag: json['fatherTag'] as String?,
  createdOn: json['createdOn'] as String,
  updatedOn: json['updatedOn'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$CattleToJson(_Cattle instance) => <String, dynamic>{
  'id': instance.id,
  'farmId': instance.farmId,
  'farmName': instance.farmName,
  'name': instance.name,
  'breed': instance.breed,
  'tag': instance.tag,
  'dob': instance.dob,
  'weight': instance.weight,
  'gender': instance.gender,
  'cattleGroup': instance.cattleGroup,
  'addGroup': instance.addGroup,
  'source': instance.source,
  'motherTag': instance.motherTag,
  'fatherTag': instance.fatherTag,
  'createdOn': instance.createdOn,
  'updatedOn': instance.updatedOn,
  'status': instance.status,
};
