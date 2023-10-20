
part of "./index_service.dart";

class LocalStorageService {
  static late final Box _box;
  static const _storageKey = 'cat-fact-storage';

  LocalStorageService._();

  static Future<LocalStorageService> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_storageKey);
    return LocalStorageService._();
  }

  T? getValue<T>(String key) {
    try {
      return _box.get(key);
    } catch (e) {
      console('error-local-storage-get ${e.toString()}', logLevel: Level.error);
      return null;
    }
  }

  Future<void> setValue(String key, dynamic value) async {
    try {
      return _box.put(key, value);
    } catch (e) {
      console('error-local-storage-set', logLevel: Level.error);
    }
  }

  Future<void> removeValue(String key) {
    return _box.delete(key);
  }

  Future<void> clear() {
    return _box.clear();
  }
}
