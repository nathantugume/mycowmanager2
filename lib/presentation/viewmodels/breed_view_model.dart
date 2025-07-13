import 'package:flutter/material.dart';

import '../../data/repositories/breed_repository.dart';
import '../../models/breed/breed.dart';

class BreedViewModel extends ChangeNotifier{
  final BreedRepository _repository = BreedRepository();
  List<Breed> _breedList = [];
  Breed? _singleBreed;
  String? _operationStatus;
  Exception? _error;
  bool _isLoading = false;

  List<Breed> get breedList => _breedList;
  Breed? get singleBreed => _singleBreed;
  String? get operationStatus => _operationStatus;
  Exception? get error => _error;
  bool get isLoading => _isLoading;

  //fetch all breeds
  Future<void> getAll() async{
    _isLoading = true;

    try {
      _breedList = await _repository.getAll();
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

    //add new breed
    Future<void> add(Breed b) async {
      _isLoading = true;

      try {
        await _repository.add(b);
        _operationStatus = 'Breed added successfully';
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
    Future<void> update(String id, Breed b) async {
    _isLoading = true;
    try{
      await _repository.update(id, b);
      _operationStatus = 'Breed updated successfully';
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
      _operationStatus = 'Breed deleted successfully';
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
      _singleBreed = await _repository.getById(id);
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
      _breedList = await _repository.getByFarmId(farmId);
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