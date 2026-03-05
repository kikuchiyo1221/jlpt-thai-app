class UserProgress {
  final int totalXp;
  final int level;
  final int streak;
  final List<String> badges;
  final Map<String, double> accuracy; // e.g. {'vocabulary': 0.85, 'grammar': 0.72}
  final Map<String, double> levelProgress; // e.g. {'N5': 0.9, 'N4': 0.3, 'N3': 0.0}
  final Map<String, int> studyTimeMinutes; // e.g. {'2026-03-05': 30}
  final DateTime lastStudyDate;

  UserProgress({
    this.totalXp = 0,
    this.level = 1,
    this.streak = 0,
    this.badges = const [],
    this.accuracy = const {},
    this.levelProgress = const {'N5': 0.0, 'N4': 0.0, 'N3': 0.0},
    this.studyTimeMinutes = const {},
    DateTime? lastStudyDate,
  }) : lastStudyDate = lastStudyDate ?? DateTime.now();

  int get xpToNextLevel => 500 * level;
  double get xpProgress => totalXp % xpToNextLevel / xpToNextLevel;

  UserProgress copyWith({
    int? totalXp,
    int? level,
    int? streak,
    List<String>? badges,
    Map<String, double>? accuracy,
    Map<String, double>? levelProgress,
    Map<String, int>? studyTimeMinutes,
    DateTime? lastStudyDate,
  }) {
    return UserProgress(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
      accuracy: accuracy ?? this.accuracy,
      levelProgress: levelProgress ?? this.levelProgress,
      studyTimeMinutes: studyTimeMinutes ?? this.studyTimeMinutes,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
    );
  }
}
