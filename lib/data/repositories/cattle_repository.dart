
// cattle_repository.dart
import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/cattle/cattle.dart';

// your Cattle model

class CattleRepository  {
  // ──────────────────────────────────────────────────────────────────────────
  // Generic repo instance (points at the "cattle" collection)
  // ──────────────────────────────────────────────────────────────────────────
  final FirestoreRepository<Cattle> _cattleRepo = FirestoreRepository<Cattle>(
    collectionName: 'cattle',
    fromJson: (json) => Cattle.fromJson(json),
    toJson: (c) => c.toJson(),
  );

  Future<List<Cattle>> getAll() async => _cattleRepo.getAll();        // returns Future
  Future<void> add(Cattle c)             => _cattleRepo.add(c);
  Future<void> update(String id, Cattle c)=> _cattleRepo.update(id,c);
  Future<void> delete(String id)          => _cattleRepo.delete(id);
  Future<Cattle?> getById(String id)      => _cattleRepo.getById(id);
  Future<List<Cattle>> getByFarmId(String farmId)
  => _cattleRepo.getByParameter('farmId', farmId);
}
