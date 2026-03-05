import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Future<List<dynamic>> getVocabulary(String level, {int page = 1}) async {
    final response = await _dio.get('/vocabulary', queryParameters: {
      'level': level,
      'page': page,
    });
    return response.data['data'] as List<dynamic>;
  }

  Future<List<dynamic>> getGrammar(String level, {int page = 1}) async {
    final response = await _dio.get('/grammar', queryParameters: {
      'level': level,
      'page': page,
    });
    return response.data['data'] as List<dynamic>;
  }

  Future<List<dynamic>> getKanji(String level, {int page = 1}) async {
    final response = await _dio.get('/kanji', queryParameters: {
      'level': level,
      'page': page,
    });
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getMockTest(String level) async {
    final response = await _dio.get('/mock-test', queryParameters: {
      'level': level,
    });
    return response.data['data'] as Map<String, dynamic>;
  }
}
