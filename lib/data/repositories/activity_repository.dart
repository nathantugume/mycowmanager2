import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/activities/activity.dart';

class ActivityRepository {
  final FirestoreRepository<Activity> _activityRepo =
      FirestoreRepository<Activity>(
        collectionName: 'activities',
        fromJson: (json) => Activity.fromJson(json),
        toJson: (c) => c.toJson(),
      );
  Future<List<Activity>> getAll() async =>
      _activityRepo.getAll(); // returns Future
  Future<void> add(Activity c) => _activityRepo.add(c, id: c.id);
  Future<void> update(String id, Activity c) => _activityRepo.update(id, c);
  Future<void> delete(String id) => _activityRepo.delete(id);
  Future<Activity?> getById(String id) => _activityRepo.getById(id);
  Future<List<Activity>> getByFarmId(String farmId) =>
      _activityRepo.getByParameter('farmId', farmId);

  Future<List<Activity>> getByCattleId(String cattleId) =>
      _activityRepo.getByParameter('cattleId', cattleId);
  String generateId() => _activityRepo.generateId();
}
