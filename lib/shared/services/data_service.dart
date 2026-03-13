import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final Map<String, List<Map<String, dynamic>>> _cache = {};

  Future<List<Map<String, dynamic>>> loadVocabulary(String level) async {
    return _loadData('vocabulary', level);
  }

  Future<List<Map<String, dynamic>>> loadKanji(String level) async {
    return _loadData('kanji', level);
  }

  Future<List<Map<String, dynamic>>> loadGrammar(String level) async {
    return _loadData('grammar', level);
  }

  Future<List<Map<String, dynamic>>> loadQuestions(String level) async {
    return _loadData('questions', level);
  }

  Future<List<Map<String, dynamic>>> _loadData(
      String type, String level) async {
    final key = '${type}_$level';
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/$type/${level.toLowerCase()}.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    final data = jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
    _cache[key] = data;
    return data;
  }

  /// Get count for a specific data type and level (uses cache if available)
  Future<int> getCount(String type, String level) async {
    final data = await _loadData(type, level);
    return data.length;
  }

  void clearCache() {
    _cache.clear();
  }
}
