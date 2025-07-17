import 'package:flutter/foundation.dart';

import '../../data/repositories/expense_repository.dart';
import '../../models/financial_entry/financial_entry.dart';

class ExpenseViewModel extends ChangeNotifier{
  final ExpenseRepository _repository = ExpenseRepository();
  List<ExpenseEntry> _expenseList = [];
  ExpenseEntry? _singleExpense;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = false;

  List<ExpenseEntry> get expenseList => _expenseList;
  ExpenseEntry? get singleExpense => _singleExpense;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  // fetch all expenses
  Future<void> getAll() async{
    _isLoading = true;

    try {
      _expenseList = await _repository.getAll();
      notifyListeners();
    } catch (e) {
      _error = e is Exception? e : Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }

  //add new expense
  Future<void> add(ExpenseEntry c) async {
    try {
      var id = _repository.generateId();
      c = c.copyWith(id: id);
      await _repository.add(c);
      _operationStatus = 'Expense added successfully';
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      _error = e as Exception;
      notifyListeners();
    }
  }

  //update expense
Future<void> update(String id, ExpenseEntry c) async {
    try {
      await _repository.update(id, c);
      _operationStatus = 'Expense updated successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
}

//delete expense
Future<void> delete(String id) async {
    try {
      await _repository.delete(id);
      _operationStatus = 'Expense deleted successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
}
//get expense by id
Future<void> getById(String id) async {
    try {
      _singleExpense = await _repository.getById(id);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
}
//get expense by farmId
Future<void> getByFarmId(String farmId) async {
    try {
      _expenseList = await _repository.getByFarmId(farmId);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
}
//clear any existing status or error messages
void clearStatus() {
    _operationStatus = null;
    _error = null;
    notifyListeners();
  }


}