import 'package:flutter/material.dart';
import 'package:mycowmanager/data/repositories/activity_repository.dart';
import 'package:mycowmanager/models/activities/activity.dart';

class ActivitiesReportViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository = ActivityRepository();

  List<Activity> _allActivities = [];
  List<Activity> _filteredActivities = [];

  List<Activity> get activities => _filteredActivities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchData(String farmId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allActivities = await _activityRepository.getByFarmId(farmId);
      _filteredActivities = _allActivities;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters({
    String? activityType,
    DateTimeRange? dateRange,
    String? status,
  }) {
    _filteredActivities = _allActivities;

    if (activityType != null && activityType != 'All') {
      _filteredActivities =
          _filteredActivities.where((a) => a.type == activityType).toList();
    }

    if (dateRange != null) {
      _filteredActivities = _filteredActivities
          .where((a) =>
              DateTime.parse(a.date).isAfter(dateRange.start) &&
              DateTime.parse(a.date).isBefore(dateRange.end))
          .toList();
    }

    if (status != null && status != 'All') {
      // Assuming notes contain status information
      _filteredActivities = _filteredActivities
          .where((a) => a.notes?.toLowerCase().contains(status.toLowerCase()) ?? false)
          .toList();
    }

    notifyListeners();
  }
}
