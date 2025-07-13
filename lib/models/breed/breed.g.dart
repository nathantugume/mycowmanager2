// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Breed _$BreedFromJson(Map<String, dynamic> json) => _Breed(
  id: json['id'] as String,
  name: json['name'] as String,
  farmId: json['farmId'] as String,
  farmName: json['farmName'] as String,
  createdOn: json['createdOn'] as String?,
  updatedOn: json['updatedOn'] as String?,
);

Map<String, dynamic> _$BreedToJson(_Breed instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'farmId': instance.farmId,
  'farmName': instance.farmName,
  'createdOn': instance.createdOn,
  'updatedOn': instance.updatedOn,
};
