import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/progress_service.dart';
import '../../../core/constants/app_constants.dart';

class KanjiDetailScreen extends StatefulWidget {
  final Map<String, String> kanji;
  final String level;
  final Color color;

  const KanjiDetailScreen({
    super.key,
    required this.kanji,
    required this.level,
    required this.color,
  });

  @override
  State<KanjiDetailScreen> createState() => _KanjiDetailScreenState();
}

class _KanjiDetailScreenState extends State<KanjiDetailScreen> {
  late bool _isLearned;

  @override
  void initState() {
    super.initState();
    final key = 'kanji_${widget.level}_${widget.kanji['character']}';
    _isLearned = ProgressService.isWordLearned(key);
  }

  void _toggleLearned() async {
    final key = 'kanji_${widget.level}_${widget.kanji['character']}';
    if (!_isLearned) {
      await ProgressService.markWordLearned(key);
      await ProgressService.addXp(AppConstants.xpPerCorrectAnswer);
      await ProgressService.updateStreak();
    }
    setState(() => _isLearned = true);
  }

  @override
  Widget build(BuildContext context) {
    final kanji = widget.kanji;
    final readings = kanji['reading']!.split(' / ');
    final exampleWords = _kanjiExamples[kanji['character']] ?? [];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(_isLearned),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.arrow_back, size: 20, color: AppTheme.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'คันจิ ${widget.level}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (_isLearned)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: AppTheme.successColor),
                          const SizedBox(width: 4),
                          Text(
                            'เรียนแล้ว',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main kanji card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.color, widget.color.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            kanji['character']!,
                            style: const TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              kanji['meaning']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Readings
                    Text(
                      'การอ่าน',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: readings.map((r) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: widget.color.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            r.trim(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: widget.color,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // Example words
                    if (exampleWords.isNotEmpty) ...[
                      Text(
                        'คำตัวอย่าง',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...exampleWords.map((ex) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: widget.color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  ex['word']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: widget.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ex['reading']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ex['meaning']!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom button
            if (!_isLearned)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _toggleLearned,
                    icon: const Icon(Icons.check_rounded, size: 22),
                    label: const Text(
                      'จำได้แล้ว +10 XP',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final _kanjiExamples = <String, List<Map<String, String>>>{
  '日': [
    {'word': '日本', 'reading': 'にほん', 'meaning': 'ญี่ปุ่น'},
    {'word': '今日', 'reading': 'きょう', 'meaning': 'วันนี้'},
    {'word': '毎日', 'reading': 'まいにち', 'meaning': 'ทุกวัน'},
  ],
  '本': [
    {'word': '日本', 'reading': 'にほん', 'meaning': 'ญี่ปุ่น'},
    {'word': '本当', 'reading': 'ほんとう', 'meaning': 'จริง'},
    {'word': '絵本', 'reading': 'えほん', 'meaning': 'หนังสือภาพ'},
  ],
  '人': [
    {'word': '日本人', 'reading': 'にほんじん', 'meaning': 'คนญี่ปุ่น'},
    {'word': '一人', 'reading': 'ひとり', 'meaning': 'คนเดียว'},
    {'word': '大人', 'reading': 'おとな', 'meaning': 'ผู้ใหญ่'},
  ],
  '大': [
    {'word': '大学', 'reading': 'だいがく', 'meaning': 'มหาวิทยาลัย'},
    {'word': '大きい', 'reading': 'おおきい', 'meaning': 'ใหญ่'},
    {'word': '大切', 'reading': 'たいせつ', 'meaning': 'สำคัญ'},
  ],
  '学': [
    {'word': '学生', 'reading': 'がくせい', 'meaning': 'นักเรียน'},
    {'word': '大学', 'reading': 'だいがく', 'meaning': 'มหาวิทยาลัย'},
    {'word': '学校', 'reading': 'がっこう', 'meaning': 'โรงเรียน'},
  ],
  '生': [
    {'word': '学生', 'reading': 'がくせい', 'meaning': 'นักเรียน'},
    {'word': '先生', 'reading': 'せんせい', 'meaning': 'อาจารย์'},
    {'word': '生活', 'reading': 'せいかつ', 'meaning': 'ชีวิต'},
  ],
  '食': [
    {'word': '食べる', 'reading': 'たべる', 'meaning': 'กิน'},
    {'word': '食事', 'reading': 'しょくじ', 'meaning': 'อาหาร/มื้ออาหาร'},
    {'word': '食堂', 'reading': 'しょくどう', 'meaning': 'โรงอาหาร'},
  ],
  '時': [
    {'word': '時間', 'reading': 'じかん', 'meaning': 'เวลา'},
    {'word': '時計', 'reading': 'とけい', 'meaning': 'นาฬิกา'},
    {'word': '時々', 'reading': 'ときどき', 'meaning': 'บางครั้ง'},
  ],
  '影': [
    {'word': '影響', 'reading': 'えいきょう', 'meaning': 'อิทธิพล'},
    {'word': '影', 'reading': 'かげ', 'meaning': 'เงา'},
  ],
  '経': [
    {'word': '経済', 'reading': 'けいざい', 'meaning': 'เศรษฐกิจ'},
    {'word': '経験', 'reading': 'けいけん', 'meaning': 'ประสบการณ์'},
  ],
  '環': [
    {'word': '環境', 'reading': 'かんきょう', 'meaning': 'สิ่งแวดล้อม'},
  ],
  '政': [
    {'word': '政治', 'reading': 'せいじ', 'meaning': 'การเมือง'},
    {'word': '政府', 'reading': 'せいふ', 'meaning': 'รัฐบาล'},
  ],
  '産': [
    {'word': '産業', 'reading': 'さんぎょう', 'meaning': 'อุตสาหกรรม'},
    {'word': 'お土産', 'reading': 'おみやげ', 'meaning': 'ของฝาก'},
  ],
  '業': [
    {'word': '産業', 'reading': 'さんぎょう', 'meaning': 'อุตสาหกรรม'},
    {'word': '授業', 'reading': 'じゅぎょう', 'meaning': 'บทเรียน'},
  ],
  '送': [
    {'word': '送る', 'reading': 'おくる', 'meaning': 'ส่ง'},
    {'word': '放送', 'reading': 'ほうそう', 'meaning': 'ออกอากาศ'},
  ],
  '変': [
    {'word': '変える', 'reading': 'かえる', 'meaning': 'เปลี่ยน'},
    {'word': '大変', 'reading': 'たいへん', 'meaning': 'ลำบาก/มาก'},
  ],
  '決': [
    {'word': '決める', 'reading': 'きめる', 'meaning': 'ตัดสินใจ'},
    {'word': '解決', 'reading': 'かいけつ', 'meaning': 'แก้ไขปัญหา'},
  ],
  '意': [
    {'word': '意味', 'reading': 'いみ', 'meaning': 'ความหมาย'},
    {'word': '注意', 'reading': 'ちゅうい', 'meaning': 'ระวัง'},
  ],
  '味': [
    {'word': '意味', 'reading': 'いみ', 'meaning': 'ความหมาย'},
    {'word': '味', 'reading': 'あじ', 'meaning': 'รส'},
  ],
  '責': [
    {'word': '責任', 'reading': 'せきにん', 'meaning': 'ความรับผิดชอบ'},
  ],
  '術': [
    {'word': '技術', 'reading': 'ぎじゅつ', 'meaning': 'เทคโนโลยี'},
    {'word': '美術', 'reading': 'びじゅつ', 'meaning': 'ศิลปะ'},
  ],
  '治': [
    {'word': '政治', 'reading': 'せいじ', 'meaning': 'การเมือง'},
    {'word': '治る', 'reading': 'なおる', 'meaning': 'หาย (โรค)'},
  ],
  '境': [
    {'word': '環境', 'reading': 'かんきょう', 'meaning': 'สิ่งแวดล้อม'},
    {'word': '国境', 'reading': 'こっきょう', 'meaning': 'ชายแดน'},
  ],
  '済': [
    {'word': '経済', 'reading': 'けいざい', 'meaning': 'เศรษฐกิจ'},
    {'word': '済む', 'reading': 'すむ', 'meaning': 'เสร็จ'},
  ],
  '響': [
    {'word': '影響', 'reading': 'えいきょう', 'meaning': 'อิทธิพล'},
  ],
};
