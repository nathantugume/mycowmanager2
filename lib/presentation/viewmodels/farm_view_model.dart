import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
// Added for BuildContext

import '../../core/services/auth_service.dart';
import '../../data/repositories/farm_repository.dart';
import '../../models/farm/farm.dart';
import '../../data/shared_pref_helper.dart';

class FarmViewModel extends ChangeNotifier {
  final FarmRepository _repository = FarmRepository();
  final _authService = AuthService();
  FarmViewModel(this._currentFarm);

  final CurrentFarm _currentFarm;

  List<Farm> _farmList = [];
  Farm? _singleFarm;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = false;

  List<Farm> get farmList => _farmList;
  Farm? get singleFarm => _singleFarm;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  // fetch all expenses
  Future<void> getAll() async {
    _isLoading = true;

    try {
      _farmList = await _repository.getAll();
      notifyListeners();
    } catch (e) {
      _error = e is Exception ? e : Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //add new expense
  Future<void> add(Farm f) async {
    _isLoading = true;
    try {
      await _repository.add(f);
      _operationStatus = 'Farm added successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //update expense
  Future<void> update(String id, Farm f) async {
    _isLoading = true;
    try {
      await _repository.update(id, f);
      _operationStatus = 'Farm updated successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //delete farm
  Future<void> delete(String id) async {
    _isLoading = true;
    try {
      await _repository.delete(id);
      _operationStatus = 'Farm deleted successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //get farm by id
  Future<void> getById(String id) async {
    _isLoading = true;
    try {
      _singleFarm = await _repository.getById(id);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //get farm by userId
  Future<void> getByUserId(String userId) async {
    _isLoading = true;
    try {
      _farmList = await _repository.getByUserId(userId);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //clear any existing status or error messages
  void clearStatus() {
    _operationStatus = null;
    _error = null;
    notifyListeners();
  }

  Future<void> loadForCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    dev.log('▶️  loadForCurrentUser() called', name: 'FarmViewModel');

    try {
      final user = await _authService.currentUser();
      dev.log(
        '🔑  Auth user loaded',
        name: 'FarmViewModel',
        level: 800, // info
      );

      if (kDebugMode) {
        print("Current user ${user.toString()}");
      }

      if (user.role == 'manager' && user.farmId != null) {
        dev.log(
          '👷 Manager role detected → fetching farm ${user.farmId}',
          name: 'FarmViewModel',
        );
        _singleFarm = await _repository.getById(user.farmId!);
        _farmList = [_singleFarm!];
        _currentFarm.set(_singleFarm);
        dev.log('✅  Fetched single farm', name: 'FarmViewModel');
      } else {
        dev.log(
          '👤 Owner role detected → fetching farms by user ${user.uid}',
          name: 'FarmViewModel',
        );
        _farmList = await _repository.getByUserId(user.uid);
        _singleFarm = _farmList.first;
        _currentFarm.set(_singleFarm);

        if (kDebugMode) {
          print(_singleFarm?.name);
        }
        dev.log('✅  Fetched ${_farmList.length} farms', name: 'FarmViewModel');
      }

      _error = null;
    } catch (e, stack) {
      _error = e is Exception ? e : Exception(e.toString());
      dev.log(
        '❌  Error in loadForCurrentUser',
        name: 'FarmViewModel',
        level: 1000, // severe
        error: _error,
        stackTrace: stack,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
      dev.log(
        '⏹  loadForCurrentUser() completed',
        name: 'FarmViewModel',
        level: 800,
      );
    }
  }
}

class CurrentFarm extends ChangeNotifier {
  Farm? _farm;
  Farm? get farm => _farm;

  CurrentFarm() {
    _loadFromPrefs();
  }

  void set(Farm? f) async {
    _farm = f;
    notifyListeners();
    if (f != null) {
      final helper = await SharedPrefHelper.getInstance();
      await helper.saveCurrentFarm(f.toJson());
    }
  }

  Future<void> _loadFromPrefs() async {
    final helper = await SharedPrefHelper.getInstance();
    final farmJson = helper.loadCurrentFarm();
    if (farmJson != null) {
      _farm = Farm.fromJson(farmJson);
      notifyListeners();
    }
  }
}
