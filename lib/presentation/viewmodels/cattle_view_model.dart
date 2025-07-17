import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:mycowmanager/data/repositories/cattle_repository.dart';
import 'package:mycowmanager/models/cattle/cattle.dart';

class CattleViewModel extends ChangeNotifier {
  final CattleRepository _repository = CattleRepository();

  List<Cattle> _cattleList = [];
  Cattle? _singleCattle;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = false;

  List<Cattle> get cattleList => _cattleList;
  Cattle? get singleCattle => _singleCattle;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  // Fetch all cattle

  Future<void> getAll() async{
    _isLoading = true;
    notifyListeners();

    try {
      _cattleList = await _repository.getAll();
      notifyListeners();
    } catch (e) {
      _error = e is Exception? e : Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    }
    finally{
      _isLoading = false;
    }
  }


  // Add new cattle
  Future<void> add(Cattle c) async {
    _isLoading = true;
    notifyListeners();
    try {
      var id = _repository.generateId();
      c = c.copyWith(id: id);

      await _repository.add(c);
      _operationStatus = 'Cattle added successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }


  // Update cattle by id
  Future<void> update(String id, Cattle c) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.update(id, c);
      _operationStatus = 'Cow updated successfully';
      notifyListeners();
    }catch (e) {
      if (e is Exception) {
        _error = e;
      } else {
        _error = Exception('Unexpected error: $e');
      }
      if (kDebugMode) {
        print(e.toString());
      }
      notifyListeners();
    }

    finally{
      _isLoading = false;
      notifyListeners();
    }
  }


  // Delete cattle by id
  Future<void> delete(String id) async {
    try {
      await _repository.delete(id);
      _operationStatus = 'Cow deleted successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }


  // Get cattle by id
  Future<void> getById(String id) async {
    try {
      _singleCattle = await _repository.getById(id);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      _error = e as Exception;
      notifyListeners();
    }
  }


  // Get cattle by farmId parameter
  Future<void> getByFarmId(String farmId) async {
    try {
      _cattleList = await _repository.getByFarmId(farmId);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  // Clear any existing status or error messages
  void clearStatus() {
    _operationStatus = null;
    _error = null;
    notifyListeners();
  }
}
