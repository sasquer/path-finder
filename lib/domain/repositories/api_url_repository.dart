abstract interface class ApiUrlRepository {
  Future<String?> getSavedUrl();

  Future<void> saveUrl(String url);
}
