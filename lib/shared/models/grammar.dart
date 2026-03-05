class Grammar {
  final String id;
  final String pattern;
  final String meaningTh;
  final String meaningJa;
  final String level;
  final String formation;
  final List<GrammarExample> examples;

  Grammar({
    required this.id,
    required this.pattern,
    required this.meaningTh,
    required this.meaningJa,
    required this.level,
    required this.formation,
    this.examples = const [],
  });

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      id: json['id'] as String,
      pattern: json['pattern'] as String,
      meaningTh: json['meaning_th'] as String,
      meaningJa: json['meaning_ja'] as String,
      level: json['level'] as String,
      formation: json['formation'] as String,
      examples: (json['examples'] as List?)
              ?.map((e) => GrammarExample.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class GrammarExample {
  final String sentence;
  final String translationTh;

  GrammarExample({
    required this.sentence,
    required this.translationTh,
  });

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      sentence: json['sentence'] as String,
      translationTh: json['translation_th'] as String,
    );
  }
}
