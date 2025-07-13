// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cattle_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CattleGroup _$CattleGroupFromJson(Map<String, dynamic> json) => _CattleGroup(
  id: json['id'] as String,
  name: json['name'] as String,
  farmId: json['farmId'] as String,
  farmName: json['farmName'] as String,
  createdOn: json['createdOn'] as String?,
  updatedOn: json['updatedOn'] as String?,
);

Map<String, dynamic> _$CattleGroupToJson(_CattleGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'farmId': instance.farmId,
      'farmName': instance.farmName,
      'createdOn': instance.createdOn,
      'updatedOn': instance.updatedOn,
    };
