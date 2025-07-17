
import 'package:mycowmanager/data/repositories/firestore_repository.dart';

import '../../models/sources/source.dart';

class SourceRepository{
    final FirestoreRepository<Source> _sourceRepo = FirestoreRepository<Source>(
      collectionName: 'sources',
      fromJson: (json) => Source.fromJson(json),
      toJson: (c) => c.toJson(),

    );
    Future<List<Source>> getAll() async => _sourceRepo.getAll();        // returns Future
    Future<void> add(Source c)             => _sourceRepo.add(c,id: c.id);
    Future<void> update(String id, Source c)=> _sourceRepo.update(id,c);
    Future<void> delete(String id)          => _sourceRepo.delete(id);
    Future<Source?> getById(String id)      => _sourceRepo.getById(id);
    Future<List<Source>> getByFarmId(String farmId)
    => _sourceRepo.getByParameter('farmId', farmId);
    //generate id
    String generateId() => _sourceRepo.generateId();



}