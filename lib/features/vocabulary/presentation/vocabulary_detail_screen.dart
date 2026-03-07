import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/progress_service.dart';

class VocabularyDetailScreen extends StatefulWidget {
  final Map<String, String> vocab;
  final String level;

  const VocabularyDetailScreen({
    super.key,
    required this.vocab,
    required this.level,
  });

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
  late bool _isLearned;

  @override
  void initState() {
    super.initState();
    _isLearned = ProgressService.isWordLearned('${widget.level}_${widget.vocab['word']}');
  }

  void _toggleLearned() async {
    if (!_isLearned) {
      await ProgressService.markWordLearned('${widget.level}_${widget.vocab['word']}');
      await ProgressService.addXp(AppConstants.xpPerCorrectAnswer);
      await ProgressService.updateStreak();
      setState(() => _isLearned = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocab = widget.vocab;
    final examples = _vocabExamples[vocab['word']] ?? [];

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
                    'คำศัพท์ ${widget.level}',
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
                    // Main word card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppTheme.elevatedShadow,
                      ),
                      child: Column(
                        children: [
                          Text(
                            vocab['word']!,
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              vocab['reading']!,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Meaning
                    Text(
                      'ความหมาย',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        vocab['meaning']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Example sentences
                    if (examples.isNotEmpty) ...[
                      Text(
                        'ประโยคตัวอย่าง',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...examples.map((ex) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.format_quote_rounded,
                                  size: 18,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ex['ja']!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 26),
                              child: Text(
                                ex['th']!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.textSecondary,
                                  height: 1.4,
                                ),
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

final _vocabExamples = <String, List<Map<String, String>>>{
  '食べる': [
    {'ja': '毎朝パンを食べます。', 'th': 'กินขนมปังทุกเช้า'},
    {'ja': '一緒に昼ごはんを食べませんか。', 'th': 'จะกินข้าวเที่ยงด้วยกันไหม'},
  ],
  '飲む': [
    {'ja': '水を飲みたいです。', 'th': 'อยากดื่มน้ำ'},
    {'ja': '毎日コーヒーを飲みます。', 'th': 'ดื่มกาแฟทุกวัน'},
  ],
  '行く': [
    {'ja': '明日学校に行きます。', 'th': 'พรุ่งนี้จะไปโรงเรียน'},
    {'ja': '一緒に行きましょう。', 'th': 'ไปด้วยกันเถอะ'},
  ],
  '来る': [
    {'ja': '友だちが家に来ます。', 'th': 'เพื่อนจะมาที่บ้าน'},
    {'ja': '日本に来て3年です。', 'th': 'มาญี่ปุ่นได้ 3 ปีแล้ว'},
  ],
  '見る': [
    {'ja': '映画を見ました。', 'th': 'ดูหนังแล้ว'},
    {'ja': 'テレビを見ています。', 'th': 'กำลังดูทีวีอยู่'},
  ],
  '聞く': [
    {'ja': '音楽を聞きます。', 'th': 'ฟังเพลง'},
    {'ja': '先生に聞いてください。', 'th': 'กรุณาถามอาจารย์'},
  ],
  '読む': [
    {'ja': '本を読んでいます。', 'th': 'กำลังอ่านหนังสืออยู่'},
    {'ja': '新聞を読みますか。', 'th': 'อ่านหนังสือพิมพ์ไหม'},
  ],
  '書く': [
    {'ja': '手紙を書きました。', 'th': 'เขียนจดหมายแล้ว'},
    {'ja': '名前を書いてください。', 'th': 'กรุณาเขียนชื่อ'},
  ],
  '話す': [
    {'ja': '日本語を話せます。', 'th': 'พูดภาษาญี่ปุ่นได้'},
    {'ja': '友だちと電話で話しました。', 'th': 'คุยโทรศัพท์กับเพื่อน'},
  ],
  '買う': [
    {'ja': '新しい服を買いました。', 'th': 'ซื้อเสื้อผ้าใหม่แล้ว'},
    {'ja': 'コンビニで水を買います。', 'th': 'ซื้อน้ำที่ร้านสะดวกซื้อ'},
  ],
  '届ける': [
    {'ja': '荷物を届けてください。', 'th': 'กรุณาส่งพัสดุให้ด้วย'},
  ],
  '届く': [
    {'ja': '手紙が届きました。', 'th': 'จดหมายมาถึงแล้ว'},
  ],
  '参加する': [
    {'ja': 'パーティーに参加します。', 'th': 'จะเข้าร่วมงานปาร์ตี้'},
  ],
  '紹介する': [
    {'ja': '友だちを紹介します。', 'th': 'จะแนะนำเพื่อนให้'},
  ],
  '影響': [
    {'ja': '天気が経済に影響を与える。', 'th': 'สภาพอากาศมีอิทธิพลต่อเศรษฐกิจ'},
  ],
  '経済': [
    {'ja': '日本の経済は回復している。', 'th': 'เศรษฐกิจญี่ปุ่นกำลังฟื้นตัว'},
  ],
  '環境': [
    {'ja': '環境を守ることが大切です。', 'th': 'การรักษาสิ่งแวดล้อมเป็นสิ่งสำคัญ'},
  ],
  '技術': [
    {'ja': '日本の技術は世界で有名です。', 'th': 'เทคโนโลยีของญี่ปุ่นมีชื่อเสียงในโลก'},
  ],
  '責任': [
    {'ja': 'それは私の責任です。', 'th': 'นั่นเป็นความรับผิดชอบของฉัน'},
  ],
};
