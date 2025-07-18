import 'package:flutter/material.dart';
import 'package:mycowmanager/data/repositories/cattle_group_repository.dart';
import 'package:mycowmanager/data/repositories/cattle_repository.dart';
import 'package:mycowmanager/data/repositories/milk_repository.dart';
import 'package:mycowmanager/models/cattle/cattle.dart';
import 'package:mycowmanager/models/cattle_group/cattle_group.dart';
import 'package:mycowmanager/models/milk/milking_record.dart';

class GroupsReportViewModel extends ChangeNotifier {
  final CattleGroupRepository _groupRepository = CattleGroupRepository();
  final CattleRepository _cattleRepository = CattleRepository();
  final MilkRepository _milkRepository = MilkRepository();

  List<CattleGroup> _allGroups = [];
  List<Cattle> _allCattle = [];
  List<MilkingRecord> _allMilkRecords = [];

  List<CattleGroup> _filteredGroups = [];
  List<Cattle> _filteredCattle = [];
  List<MilkingRecord> _filteredMilkRecords = [];

  List<CattleGroup> get groups => _filteredGroups;
  List<Cattle> get cattle => _filteredCattle;
  List<MilkingRecord> get milkRecords => _filteredMilkRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchData(String farmId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allGroups = await _groupRepository.getByFarmId(farmId);
      _allCattle = await _cattleRepository.getByFarmId(farmId);
      _allMilkRecords = await _milkRepository.getByFarmId(farmId);

      _filteredGroups = _allGroups;
      _filteredCattle = _allCattle;
      _filteredMilkRecords = _allMilkRecords;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters({
    String? groupId,
    DateTimeRange? dateRange,
    String? status,
  }) {
    _filteredGroups = _allGroups;
    _filteredCattle = _allCattle;
    _filteredMilkRecords = _allMilkRecords;

    if (groupId != null) {
      _filteredGroups = _allGroups.where((g) => g.id == groupId).toList();
      _filteredCattle = _allCattle
          .where((c) => c.cattleGroup == groupId)
          .toList();
    }

    if (dateRange != null) {
      _filteredMilkRecords = _allMilkRecords
          .where(
            (r) =>
                DateTime.parse(r.date).isAfter(dateRange.start) &&
                DateTime.parse(r.date).isBefore(dateRange.end),
          )
          .toList();
    }

    if (status != null && status != 'All') {
      _filteredCattle = _filteredCattle
          .where((c) => c.status.toLowerCase() == status.toLowerCase())
          .toList();
    }

    notifyListeners();
  }
}
