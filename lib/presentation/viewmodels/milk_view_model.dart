import 'package:flutter/material.dart';

import '../../data/repositories/milk_repository.dart';
import '../../models/milk/milking_record.dart';

class MilkViewModel extends ChangeNotifier{
  final MilkRepository _repository = MilkRepository();

  List<MilkingRecord> _milkList = [];
  MilkingRecord? _singleMilk;
  String? _operationStatus;
  Exception? _error;

  List<MilkingRecord> get milkList => _milkList;
  MilkingRecord? get singleMilk => _singleMilk;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;

  //Fetch all milk records

  Future<void> getAll() async {
    try {
      _milkList = await _repository.getAll();
      notifyListeners();
    } catch (e) {
      _error = e is Exception ? e : Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    }

  }

  //add new milk record
  Future<void> add(MilkingRecord c) async {
    try {
      await _repository.add(c);
      _operationStatus = 'Milk record added successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }

  }

  //update milk record
  Future<void> update(String id, MilkingRecord c) async {
    try {
      await _repository.update(id, c);
      _operationStatus = 'Milk record updated successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }

  }

  //delete milk record
  Future<void> delete(String id) async {
    try {
      await _repository.delete(id);
      _operationStatus = 'Milk record deleted successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  //get milk record by id
  Future<void> getById(String id) async {
    try {
      _singleMilk = await _repository.getById(id);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  //get milk record by farmId parameter
  Future<void> getByFarmId(String farmId) async {
    try {
      _milkList = await _repository.getByFarmId(farmId);
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