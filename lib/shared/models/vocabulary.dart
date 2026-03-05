class Vocabulary {
  final String id;
  final String word;
  final String reading;
  final String meaningTh;
  final String meaningJa;
  final String level;
  final String partOfSpeech;
  final List<String> exampleSentences;
  final List<String> exampleTranslations;

  Vocabulary({
    required this.id,
    required this.word,
    required this.reading,
    required this.meaningTh,
    required this.meaningJa,
    required this.level,
    required this.partOfSpeech,
    this.exampleSentences = const [],
    this.exampleTranslations = const [],
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'] as String,
      word: json['word'] as String,
      reading: json['reading'] as String,
      meaningTh: json['meaning_th'] as String,
      meaningJa: json['meaning_ja'] as String,
      level: json['level'] as String,
      partOfSpeech: json['part_of_speech'] as String,
      exampleSentences: List<String>.from(json['example_sentences'] ?? []),
      exampleTranslations: List<String>.from(json['example_translations'] ?? []),
    );
  }
}
