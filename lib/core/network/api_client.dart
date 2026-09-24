abstract interface class ApiClient {
  Future<Object?> getJson(Uri uri);

  Future<Object?> postJson(Uri uri, Object? body);
}
