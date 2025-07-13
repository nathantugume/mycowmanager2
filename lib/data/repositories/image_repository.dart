import 'package:mycowmanager/data/repositories/firestore_repository.dart';
import 'package:mycowmanager/models/image_model/image_model.dart';

class ImageRepository{
  final FirestoreRepository<ImageModel> _imageRepo = FirestoreRepository<ImageModel>(
    collectionName: 'images',
    fromJson: (json) => ImageModel.fromJson(json),
    toJson: (c) => c.toJson(),
  );
  Future<List<ImageModel>> getAll() async => _imageRepo.getAll();
  Future<void> add(ImageModel c)             => _imageRepo.add(c);
  Future<void> update(String id, ImageModel c)=> _imageRepo.update(id,c);
  Future<void> delete(String id)          => _imageRepo.delete(id);
  Future<ImageModel?> getById(String id)      => _imageRepo.getById(id);


}