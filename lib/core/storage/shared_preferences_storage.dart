import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/storage/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage implements KeyValueStorage {
  const SharedPreferencesStorage(this._preferences);

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> getString(String key) => _guard(() => _preferences.getString(key));

  @override
  Future<void> setString(String key, String value) =>
      _guard(() => _preferences.setString(key, value));

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Exception catch (e) {
      throw StorageException(e.toString());
    }
  }
}
