import 'package:flutter/material.dart';
import 'package:mycowmanager/data/repositories/activity_repository.dart';
import 'package:mycowmanager/models/activities/activity.dart';

class ActivitiesViewModel extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  List<Activity> _activityList = [];
  Activity? _singleActivity;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = false;

  List<Activity> get activityList => _activityList;
  Activity? get singleActivity => _singleActivity;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  //Fetch all activities
  Future<void> getAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _activityList = await _repository.getAll();
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

  // Fetch activities by cattleId
  Future<void> getByCattleId(String cattleId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _activityList = await _repository.getByCattleId(cattleId);
      notifyListeners();
    } catch (e) {
      _error = e is Exception ? e : Exception(e.toString());
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //add new Activity
  Future<void> add(Activity a) async {
    try {
      var id = _repository.generateId();
      a = a.copyWith(id: id);
      await _repository.add(a);
      _operationStatus = 'Activity added successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  // Update cattle by id
  Future<void> update(String id, Activity a) async {
    try {
      await _repository.update(id, a);
      _operationStatus = 'Activity updated successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  // Delete cattle by id
  Future<void> delete(String id) async {
    try {
      await _repository.delete(id);
      _operationStatus = 'Activity deleted successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  // Get cattle by id
  Future<void> getById(String id) async {
    try {
      _singleActivity = await _repository.getById(id);
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }
  }

  // Get cattle by farmId parameter
  Future<void> getByFarmId(String farmId) async {
    try {
      _activityList = await _repository.getByFarmId(farmId);
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
