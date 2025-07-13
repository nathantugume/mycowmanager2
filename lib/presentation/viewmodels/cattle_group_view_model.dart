import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mycowmanager/data/repositories/cattle_group_repository.dart';
import 'package:mycowmanager/models/cattle_group/cattle_group.dart';

import '../../data/repositories/cattle_repository.dart';

class CattleGroupViewModel extends ChangeNotifier{
  final CattleGroupRepository _repository = CattleGroupRepository();

  List<CattleGroup> _cattleGroupList = [];
  CattleGroup? _singleCattleGroup;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = false;


  List<CattleGroup> get cattleList => _cattleGroupList;
  CattleGroup? get singleCattle => _singleCattleGroup;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  // Fetch all cattle groups
  Future<void> getAll() async {
    _isLoading = true;
    try {
      _cattleGroupList = await _repository.getAll();
      if (kDebugMode) {
        print(_cattleGroupList.length);
      }
      notifyListeners();
    } catch (e) {
      _error = e is Exception ? e : Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  //Add new group
  Future<void> add(CattleGroup g) async {
    _isLoading = true;

    try {
      await _repository.add(g);
      _operationStatus = 'Group added successfully';
      notifyListeners();
    } catch (e) {
      _error = e as Exception;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  //update breed
  Future<void> update(String id, CattleGroup b) async {
    _isLoading = true;
    try{
      await _repository.update(id, b);
      _operationStatus = 'Group updated successfully';
      notifyListeners();
    }catch(e){
      _error = e as Exception;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();

    }
  }

  //delete breed
  Future<void> delete(String id) async {
    _isLoading = true;
    try{
      await _repository.delete(id);
      _operationStatus = 'Group deleted successfully';
      notifyListeners();
    }catch(e){
      _error = e as Exception;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  //get breed by id
  Future<void> getById(String id) async {
    _isLoading = true;
    try{
      _singleCattleGroup = await _repository.getById(id);
      notifyListeners();
    }catch(e){
      _error = e as Exception;
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  //get breed by farmId
  Future<void> getByFarmId(String farmId) async {
    _isLoading = true;
    try{
      _cattleGroupList = await _repository.getByFarmId(farmId);
      notifyListeners();
    }catch(e){
      _error = e as Exception;
      notifyListeners();
    }finally{
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



}