/// Generic contract every Firestore–backed repository must satisfy.
abstract class BaseRepository<T> {
  Future<void> add(T entity);

  Future<void> update(String id, T entity);

  Future<void> delete(String id);

  Future<List<T>> getAll();

  Future<T?> getById(String id);

  Future<List<T>> getByParameter(String field, String value);
}
