class AppConstants {
  static const String appName = 'JLPT Thai';
  static const String appVersion = '1.0.0';

  // JLPT Levels
  static const List<String> jlptLevels = ['N5', 'N4', 'N3'];

  // API
  static const String apiBaseUrl = 'https://api.jlptthai.com/api/v1';

  // Gamification
  static const int xpPerCorrectAnswer = 10;
  static const int xpPerLesson = 50;
  static const int xpPerLevelUp = 500;

  // Cache
  static const Duration cacheDuration = Duration(days: 7);
}
