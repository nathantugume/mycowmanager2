import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/breed/breed.dart';

class BreedRepository{
  final FirestoreRepository<Breed> _breedRepo = FirestoreRepository<Breed>(
    collectionName: 'breed',
    fromJson: (json) => Breed.fromJson(json),
    toJson: (b) => b.toJson(),
  );

  Future<List<Breed>> getAll() async => _breedRepo.getAll();
  Future<void> add(Breed b)             => _breedRepo.add(b);
  Future<void> update(String id, Breed b)=> _breedRepo.update(id,b);
  Future<void> delete(String id)          => _breedRepo.delete(id);
  Future<Breed?> getById(String id)      => _breedRepo.getById(id);
  Future<List<Breed>> getByFarmId(String farmId)
  => _breedRepo.getByParameter('farmId', farmId);

}