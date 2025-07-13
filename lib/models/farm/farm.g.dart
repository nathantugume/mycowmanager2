// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Farm _$FarmFromJson(Map<String, dynamic> json) => _Farm(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String,
  owner: json['owner'] as String,
  ownerName: json['ownerName'] as String,
  imageUrl: json['imageUrl'] as String?,
  description: json['description'] as String?,
  createdOn: json['createdOn'] as String?,
  updatedOn: json['updatedOn'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$FarmToJson(_Farm instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'owner': instance.owner,
  'ownerName': instance.ownerName,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'createdOn': instance.createdOn,
  'updatedOn': instance.updatedOn,
  'status': instance.status,
};
