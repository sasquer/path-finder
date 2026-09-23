import 'package:path_finder/core/storage/key_value_storage.dart';
import 'package:path_finder/domain/repositories/api_url_repository.dart';

class ApiUrlRepositoryImpl implements ApiUrlRepository {
  const ApiUrlRepositoryImpl(this._storage);

  static const _apiUrlKey = 'api_url';

  final KeyValueStorage _storage;

  @override
  Future<String?> getSavedUrl() => _storage.getString(_apiUrlKey);

  @override
  Future<void> saveUrl(String url) async {
    if (await getSavedUrl() == url) return;
    await _storage.setString(_apiUrlKey, url);
  }
}
