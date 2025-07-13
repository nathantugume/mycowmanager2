import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_repository.dart';

class FirestoreRepository<T> implements BaseRepository<T> {
  final String collectionName;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<T> get _col => _db
      .collection(collectionName)
      .withConverter<T>(
        fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
        toFirestore: (object, _) => toJson(object),
      );

  FirestoreRepository({
    required this.collectionName,
    required this.fromJson,
    required this.toJson,
  });

  @override
  Future<void> add(T entity) async {
    final id = _col.doc().id;       // auto‑generated
    await _col.doc(id).set(entity);
  }
  @override
  Future<void> update(String id, T entity) =>
      _col.doc(id).set(entity);     // overwrite

  @override
  Future<void> delete(String id) =>
      _col.doc(id).delete();

  // ──────────────────────────────────────────────────────────
  //  Queries
  // ──────────────────────────────────────────────────────────
  @override
  Future<List<T>> getAll() async {
    final qs = await _col.get();
    return qs.docs.map((d) => d.data()).toList();
  }

  @override
  Future<T?> getById(String id) async {
    final snap = await _col.doc(id).get();
    return snap.data();            // null if doc doesn’t exist
  }

  @override
  Future<List<T>> getByParameter(String field, String value) async {
    final qs = await _col.where(field, isEqualTo: value).get();
    return qs.docs.map((d) => d.data()).toList();
  }

  //  FirestoreRepository<T>
  Future<List<T>> range({
    required String dateField,          // e.g. "date"
    required DateTime from,
    required DateTime to,
    String? farmIdField,                // optional extra filter
    String? farmId,
  }) async {
    Query<T> q = _col
        .where(dateField, isGreaterThanOrEqualTo: from.toIso8601String())
        .where(dateField, isLessThanOrEqualTo: to.toIso8601String());

    if (farmIdField != null && farmId != null) {
      q = q.where(farmIdField, isEqualTo: farmId);
    }

    final qs = await q.get();
    return qs.docs.map((d) => d.data()).toList();
  }


  // ──────────────────────────────────────────────────────────
  //  Utilities
  // ──────────────────────────────────────────────────────────
  String generateId() => _col.doc().id;


}
