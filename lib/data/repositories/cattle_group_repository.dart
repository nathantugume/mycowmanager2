import 'dart:convert';

import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/cattle_group/cattle_group.dart';

class CattleGroupRepository{
  final FirestoreRepository<CattleGroup> _groupRepo = FirestoreRepository<CattleGroup>(
      collectionName: 'cattleGroups',
      fromJson: (json)=>CattleGroup.fromJson(json),
      toJson: (g)=>g.toJson(),);

  Future<List<CattleGroup>> getAll() async => _groupRepo.getAll();
  Future<void> add(CattleGroup g) => _groupRepo.add(g);
  Future<void> update(String id,CattleGroup g) => _groupRepo.update(id, g);
  Future<void> delete(String id) => _groupRepo.delete(id);
  Future<CattleGroup?> getById(String id) => _groupRepo.getById(id);
  Future<List<CattleGroup>> getByFarmId(String farmId) => _groupRepo.getByParameter('farmId', farmId);


}