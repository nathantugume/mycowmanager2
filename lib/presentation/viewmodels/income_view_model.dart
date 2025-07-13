import 'package:flutter/cupertino.dart';

import '../../data/repositories/income_repository.dart';
import '../../models/financial_entry/financial_entry.dart';

class IncomeViewModel extends ChangeNotifier{
  final IncomeRepository _repository = IncomeRepository();
  List<IncomeEntry> _incomeList = [];
  IncomeEntry? _singleIncome;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = true;


  List<IncomeEntry> get incomeList => _incomeList;
  IncomeEntry? get singleIncome => _singleIncome;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  // fetch all expenses

  Future<void> getAll() async{
    _isLoading =true;
    try {
      _incomeList = await _repository.getAll();
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

  //add new income
  Future<void> add(IncomeEntry c) async {
    try {
      await _repository.add(c);
      _operationStatus = 'Income added successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

//update income
  Future<void> update(String id, IncomeEntry c) async {
    try {
      await _repository.update(id, c);
      _operationStatus = 'Income updated successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  //delete income
  Future<void> delete(String id) async {
    try {
      await _repository.delete(id);
      _operationStatus = 'Income deleted successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  //get income by id
  Future<void> getById(String id) async {
    try {
      _singleIncome = await _repository.getById(id);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  //get income by farmId
  Future<void> getByFarmId(String farmId) async {
    try {
      _incomeList = await _repository.getByFarmId(farmId);
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