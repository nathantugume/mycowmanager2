
import 'package:mycowmanager/models/financial_entry/financial_entry.dart';
import 'firestore_repository.dart';

class IncomeRepository{
  final FirestoreRepository<IncomeEntry> _incomeRepo = FirestoreRepository<IncomeEntry>(
    collectionName: 'income',
    fromJson: (json) => IncomeEntry.fromJson(json),
    toJson: (c) => c.toJson(),
  );

  Future<List<IncomeEntry>> getAll() async => _incomeRepo.getAll();
  Future<void> add(IncomeEntry c)             => _incomeRepo.add(c,id: c.id);
  Future<void> update(String id, IncomeEntry c)=> _incomeRepo.update(id,c);
  Future<void> delete(String id)          => _incomeRepo.delete(id);
  Future<IncomeEntry?> getById(String id)      => _incomeRepo.getById(id);
  Future<List<IncomeEntry>> getByFarmId(String farmId)
  => _incomeRepo.getByParameter('farmId', farmId);

  String generateId()=>_incomeRepo.generateId();



}
