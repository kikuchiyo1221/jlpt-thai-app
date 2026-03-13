import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

class ProgressService {
  static const String _boxName = 'progress';

  static Box get _box => Hive.box(_boxName);

  // XP
  static int get totalXp => _box.get('totalXp', defaultValue: 0) as int;

  static Future<void> addXp(int amount) async {
    final current = totalXp;
    final newXp = current + amount;
    await _box.put('totalXp', newXp);
    // Check level up
    final newLevel = (newXp / AppConstants.xpPerLevelUp).floor() + 1;
    if (newLevel > level) {
      await _box.put('level', newLevel);
    }
  }

  // Level
  static int get level => _box.get('level', defaultValue: 1) as int;

  static int get xpToNextLevel => AppConstants.xpPerLevelUp * level;

  static double get xpProgress {
    final xpInCurrentLevel = totalXp % AppConstants.xpPerLevelUp;
    return xpInCurrentLevel / AppConstants.xpPerLevelUp;
  }

  // Streak
  static int get streak => _box.get('streak', defaultValue: 0) as int;

  static Future<void> updateStreak() async {
    final lastStudy = _box.get('lastStudyDate') as String?;
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    if (lastStudy == todayStr) return; // Already studied today

    if (lastStudy != null) {
      final lastDate = DateTime.parse(lastStudy);
      final diff = today.difference(lastDate).inDays;
      if (diff == 1) {
        await _box.put('streak', streak + 1);
      } else if (diff > 1) {
        await _box.put('streak', 1);
      }
    } else {
      await _box.put('streak', 1);
    }
    await _box.put('lastStudyDate', todayStr);
  }

  // Learned words tracking
  static Set<String> get learnedWords {
    final list = _box.get('learnedWords', defaultValue: <String>[]);
    return Set<String>.from(List<String>.from(list));
  }

  static Future<void> markWordLearned(String wordKey) async {
    final words = learnedWords;
    words.add(wordKey);
    await _box.put('learnedWords', words.toList());
  }

  static bool isWordLearned(String wordKey) {
    return learnedWords.contains(wordKey);
  }

  static int get totalWordsLearned => learnedWords.length;

  // Quiz accuracy
  static int get totalCorrect => _box.get('totalCorrect', defaultValue: 0) as int;
  static int get totalAnswered => _box.get('totalAnswered', defaultValue: 0) as int;

  static double get accuracy {
    if (totalAnswered == 0) return 0;
    return totalCorrect / totalAnswered;
  }

  static Future<void> recordQuizResult(int correct, int total) async {
    await _box.put('totalCorrect', totalCorrect + correct);
    await _box.put('totalAnswered', totalAnswered + total);
    await incrementTestsCompleted();
  }

  // ===== Teacher Character =====
  static String get selectedTeacherId =>
      _box.get('selectedTeacherId', defaultValue: '') as String;

  static bool get hasSelectedTeacher => selectedTeacherId.isNotEmpty;

  static Future<void> setSelectedTeacherId(String id) async {
    await _box.put('selectedTeacherId', id);
  }

  // ===== Combo System =====
  static int get bestCombo => _box.get('bestCombo', defaultValue: 0) as int;

  static Future<void> updateBestCombo(int combo) async {
    if (combo > bestCombo) {
      await _box.put('bestCombo', combo);
    }
  }

  // ===== Tests Completed =====
  static int get totalTestsCompleted =>
      _box.get('totalTestsCompleted', defaultValue: 0) as int;

  static Future<void> incrementTestsCompleted() async {
    await _box.put('totalTestsCompleted', totalTestsCompleted + 1);
  }

  // ===== Daily Challenge =====
  static bool get isDailyChallengeCompleted {
    final date = _box.get('dailyChallengeDate', defaultValue: '') as String;
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return date == todayStr;
  }

  static Future<void> completeDailyChallenge() async {
    if (isDailyChallengeCompleted) return;
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await _box.put('dailyChallengeDate', todayStr);
    await addXp(AppConstants.xpPerDailyChallenge);
  }

  // ===== Player Title =====
  static String get playerTitle {
    final xp = totalXp;
    for (int i = AppConstants.titleThresholds.length - 1; i >= 0; i--) {
      if (xp >= AppConstants.titleThresholds[i]['xp']!) {
        return AppConstants.titleNames[i];
      }
    }
    return AppConstants.titleNames[0];
  }

  static String get playerTitleJp {
    final xp = totalXp;
    for (int i = AppConstants.titleThresholds.length - 1; i >= 0; i--) {
      if (xp >= AppConstants.titleThresholds[i]['xp']!) {
        return AppConstants.titleNamesJp[i];
      }
    }
    return AppConstants.titleNamesJp[0];
  }
}
