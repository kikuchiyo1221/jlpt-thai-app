class Kanji {
  final String id;
  final String character;
  final String onyomi;
  final String kunyomi;
  final String meaningTh;
  final String meaningJa;
  final String level;
  final int strokeCount;
  final List<String> exampleWords;
  final List<String> exampleReadings;

  Kanji({
    required this.id,
    required this.character,
    required this.onyomi,
    required this.kunyomi,
    required this.meaningTh,
    required this.meaningJa,
    required this.level,
    required this.strokeCount,
    this.exampleWords = const [],
    this.exampleReadings = const [],
  });

  factory Kanji.fromJson(Map<String, dynamic> json) {
    return Kanji(
      id: json['id'] as String,
      character: json['character'] as String,
      onyomi: json['onyomi'] as String,
      kunyomi: json['kunyomi'] as String,
      meaningTh: json['meaning_th'] as String,
      meaningJa: json['meaning_ja'] as String,
      level: json['level'] as String,
      strokeCount: json['stroke_count'] as int,
      exampleWords: List<String>.from(json['example_words'] ?? []),
      exampleReadings: List<String>.from(json['example_readings'] ?? []),
    );
  }
}
