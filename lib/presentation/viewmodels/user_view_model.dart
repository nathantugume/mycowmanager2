import 'package:flutter/material.dart';
import '../../domain/models/appuser.dart';
import '../../data/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repo = UserRepository();
  List<AppUser> _users = [];
  bool _isLoading = false;
  String? _operationStatus;
  Exception? _error;

  List<AppUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;

  Future<void> getByFarmId(String farmId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _repo.getByFarmId(farmId);
      _operationStatus = null;
      _error = null;
    } catch (e) {
      _error = e as Exception;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(AppUser user) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.add(user);
      _operationStatus = 'User added successfully';
      await getByFarmId(user.farmId!);
    } catch (e) {
      _error = e as Exception;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(String id, AppUser user) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.update(id, user);
      _operationStatus = 'User updated successfully';
      await getByFarmId(user.farmId!);
    } catch (e) {
      _error = e as Exception;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(String id, String farmId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.delete(id);
      _operationStatus = 'User deleted successfully';
      await getByFarmId(farmId);
    } catch (e) {
      _error = e as Exception;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStatus() {
    _operationStatus = null;
    _error = null;
    notifyListeners();
  }
}
