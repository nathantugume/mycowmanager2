import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/financial_entry/financial_entry.dart';

class ExpenseRepository{
  final FirestoreRepository<ExpenseEntry> _expenseRepo = FirestoreRepository<ExpenseEntry>(
    collectionName: 'expenses',
    fromJson: (json) => ExpenseEntry.fromJson(json),
    toJson: (c) => c.toJson(),
  );
  Future<List<ExpenseEntry>> getAll() async => _expenseRepo.getAll();
  Future<void> add(ExpenseEntry c)             => _expenseRepo.add(c);
  Future<void> update(String id, ExpenseEntry c)=> _expenseRepo.update(id,c);
  Future<void> delete(String id)          => _expenseRepo.delete(id);
  Future<ExpenseEntry?> getById(String id)      => _expenseRepo.getById(id);
  Future<List<ExpenseEntry>> getByFarmId(String farmId)
  => _expenseRepo.getByParameter('farmId', farmId);
}