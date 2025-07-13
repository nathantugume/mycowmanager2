
abstract class FirestoreRepositoryCallback {
  void onSuccess(String message);
  void onFailure(Exception e);
}


abstract class  DataCallback<T> {
  void onData(T? data);
  void onFailure(Exception e);
  void onSuccess(List<T> list);
}
