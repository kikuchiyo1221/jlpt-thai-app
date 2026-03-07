import 'package:flutter/material.dart';

/// A text widget that shows furigana (reading) popup on long press.
/// Kanji characters are detected automatically and their readings
/// are looked up from a built-in dictionary.
class FuriganaText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const FuriganaText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  static bool _isKanji(int codeUnit) {
    return (codeUnit >= 0x4E00 && codeUnit <= 0x9FFF) ||
        (codeUnit >= 0x3400 && codeUnit <= 0x4DBF);
  }

  static bool _containsKanji(String text) {
    return text.codeUnits.any(_isKanji);
  }

  /// Parse text into segments of kanji-groups and non-kanji text
  static List<_TextSegment> _parseSegments(String text) {
    final segments = <_TextSegment>[];
    final buffer = StringBuffer();
    bool? lastWasKanji;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final isKanji = _isKanji(char.codeUnits.first);

      if (lastWasKanji != null && isKanji != lastWasKanji) {
        segments.add(_TextSegment(buffer.toString(), lastWasKanji));
        buffer.clear();
      }
      buffer.write(char);
      lastWasKanji = isKanji;
    }
    if (buffer.isNotEmpty && lastWasKanji != null) {
      segments.add(_TextSegment(buffer.toString(), lastWasKanji));
    }
    return segments;
  }

  void _showFuriganaPopup(BuildContext context) {
    if (!_containsKanji(text)) return;

    final segments = _parseSegments(text);
    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // prevent dismiss on card tap
            child: Card(
              margin: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.translate, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          'ふりがな',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: segments.map((seg) {
                        if (!seg.isKanji) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              seg.text,
                              style: baseStyle.copyWith(
                                fontSize: (baseStyle.fontSize ?? 16) * 1.1,
                              ),
                            ),
                          );
                        }
                        // Look up reading for kanji group
                        final reading = _getReading(seg.text);
                        return _FuriganaUnit(
                          kanji: seg.text,
                          reading: reading,
                          style: baseStyle,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'タップして閉じる',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _getReading(String kanjiText) {
    // Try compound word first
    if (_compoundReadings.containsKey(kanjiText)) {
      return _compoundReadings[kanjiText]!;
    }
    // Fall back to individual kanji readings
    return kanjiText.split('').map((char) {
      return _kanjiReadings[char] ?? char;
    }).join('');
  }

  @override
  Widget build(BuildContext context) {
    final hasKanji = _containsKanji(text);
    return GestureDetector(
      onLongPress: hasKanji ? () => _showFuriganaPopup(context) : null,
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

class _TextSegment {
  final String text;
  final bool isKanji;
  _TextSegment(this.text, this.isKanji);
}

class _FuriganaUnit extends StatelessWidget {
  final String kanji;
  final String reading;
  final TextStyle style;

  const _FuriganaUnit({
    required this.kanji,
    required this.reading,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = (style.fontSize ?? 16) * 1.1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reading,
          style: TextStyle(
            fontSize: fontSize * 0.45,
            color: const Color(0xFF6C63FF),
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        Text(
          kanji,
          style: style.copyWith(fontSize: fontSize),
        ),
      ],
    );
  }
}

// Compound word readings
const _compoundReadings = <String, String>{
  '食': 'た',
  '飲': 'の',
  '読': 'よ',
  '聞': 'き',
  '映画': 'えいが',
  '友': 'とも',
  '昨日': 'きのう',
  '建物': 'たてもの',
  '日本語': 'にほんご',
  '日本': 'にほん',
  '勉強': 'べんきょう',
  '学校': 'がっこう',
  '病院': 'びょういん',
  '図書館': 'としょかん',
  '大学': 'だいがく',
  '東京': 'とうきょう',
  '毎朝': 'まいあさ',
  '毎日': 'まいにち',
  '公園': 'こうえん',
  '家族': 'かぞく',
  '朝': 'あさ',
  '会議': 'かいぎ',
  '資料': 'しりょう',
  '電車': 'でんしゃ',
  '漢字': 'かんじ',
  '先生': 'せんせい',
  '社長': 'しゃちょう',
  '意見': 'いけん',
  '勇気': 'ゆうき',
  '歌手': 'かしゅ',
  '女優': 'じょゆう',
  '有名': 'ゆうめい',
  '努力': 'どりょく',
  '結果': 'けっか',
  '問題': 'もんだい',
  '部屋': 'へや',
  '台風': 'たいふう',
  '練習': 'れんしゅう',
  '会社': 'かいしゃ',
  '卒業': 'そつぎょう',
  '大切': 'たいせつ',
  '写真': 'しゃしん',
  '上手': 'じょうず',
  '荷物': 'にもつ',
  '野菜': 'やさい',
  '子': 'こ',
  '料理': 'りょうり',
  '客様': 'きゃくさま',
  '丁寧': 'ていねい',
  '約束': 'やくそく',
};

// Individual kanji readings (most common reading)
const _kanjiReadings = <String, String>{
  '食': 'た',
  '飲': 'の',
  '読': 'よ',
  '聞': 'き',
  '見': 'み',
  '言': 'い',
  '行': 'い',
  '来': 'く',
  '出': 'で',
  '入': 'はい',
  '買': 'か',
  '書': 'か',
  '話': 'はな',
  '教': 'おし',
  '走': 'はし',
  '泳': 'およ',
  '歩': 'ある',
  '起': 'お',
  '寝': 'ね',
  '待': 'ま',
  '立': 'た',
  '座': 'すわ',
  '使': 'つか',
  '作': 'つく',
  '持': 'も',
  '知': 'し',
  '思': 'おも',
  '考': 'かんが',
  '売': 'う',
  '借': 'か',
  '返': 'かえ',
  '届': 'とど',
  '送': 'おく',
  '受': 'う',
  '開': 'あ',
  '閉': 'し',
  '始': 'はじ',
  '終': 'お',
  '住': 'す',
  '働': 'はたら',
  '遊': 'あそ',
  '決': 'き',
  '変': 'か',
  '落': 'お',
  '止': 'と',
  '辞': 'や',
  '降': 'ふ',
  '疲': 'つか',
  '困': 'こま',
  '大': 'おお',
  '小': 'ちい',
  '多': 'おお',
  '少': 'すく',
  '高': 'たか',
  '安': 'やす',
  '新': 'あたら',
  '古': 'ふる',
  '長': 'なが',
  '短': 'みじか',
  '広': 'ひろ',
  '暑': 'あつ',
  '寒': 'さむ',
  '難': 'むずか',
  '重': 'おも',
  '軽': 'かる',
  '明': 'あか',
  '暗': 'くら',
  '早': 'はや',
  '遅': 'おそ',
  '強': 'つよ',
  '弱': 'よわ',
  '美': 'うつく',
  '楽': 'たの',
  '忙': 'いそが',
  '日': 'にち',
  '月': 'つき',
  '年': 'ねん',
  '時': 'じ',
  '分': 'ふん',
  '前': 'まえ',
  '後': 'あと',
  '今': 'いま',
  '朝': 'あさ',
  '昼': 'ひる',
  '夜': 'よる',
  '夕': 'ゆう',
  '週': 'しゅう',
  '曜': 'よう',
  '春': 'はる',
  '夏': 'なつ',
  '秋': 'あき',
  '冬': 'ふゆ',
  '人': 'ひと',
  '男': 'おとこ',
  '女': 'おんな',
  '子': 'こ',
  '父': 'ちち',
  '母': 'はは',
  '友': 'とも',
  '家': 'いえ',
  '族': 'ぞく',
  '生': 'せい',
  '学': 'がく',
  '先': 'せん',
  '校': 'こう',
  '山': 'やま',
  '川': 'かわ',
  '田': 'た',
  '花': 'はな',
  '木': 'き',
  '水': 'みず',
  '火': 'ひ',
  '金': 'かね',
  '土': 'つち',
  '天': 'てん',
  '気': 'き',
  '雨': 'あめ',
  '雪': 'ゆき',
  '風': 'かぜ',
  '空': 'そら',
  '海': 'うみ',
  '車': 'くるま',
  '電': 'でん',
  '駅': 'えき',
  '道': 'みち',
  '店': 'みせ',
  '国': 'くに',
  '町': 'まち',
  '村': 'むら',
  '北': 'きた',
  '南': 'みなみ',
  '東': 'ひがし',
  '西': 'にし',
  '本': 'ほん',
  '語': 'ご',
  '字': 'じ',
  '文': 'ぶん',
  '名': 'な',
  '目': 'め',
  '耳': 'みみ',
  '口': 'くち',
  '手': 'て',
  '足': 'あし',
  '体': 'からだ',
  '頭': 'あたま',
  '心': 'こころ',
  '力': 'ちから',
  '白': 'しろ',
  '黒': 'くろ',
  '赤': 'あか',
  '青': 'あお',
  '色': 'いろ',
  '音': 'おと',
  '歯': 'は',
  '彼': 'かれ',
  '彼女': 'かのじょ',
  '誰': 'だれ',
  '何': 'なに',
};
