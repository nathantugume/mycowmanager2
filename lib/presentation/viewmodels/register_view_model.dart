import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel(this._repo);
   AuthRepository _repo;

  bool isLoading = false;
  String? error;

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      await _repo.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      error = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void update(AuthRepository repo) {
    // Only if needed (e.g. hot reload)
    _repo = repo;
  }
}