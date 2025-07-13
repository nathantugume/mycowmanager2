import 'package:flutter/material.dart';
import 'package:mycowmanager/models/sources/source.dart';

import '../../data/repositories/source_repository.dart';

class SourcesViewModel extends ChangeNotifier{
  final SourceRepository _repository = SourceRepository();
  List<Source> _sourcesList = [];
  Source? _singleSource;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = false;

  List<Source> get sourcesList => _sourcesList;
  Source? get singleSource => _singleSource;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  //fetch all sources
  Future<void> getAll() async{
    _isLoading = true;
    try{
      _sourcesList = await _repository.getAll();
      notifyListeners();
    }catch(e){
      _error = e is Exception? e: Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  //add new source
  Future<void> add(Source s) async{
    try{
      var id = _repository.generateId();
      s = s.copyWith(id: id);
      await _repository.add(s);
    }catch(e){
      _error = e is Exception? e: Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();

    }finally{
      _isLoading = false;
      notifyListeners();

    }
  }

  //update source
  Future<void> update(String id, Source s) async {
    try{
      await _repository.update(id, s);
      _sourcesList.removeWhere((s) => s.id == id);
      _sourcesList.add(s);
      notifyListeners();
    }catch(e){
      _error = e is Exception? e: Exception(e.toString());
    }

  }

  //delete source
  Future<void> getById(String id) async{
    try{
      _singleSource = await _repository.getById(id);
      notifyListeners();
    }catch(e){
      _error = e is Exception? e: Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    }
  }

  //get by farmId
Future<void> getByFarmId(String farmId) async{
    try{
      _sourcesList = await _repository.getByFarmId(farmId);
      notifyListeners();
    }catch(e){
      _error = e is Exception? e: Exception(e.toString());
      debugPrint(_error.toString());
      notifyListeners();
    }

}

//clear any existing error messages
void clearStatus(){
    _error = null;
    _operationStatus = null;
    notifyListeners();
}

}