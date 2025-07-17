import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/domain/models/appuser.dart';

class UserRepository {
  final FirestoreRepository<AppUser> _userRepo = FirestoreRepository<AppUser>(
    collectionName: 'users',
    fromJson: (json) => AppUser.fromJson(json),
    toJson: (u) => u.toJson(),
  );

  Future<List<AppUser>> getAll() async => _userRepo.getAll();
  Future<void> add(AppUser u) => _userRepo.add(u, id: u.uid);
  Future<void> update(String id, AppUser u) => _userRepo.update(id, u);
  Future<void> delete(String id) => _userRepo.delete(id);
  Future<AppUser?> getById(String id) => _userRepo.getById(id);
  Future<List<AppUser>> getByFarmId(String farmId) =>
      _userRepo.getByParameter('farmId', farmId);
  String generateId() => _userRepo.generateId();
}
