import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

class CacheService {
  static const String _cacheBox = 'cache';
  static const String _progressBox = 'progress';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_cacheBox);
    await Hive.openBox(_progressBox);
  }

  // Cache API responses
  Future<void> cacheData(String key, dynamic data) async {
    final box = Hive.box(_cacheBox);
    await box.put(key, {
      'data': data,
      'cachedAt': DateTime.now().toIso8601String(),
    });
  }

  dynamic getCachedData(String key) {
    final box = Hive.box(_cacheBox);
    final cached = box.get(key);
    if (cached == null) return null;

    final cachedAt = DateTime.parse(cached['cachedAt']);
    if (DateTime.now().difference(cachedAt) > AppConstants.cacheDuration) {
      box.delete(key);
      return null;
    }
    return cached['data'];
  }

  // User progress
  Future<void> saveProgress(String key, dynamic value) async {
    final box = Hive.box(_progressBox);
    await box.put(key, value);
  }

  dynamic getProgress(String key) {
    final box = Hive.box(_progressBox);
    return box.get(key);
  }
}
