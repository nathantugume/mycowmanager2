import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._repo);
   late final AuthRepository _repo;

  bool isLoading = false;
  String? error;

  Future<void> signIn(String email, String password) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      await _repo.signIn(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      error = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void update(AuthRepository repo) {
    // Only if needed (e.g. hot reload)
    if (_repo != repo) {
      _repo  = repo;
    }
  }
}
