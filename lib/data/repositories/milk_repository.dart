import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/milk/milking_record.dart';

class MilkRepository{
  final FirestoreRepository<MilkingRecord> _milkRepo = FirestoreRepository<MilkingRecord>(
    collectionName: 'milkRecords',
    fromJson: (json) => MilkingRecord.fromJson(json),
    toJson: (c) => c.toJson(),
  );
  Future<List<MilkingRecord>> getAll() async => _milkRepo.getAll();        // returns Future
  Future<void> add(MilkingRecord c)             => _milkRepo.add(c,id: c.id);
  Future<void> update(String id, MilkingRecord c)=> _milkRepo.update(id,c);
  Future<void> delete(String id)          => _milkRepo.delete(id);
  Future<MilkingRecord?> getById(String id)      => _milkRepo.getById(id);
  Future<List<MilkingRecord>> getByFarmId(String farmId)
  => _milkRepo.getByParameter('farmId', farmId);

  String generateId() => _milkRepo.generateId();


  Future<List<MilkingRecord>> range({
    required String farmId,
    required DateTime from,
    required DateTime to,
  }) =>
      _milkRepo.range(
        dateField: 'date',
        from: from,
        to: to,
        farmIdField: 'farmId',
        farmId: farmId,
      );


}