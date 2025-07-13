import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/appuser.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? db,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  // Stream of user auth changes (null when signed‑out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Stream of AppUser doc (null until loaded)
  Stream<AppUser?> appUserStream(String uid) => _db
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snap) => snap.exists ? AppUser.fromJson(snap.data()!) : null);

  Future<User?> signIn({required String email, required String password}) async {
    final creds =
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return creds.user;
  }

  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    String role = 'Manager',
    String? farmId,
  }) async {
    final creds =
    await _auth.createUserWithEmailAndPassword(email: email, password: password);

    final userDoc = AppUser(
      uid: creds.user!.uid,
      name: name,
      email: email,
      phone: phone,
      role: role,
      farmId: farmId,
      profilePictureUrl: null,
    );

    await _db.collection('users').doc(userDoc.uid).set(userDoc.toJson());
    return creds.user;
  }

  Future<void> signOut() => _auth.signOut();



}