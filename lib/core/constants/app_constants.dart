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
  static const int xpPerComboBonus = 5;
  static const int xpPerDailyChallenge = 30;
  static const int comboThreshold = 3; // consecutive correct answers for bonus

  // Player Titles
  static const List<Map<String, int>> titleThresholds = [
    {'xp': 0},
    {'xp': 500},
    {'xp': 2000},
    {'xp': 5000},
    {'xp': 10000},
    {'xp': 25000},
  ];

  static const List<String> titleNames = [
    'นักเรียนใหม่',
    'นักเรียนขยัน',
    'นักเรียนเก่ง',
    'ผู้ช่วยอาจารย์',
    'ผู้เชี่ยวชาญ',
    'ปรมาจารย์',
  ];

  static const List<String> titleNamesJp = [
    '新入生',
    '頑張り屋',
    '優等生',
    '助手',
    '達人',
    '先生',
  ];

  // Cache
  static const Duration cacheDuration = Duration(days: 7);
}
