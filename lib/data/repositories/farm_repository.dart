
import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/farm/farm.dart';

class FarmRepository{
  final FirestoreRepository<Farm> _farmRepo = FirestoreRepository<Farm>(
      collectionName: 'farms',
      fromJson: (json)=>Farm.fromJson(json),
      toJson:(f)=>f.toJson());

    Future<List<Farm>> getAll() async => _farmRepo.getAll();
    Future<void> add(Farm f) => _farmRepo.add(f);
    Future<void> update(String id, Farm f)=> _farmRepo.update(id,f);
    Future<void> delete(String id)          => _farmRepo.delete(id);
    Future<Farm?> getById(String id)      => _farmRepo.getById(id);
    Future<List<Farm>> getByUserId(String userId)
    => _farmRepo.getByParameter('owner', userId);
}