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
  }
}
