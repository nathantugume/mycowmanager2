// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milking_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilkingRecord _$MilkingRecordFromJson(Map<String, dynamic> json) =>
    _MilkingRecord(
      id: json['id'] as String?,
      farmName: json['farmName'] as String,
      farmId: json['farmId'] as String,
      owner: json['owner'] as String,
      cowId: json['cowId'] as String?,
      cowName: json['cowName'] as String?,
      cattleGroupId: json['cattleGroupId'] as String?,
      cattleGroupName: json['cattleGroupName'] as String?,
      date: json['date'] as String,
      morning: (json['morning'] as num).toDouble(),
      afternoon: (json['afternoon'] as num).toDouble(),
      evening: (json['evening'] as num).toDouble(),
      milkForCalf: (json['milkForCalf'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      scope: json['scope'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MilkingRecordToJson(_MilkingRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmName': instance.farmName,
      'farmId': instance.farmId,
      'owner': instance.owner,
      'cowId': instance.cowId,
      'cowName': instance.cowName,
      'cattleGroupId': instance.cattleGroupId,
      'cattleGroupName': instance.cattleGroupName,
      'date': instance.date,
      'morning': instance.morning,
      'afternoon': instance.afternoon,
      'evening': instance.evening,
      'milkForCalf': instance.milkForCalf,
      'total': instance.total,
      'scope': instance.scope,
      'notes': instance.notes,
    };
