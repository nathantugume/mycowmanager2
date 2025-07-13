import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/appuser.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  /// Call this after sign‑in
  Future<AppUser> currentUser() async {
    final uid = _auth.currentUser!.uid;
    final snap = await _db.collection('users').doc(uid).get();
    final data = snap.data()!;
    return AppUser(
      uid: uid,
      role: data['role'] as String,
      farmId: data['farmId'] as String?,
    );
  }
}