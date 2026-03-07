import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/progress_service.dart';

class MockTestScreen extends StatefulWidget {
  const MockTestScreen({super.key});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  String _selectedLevel = 'N5';
  int _currentQuestion = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _showResult = false;
  bool _testStarted = false;
  List<int?> _userAnswers = [];
  List<Map<String, dynamic>> _questions = [];

  // Track used questions and incorrect concept groups across retries
  final Map<String, Set<String>> _usedQuestionIds = {};
  final Map<String, Set<String>> _incorrectGroups = {};

  static const int _questionsPerTest = 5;

  List<Map<String, dynamic>> _selectQuestions() {
    final pool = _questionPool[_selectedLevel]!;
    final used = _usedQuestionIds[_selectedLevel] ??= {};
    final incorrectGrps = _incorrectGroups[_selectedLevel] ??= {};

    final selected = <Map<String, dynamic>>[];
    final selectedIds = <String>{};
    final selectedGroups = <String>{};

    // 1) Pick variant questions for previously incorrect groups
    for (final group in incorrectGrps.toList()) {
      if (selected.length >= _questionsPerTest) break;
      final variants = pool.where((q) =>
          q['group'] == group &&
          !used.contains(q['id']) &&
          !selectedIds.contains(q['id'])).toList();
      if (variants.isNotEmpty) {
        variants.shuffle();
        selected.add(variants.first);
        selectedIds.add(variants.first['id'] as String);
        selectedGroups.add(group);
      }
    }

    // 2) Fill remaining with unseen questions from unseen groups
    final remaining = pool.where((q) =>
        !used.contains(q['id']) &&
        !selectedIds.contains(q['id']) &&
        !selectedGroups.contains(q['group'])).toList();
    remaining.shuffle();
    for (final q in remaining) {
      if (selected.length >= _questionsPerTest) break;
      if (selectedGroups.contains(q['group'])) continue;
      selected.add(q);
      selectedIds.add(q['id'] as String);
      selectedGroups.add(q['group'] as String);
    }

    // 3) If still not enough, allow same groups but different questions
    if (selected.length < _questionsPerTest) {
      final more = pool.where((q) =>
          !used.contains(q['id']) &&
          !selectedIds.contains(q['id'])).toList();
      more.shuffle();
      for (final q in more) {
        if (selected.length >= _questionsPerTest) break;
        selected.add(q);
        selectedIds.add(q['id'] as String);
      }
    }

    // 4) If pool exhausted, reset tracking and pick fresh
    if (selected.length < _questionsPerTest) {
      used.clear();
      incorrectGrps.clear();
      final fresh = pool.where((q) => !selectedIds.contains(q['id'])).toList();
      fresh.shuffle();
      for (final q in fresh) {
        if (selected.length >= _questionsPerTest) break;
        selected.add(q);
        selectedIds.add(q['id'] as String);
      }
    }

    // Mark all selected as used
    used.addAll(selectedIds);

    selected.shuffle();
    return selected;
  }

  void _startTest() {
    final questions = _selectQuestions();
    setState(() {
      _questions = questions;
      _testStarted = true;
      _currentQuestion = 0;
      _selectedAnswer = null;
      _score = 0;
      _showResult = false;
      _userAnswers = List.filled(questions.length, null);
    });
  }

  void _selectLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _testStarted = false;
      _showResult = false;
      _currentQuestion = 0;
      _selectedAnswer = null;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) return _buildResultScreen();
    if (_testStarted) return _buildQuestionScreen();
    return _buildLevelSelectScreen();
  }

  Widget _buildLevelSelectScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สอบจำลอง',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เลือกระดับที่ต้องการสอบ',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            _testLevelCard('N5', 'พื้นฐาน', '$_questionsPerTest ข้อ',
                const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)])),
            const SizedBox(height: 14),
            _testLevelCard('N4', 'ระดับกลาง-ต้น', '$_questionsPerTest ข้อ',
                const LinearGradient(colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)])),
            const SizedBox(height: 14),
            _testLevelCard('N3', 'ระดับกลาง', '$_questionsPerTest ข้อ',
                const LinearGradient(colors: [Color(0xFF00BFA6), Color(0xFF4DD0B8)])),
          ],
        ),
      ),
    );
  }

  Widget _testLevelCard(String level, String description, String questionCount, LinearGradient gradient) {
    return GestureDetector(
      onTap: () {
        _selectLevel(level);
        _startTest();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  level,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JLPT $level - $description',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    questionCount,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = _questions[_currentQuestion];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _testStarted = false),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.arrow_back, size: 20, color: AppTheme.textPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'สอบจำลอง $_selectedLevel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentQuestion + 1} / ${_questions.length}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress dots
            Row(
              children: List.generate(_questions.length, (i) {
                return Expanded(
                  child: Container(
                    height: 5,
                    margin: EdgeInsets.only(right: i < _questions.length - 1 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: i <= _currentQuestion
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'คำถามที่ ${_currentQuestion + 1}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question['question'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Choices
            ...List.generate(4, (i) {
              final choices = question['choices'] as List<String>;
              final isSelected = _selectedAnswer == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() => _selectedAnswer = i);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                                  : Text(
                                      String.fromCharCode(65 + i),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              choices[i],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            // Next button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedAnswer != null ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  _currentQuestion < _questions.length - 1
                      ? 'ถัดไป'
                      : 'ดูผลลัพธ์',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextQuestion() async {
    final question = _questions[_currentQuestion];
    _userAnswers[_currentQuestion] = _selectedAnswer;
    final isCorrect = _selectedAnswer == question['answer'];
    if (isCorrect) {
      _score++;
    } else {
      // Track incorrect group for retry with variant
      final group = question['group'] as String;
      (_incorrectGroups[_selectedLevel] ??= {}).add(group);
    }

    if (isCorrect) {
      // Remove from incorrect if answered correctly this time
      _incorrectGroups[_selectedLevel]?.remove(question['group'] as String);
    }

    if (_currentQuestion >= _questions.length - 1) {
      // Record results
      await ProgressService.recordQuizResult(_score, _questions.length);
      await ProgressService.addXp(_score * AppConstants.xpPerCorrectAnswer);
      await ProgressService.updateStreak();
    }

    setState(() {
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
        _selectedAnswer = null;
      } else {
        _showResult = true;
      }
    });
  }

  Widget _buildResultScreen() {
    final percentage = (_score / _questions.length * 100).round();
    final passed = percentage >= 70;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: passed
                    ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)])
                    : const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (passed ? AppTheme.successColor : AppTheme.warningColor)
                        .withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    passed ? Icons.emoji_events : Icons.trending_up,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ตอบถูก $_score/${_questions.length} ข้อ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    passed ? 'เก่งมาก!' : 'พยายามอีกนิดนะ!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Review header
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ทบทวนคำตอบ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Question review list
            ...List.generate(_questions.length, (i) {
              final question = _questions[i];
              final userAnswer = _userAnswers[i];
              final correctAnswer = question['answer'] as int;
              final isCorrect = userAnswer == correctAnswer;
              final choices = question['choices'] as List<String>;
              final explanation = question['explanation'] as String;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isCorrect
                        ? const Color(0xFF10B981).withValues(alpha: 0.4)
                        : const Color(0xFFEF4444).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question header with correct/incorrect badge
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCorrect ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ข้อ ${i + 1}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isCorrect
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Question text
                    Text(
                      question['question'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // User's wrong answer
                    if (!isCorrect && userAnswer != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.close, color: Color(0xFFEF4444), size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${String.fromCharCode(65 + userAnswer)}. ${choices[userAnswer]}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Correct answer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${String.fromCharCode(65 + correctAnswer)}. ${choices[correctAnswer]}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Explanation
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              explanation,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 12),

            // Action buttons
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'ลองอีกครั้ง',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => setState(() {
                  _testStarted = false;
                  _showResult = false;
                }),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'เลือกระดับอื่น',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Question pool: each question has 'id' and 'group'.
// Questions in the same group test the same concept with different wording.
// When a group is answered incorrectly, a different variant appears next test.
final _questionPool = {
  'N5': [
    // --- Group: kanji_taberu ---
    {
      'id': 'n5_01a',
      'group': 'n5_kanji_taberu',
      'question': '「たべる」の漢字はどれですか。',
      'choices': ['食べる', '飲べる', '読べる', '聞べる'],
      'answer': 0,
      'explanation': '「食べる」（たべる）แปลว่า กิน\n食 = อาหาร/กิน　飲 = ดื่ม　読 = อ่าน　聞 = ฟัง',
    },
    {
      'id': 'n5_01b',
      'group': 'n5_kanji_taberu',
      'question': '「食べる」の読み方はどれですか。',
      'choices': ['のべる', 'たべる', 'あべる', 'かべる'],
      'answer': 1,
      'explanation': '「食べる」は「たべる」と読みます。แปลว่า กิน\n食 という漢字は「た（べる）」や「ショク」と読みます。',
    },
    // --- Group: particle_to ---
    {
      'id': 'n5_02a',
      'group': 'n5_particle_to',
      'question': '昨日、友だち＿＿映画を見ました。',
      'choices': ['を', 'に', 'と', 'で'],
      'answer': 2,
      'explanation': '助詞「と」ใช้เมื่อทำกิจกรรมร่วมกับคนอื่น แปลว่า "กับ"\n友だちと映画を見ました = ดูหนังกับเพื่อน',
    },
    {
      'id': 'n5_02b',
      'group': 'n5_particle_to',
      'question': '日曜日に家族＿＿公園に行きました。',
      'choices': ['で', 'と', 'に', 'を'],
      'answer': 1,
      'explanation': '助詞「と」ใช้เมื่อทำกิจกรรมร่วมกับคนอื่น แปลว่า "กับ"\n家族と公園に行きました = ไปสวนสาธารณะกับครอบครัว',
    },
    // --- Group: kanji_ookii ---
    {
      'id': 'n5_03a',
      'group': 'n5_kanji_ookii',
      'question': '「おおきい」の漢字はどれですか。',
      'choices': ['小さい', '大きい', '多きい', '太きい'],
      'answer': 1,
      'explanation': '「大きい」（おおきい）แปลว่า ใหญ่\n小さい = เล็ก　大 = ใหญ่　多 = มาก　太 = อ้วน/หนา',
    },
    {
      'id': 'n5_03b',
      'group': 'n5_kanji_ookii',
      'question': 'あの建物はとても＿＿です。（ใหญ่）',
      'choices': ['小さい', '高い', '大きい', '長い'],
      'answer': 2,
      'explanation': '「大きい」（おおきい）แปลว่า ใหญ่\n小さい = เล็ก　高い = สูง/แพง　長い = ยาว',
    },
    // --- Group: particle_wo ---
    {
      'id': 'n5_04a',
      'group': 'n5_particle_wo',
      'question': 'まいにち にほんご＿＿べんきょうします。',
      'choices': ['が', 'に', 'を', 'で'],
      'answer': 2,
      'explanation': '助詞「を」ใช้แสดงกรรมของกริยา (สิ่งที่ถูกกระทำ)\nにほんごを勉強します = เรียนภาษาญี่ปุ่น',
    },
    {
      'id': 'n5_04b',
      'group': 'n5_particle_wo',
      'question': '朝ごはん＿＿食べましたか。',
      'choices': ['に', 'を', 'が', 'で'],
      'answer': 1,
      'explanation': '助詞「を」ใช้แสดงกรรมของกริยา (สิ่งที่ถูกกระทำ)\n朝ごはんを食べました = กินข้าวเช้าแล้ว',
    },
    // --- Group: meaning_gakkou ---
    {
      'id': 'n5_05a',
      'group': 'n5_meaning_gakkou',
      'question': '「がっこう」はどういう意味ですか。',
      'choices': ['โรงพยาบาล', 'โรงเรียน', 'ห้องสมุด', 'สถานี'],
      'answer': 1,
      'explanation': '「学校」（がっこう）แปลว่า โรงเรียน\nโรงพยาบาล = 病院　ห้องสมุด = 図書館　สถานี = 駅',
    },
    {
      'id': 'n5_05b',
      'group': 'n5_meaning_gakkou',
      'question': 'タイ語で「โรงเรียน」は日本語で何ですか。',
      'choices': ['図書館', '病院', '学校', '大学'],
      'answer': 2,
      'explanation': '「学校」（がっこう）แปลว่า โรงเรียน\n図書館 = ห้องสมุด　病院 = โรงพยาบาล　大学 = มหาวิทยาลัย',
    },
    // --- Group: kanji_nomu ---
    {
      'id': 'n5_06a',
      'group': 'n5_kanji_nomu',
      'question': '「のむ」の漢字はどれですか。',
      'choices': ['飲む', '食む', '読む', '休む'],
      'answer': 0,
      'explanation': '「飲む」（のむ）แปลว่า ดื่ม\n食 = กิน　読 = อ่าน　休 = พักผ่อน',
    },
    {
      'id': 'n5_06b',
      'group': 'n5_kanji_nomu',
      'question': 'コーヒーを＿＿。（ดื่ม）',
      'choices': ['食べます', '飲みます', '読みます', '見ます'],
      'answer': 1,
      'explanation': '「飲む」（のむ）แปลว่า ดื่ม\nコーヒーを飲みます = ดื่มกาแฟ',
    },
    // --- Group: particle_ni ---
    {
      'id': 'n5_07',
      'group': 'n5_particle_ni',
      'question': '毎朝7時＿＿起きます。',
      'choices': ['を', 'で', 'に', 'と'],
      'answer': 2,
      'explanation': '助詞「に」ใช้กับเวลาที่แน่นอน แปลว่า "ตอน/เมื่อ"\n7時に起きます = ตื่นตอน 7 โมง',
    },
    // --- Group: particle_de ---
    {
      'id': 'n5_08',
      'group': 'n5_particle_de',
      'question': 'レストラン＿＿昼ごはんを食べました。',
      'choices': ['に', 'を', 'で', 'と'],
      'answer': 2,
      'explanation': '助詞「で」ใช้แสดงสถานที่ที่ทำกิจกรรม แปลว่า "ที่"\nレストランで食べました = กินที่ร้านอาหาร',
    },
    // --- Group: adj_meaning ---
    {
      'id': 'n5_09',
      'group': 'n5_adj_meaning',
      'question': '「あたらしい」はどういう意味ですか。',
      'choices': ['เก่า', 'ใหม่', 'เล็ก', 'สูง'],
      'answer': 1,
      'explanation': '「新しい」（あたらしい）แปลว่า ใหม่\nเก่า = 古い　เล็ก = 小さい　สูง = 高い',
    },
    // --- Group: verb_iku ---
    {
      'id': 'n5_10',
      'group': 'n5_verb_iku',
      'question': '明日、東京＿＿行きます。',
      'choices': ['を', 'で', 'に', 'と'],
      'answer': 2,
      'explanation': '助詞「に」ใช้กับทิศทาง/จุดหมายปลายทาง\n東京に行きます = ไปโตเกียว\nกริยาที่แสดงการเคลื่อนที่ (行く・来る・帰る) ใช้ に',
    },
  ],
  'N4': [
    // --- Group: grammar_maeni ---
    {
      'id': 'n4_01a',
      'group': 'n4_grammar_maeni',
      'question': '会議に＿＿前に、資料を読んでおいてください。',
      'choices': ['出る', '出た', '出て', '出よう'],
      'answer': 0,
      'explanation': '文法「〜前に」ต้องใช้กริยารูปพจนานุกรม (辞書形)\n出る前に = ก่อนออก（ไปประชุม）\nรูปนี้แปลว่า "ก่อนที่จะ〜 กรุณาอ่านเอกสารไว้ก่อน"',
    },
    {
      'id': 'n4_01b',
      'group': 'n4_grammar_maeni',
      'question': '寝る＿＿に、歯を磨きます。',
      'choices': ['後', '前', 'まで', 'から'],
      'answer': 1,
      'explanation': '「〜前に」แปลว่า "ก่อนที่จะ〜"\n寝る前に歯を磨きます = แปรงฟันก่อนนอน\n動詞辞書形＋前に の形を使います。',
    },
    // --- Group: grammar_sou ---
    {
      'id': 'n4_02a',
      'group': 'n4_grammar_sou',
      'question': 'このケーキはおいしい＿＿です。',
      'choices': ['よう', 'そう', 'らしい', 'みたい'],
      'answer': 1,
      'explanation': '「〜そうです」ใช้กับคำคุณศัพท์เมื่อดูจากรูปลักษณ์ แปลว่า "ดูเหมือนว่า〜"\nおいしそう = ดูอร่อย（ตัด い แล้วใช้ そう）\nต่างจาก よう/みたい ที่ต้องต่อท้ายแบบอื่น',
    },
    {
      'id': 'n4_02b',
      'group': 'n4_grammar_sou',
      'question': '空が暗いです。雨が降り＿＿です。',
      'choices': ['そう', 'よう', 'らしい', 'みたい'],
      'answer': 0,
      'explanation': '「〜そうです」กับกริยา ตัด ます แล้วต่อ そう\n降ります → 降りそうです = ดูเหมือนฝนจะตก\nดูจากสถานการณ์แล้วคาดเดา',
    },
    // --- Group: grammar_tekara ---
    {
      'id': 'n4_03a',
      'group': 'n4_grammar_tekara',
      'question': '日本に来て＿＿、毎日日本語を使っています。',
      'choices': ['から', 'まで', 'ので', 'のに'],
      'answer': 0,
      'explanation': '「〜てから」แปลว่า "ตั้งแต่〜" ใช้แสดงจุดเริ่มต้นของการกระทำ\n日本に来てから = ตั้งแต่มาญี่ปุ่น（ก็ใช้ภาษาญี่ปุ่นทุกวัน）',
    },
    {
      'id': 'n4_03b',
      'group': 'n4_grammar_tekara',
      'question': '大学を卒業して＿＿、この会社で働いています。',
      'choices': ['のに', 'から', 'まで', 'けど'],
      'answer': 1,
      'explanation': '「〜てから」แปลว่า "ตั้งแต่〜" ใช้แสดงจุดเริ่มต้นของการกระทำ\n卒業してから = ตั้งแต่เรียนจบ（ก็ทำงานที่บริษัทนี้）',
    },
    // --- Group: te_form ---
    {
      'id': 'n4_04a',
      'group': 'n4_te_form',
      'question': '先生に＿＿て、漢字の読み方を教えてもらいました。',
      'choices': ['聞い', '聞き', '聞か', '聞く'],
      'answer': 0,
      'explanation': '「聞く」เป็นกริยาหมู่ 1 (五段動詞) รูป て → 聞いて\nกริยาที่ลงท้าย く → いて（เช่น 書く→書いて）\n聞いて教えてもらう = ถามแล้วให้สอน',
    },
    {
      'id': 'n4_04b',
      'group': 'n4_te_form',
      'question': '友だちに本を＿＿て、まだ返していません。',
      'choices': ['借り', '借る', '借り', '借っ'],
      'answer': 0,
      'explanation': '「借りる」เป็นกริยาหมู่ 2 (一段動詞) รูป て → 借りて\nกริยาหมู่ 2 ตัด る แล้วเติม て\n借りて返していない = ยืมแล้วยังไม่ได้คืน',
    },
    // --- Group: grammar_sou_verb ---
    {
      'id': 'n4_05a',
      'group': 'n4_grammar_sou_verb',
      'question': '電車が＿＿そうです。（もうすぐ来る）',
      'choices': ['来る', '来', '来い', '来た'],
      'answer': 1,
      'explanation': '「〜そうです」（ดูเหมือนว่าจะ〜）ใช้กับกริยา ต้องตัด語尾ออก\n来る → 来（き）そうです = ดูเหมือนรถไฟจะมา\nต่างจาก来るそうです（ได้ยินมาว่า = 伝聞）',
    },
    {
      'id': 'n4_05b',
      'group': 'n4_grammar_sou_verb',
      'question': 'この荷物は重くて、落ち＿＿です。',
      'choices': ['るそう', 'そう', 'たそう', 'ないそう'],
      'answer': 1,
      'explanation': '「〜そうです」กับกริยา ตัด ます แล้วต่อ そう\n落ちます → 落ちそうです = ดูเหมือนจะหล่น\nแสดงว่าเหตุการณ์กำลังจะเกิดขึ้น',
    },
    // --- Group: grammar_teshimau ---
    {
      'id': 'n4_06',
      'group': 'n4_grammar_teshimau',
      'question': '大切な写真を＿＿しまいました。',
      'choices': ['なくして', 'なくて', 'なくした', 'なくする'],
      'answer': 0,
      'explanation': '「〜てしまう」แปลว่า "〜จนหมด/ทำ〜จนเสร็จ" หรือแสดงความเสียใจ\nなくしてしまいました = ทำหายไปแล้ว（เสียใจ）\nใช้ て形＋しまう',
    },
    // --- Group: grammar_you_ni ---
    {
      'id': 'n4_07',
      'group': 'n4_grammar_you_ni',
      'question': '日本語が上手に話せる＿＿に、毎日練習しています。',
      'choices': ['ため', 'ように', 'ことに', 'はずに'],
      'answer': 1,
      'explanation': '「〜ように」แปลว่า "เพื่อให้〜ได้" ใช้กับ可能動詞\n話せるように = เพื่อให้พูดได้（เลยฝึกทุกวัน）\nใช้กับกริยาที่แสดงความสามารถหรือสภาพ',
    },
    // --- Group: grammar_noni ---
    {
      'id': 'n4_08',
      'group': 'n4_grammar_noni',
      'question': 'せっかく作った＿＿、誰も食べなかった。',
      'choices': ['から', 'のに', 'ので', 'けど'],
      'answer': 1,
      'explanation': '「〜のに」แปลว่า "ทั้งๆ ที่〜" แสดงความผิดหวัง/เสียดาย\nせっかく作ったのに = ทั้งๆ ที่ตั้งใจทำ（แต่ไม่มีใครกิน）\nสื่ออารมณ์เสียใจที่ผลลัพธ์ไม่เป็นไปตามที่คาดหวัง',
    },
    // --- Group: conditional_tara ---
    {
      'id': 'n4_09',
      'group': 'n4_conditional_tara',
      'question': '安かっ＿＿、買います。',
      'choices': ['たら', 'ても', 'ては', 'たり'],
      'answer': 0,
      'explanation': '「〜たら」แปลว่า "ถ้า〜" ใช้แสดงเงื่อนไข\n安かったら買います = ถ้าถูกก็จะซื้อ\nい形容詞: い → かったら',
    },
    // --- Group: grammar_hoshii ---
    {
      'id': 'n4_10',
      'group': 'n4_grammar_hoshii',
      'question': '子どもに野菜を＿＿ほしいです。',
      'choices': ['食べる', '食べて', '食べた', '食べ'],
      'answer': 1,
      'explanation': '「〜てほしい」แปลว่า "อยากให้（คนอื่น）〜"\n野菜を食べてほしい = อยากให้ลูกกินผัก\nใช้ て形＋ほしい เมื่อต้องการให้คนอื่นทำ',
    },
  ],
  'N3': [
    // --- Group: grammar_mama ---
    {
      'id': 'n3_01a',
      'group': 'n3_grammar_mama',
      'question': '彼は何も言わない＿＿、部屋を出て行った。',
      'choices': ['まま', 'ほど', 'ばかり', 'だけ'],
      'answer': 0,
      'explanation': '「〜まま」แปลว่า "ในสภาพที่〜" "โดยที่ยังคง〜"\n何も言わないまま = โดยไม่พูดอะไรเลย（ก็ออกไปจากห้อง）\nแสดงว่าสภาพเดิมไม่เปลี่ยนแปลง',
    },
    {
      'id': 'n3_01b',
      'group': 'n3_grammar_mama',
      'question': '電気をつけた＿＿寝てしまいました。',
      'choices': ['ばかり', 'まま', 'ほど', 'だけ'],
      'answer': 1,
      'explanation': '「〜まま」แปลว่า "ในสภาพที่〜ค้างไว้"\nつけたまま寝た = นอนโดยเปิดไฟทิ้งไว้\nสภาพ（เปิดไฟ）ไม่เปลี่ยนแปลง',
    },
    // --- Group: grammar_sugiru ---
    {
      'id': 'n3_02a',
      'group': 'n3_grammar_sugiru',
      'question': 'この問題は難し＿＿、誰にもわからなかった。',
      'choices': ['すぎて', 'すぎる', 'すぎた', 'すぎ'],
      'answer': 0,
      'explanation': '「〜すぎる」แปลว่า "〜เกินไป" ใช้รูป て เพื่อเชื่อมเหตุผล\n難しすぎて = ยากเกินไป（จนไม่มีใครเข้าใจ）\nคำคุณศัพท์ い → ตัด い + すぎて',
    },
    {
      'id': 'n3_02b',
      'group': 'n3_grammar_sugiru',
      'question': '昨日、食べ＿＿おなかが痛くなりました。',
      'choices': ['すぎた', 'すぎて', 'すぎ', 'すぎる'],
      'answer': 1,
      'explanation': '「〜すぎる」แปลว่า "〜เกินไป" ใช้รูป て เพื่อเชื่อมเหตุผล\n食べすぎて = กินมากเกินไป（จนปวดท้อง）\n動詞ます形 → ตัด ます + すぎて',
    },
    // --- Group: grammar_noni ---
    {
      'id': 'n3_03a',
      'group': 'n3_grammar_noni',
      'question': '努力した＿＿、結果が出なかった。',
      'choices': ['のに', 'ので', 'から', 'けど'],
      'answer': 0,
      'explanation': '「〜のに」แปลว่า "ทั้งๆ ที่〜" แสดงความขัดแย้ง/ผิดหวัง\n努力したのに = ทั้งๆ ที่พยายามแล้ว（แต่ไม่ได้ผลลัพธ์）\nต่างจาก ので/から（เพราะว่า）และ けど（แต่ว่า ไม่มีอารมณ์ผิดหวัง）',
    },
    {
      'id': 'n3_03b',
      'group': 'n3_grammar_noni',
      'question': '約束した＿＿、彼は来なかった。',
      'choices': ['ので', 'から', 'のに', 'けど'],
      'answer': 2,
      'explanation': '「〜のに」แปลว่า "ทั้งๆ ที่〜" แสดงความผิดหวัง\n約束したのに来なかった = ทั้งๆ ที่สัญญาแล้ว แต่เขาไม่มา\nสื่ออารมณ์เสียใจ/ไม่พอใจ',
    },
    // --- Group: grammar_dakedenaku ---
    {
      'id': 'n3_04a',
      'group': 'n3_grammar_dakedenaku',
      'question': '彼女は歌手として＿＿、女優としても有名です。',
      'choices': ['だけでなく', 'ばかりか', 'しか', 'どころか'],
      'answer': 0,
      'explanation': '「〜だけでなく」แปลว่า "ไม่เพียงแค่〜（แต่ยังอีกด้วย）"\n歌手としてだけでなく、女優としても = ไม่เพียงแค่ในฐานะนักร้อง แต่ยังเป็นนักแสดงที่มีชื่อเสียงด้วย\nしか ใช้กับปฏิเสธ, どころか แสดงระดับมากกว่า',
    },
    {
      'id': 'n3_04b',
      'group': 'n3_grammar_dakedenaku',
      'question': 'この店は料理＿＿、サービスもいいです。',
      'choices': ['しか', 'だけでなく', 'ばかり', 'どころか'],
      'answer': 1,
      'explanation': '「〜だけでなく」แปลว่า "ไม่เพียงแค่〜（แต่ยังอีกด้วย）"\n料理だけでなくサービスも = ไม่ใช่แค่อาหารอร่อย แต่บริการก็ดีด้วย',
    },
    // --- Group: grammar_nitaishite ---
    {
      'id': 'n3_05a',
      'group': 'n3_grammar_nitaishite',
      'question': '社長＿＿意見を言うのは勇気がいる。',
      'choices': ['に関して', 'にとって', 'に対して', 'について'],
      'answer': 2,
      'explanation': '「〜に対して」แปลว่า "ต่อ〜" ใช้แสดงเป้าหมายของการกระทำ\n社長に対して意見を言う = แสดงความเห็นต่อประธานบริษัท\nに関して/について = เกี่ยวกับ, にとって = สำหรับ',
    },
    {
      'id': 'n3_05b',
      'group': 'n3_grammar_nitaishite',
      'question': 'お客様＿＿丁寧に話してください。',
      'choices': ['について', 'にとって', 'に関して', 'に対して'],
      'answer': 3,
      'explanation': '「〜に対して」แปลว่า "ต่อ〜" ใช้แสดงเป้าหมายของการกระทำ\nお客様に対して丁寧に話す = พูดกับลูกค้าอย่างสุภาพ',
    },
    // --- Group: grammar_bakari ---
    {
      'id': 'n3_06',
      'group': 'n3_grammar_bakari',
      'question': '日本に来た＿＿で、まだ何もわかりません。',
      'choices': ['だけ', 'まま', 'ばかり', 'ほど'],
      'answer': 2,
      'explanation': '「〜たばかり」แปลว่า "เพิ่ง〜" แสดงว่าเพิ่งทำเสร็จไม่นาน\n来たばかり = เพิ่งมาถึง（ยังไม่รู้อะไรเลย）',
    },
    // --- Group: grammar_hodo ---
    {
      'id': 'n3_07',
      'group': 'n3_grammar_hodo',
      'question': '走れない＿＿疲れています。',
      'choices': ['まま', 'だけ', 'ほど', 'ばかり'],
      'answer': 2,
      'explanation': '「〜ほど」แปลว่า "ถึงขนาดที่〜" แสดงระดับ\n走れないほど疲れている = เหนื่อยจนวิ่งไม่ไหว\nแสดงว่าเหนื่อยมากถึงขนาดนั้น',
    },
    // --- Group: grammar_youni_naru ---
    {
      'id': 'n3_08',
      'group': 'n3_grammar_youni_naru',
      'question': '練習したら、泳げる＿＿なりました。',
      'choices': ['ことに', 'ように', 'ために', 'はずに'],
      'answer': 1,
      'explanation': '「〜ようになる」แปลว่า "กลายเป็น〜ได้" แสดงการเปลี่ยนแปลง\n泳げるようになった = ว่ายน้ำได้แล้ว（จากที่เคยว่ายไม่ได้）',
    },
    // --- Group: grammar_toiu ---
    {
      'id': 'n3_09',
      'group': 'n3_grammar_toiu',
      'question': '彼が会社を辞める＿＿話を聞きました。',
      'choices': ['ような', 'という', 'みたいな', 'らしい'],
      'answer': 1,
      'explanation': '「〜という」แปลว่า "ที่ว่า〜" ใช้อ้างอิงเนื้อหาที่ได้ยินมา\n辞めるという話 = เรื่องที่ว่าจะลาออก\nใช้อธิบายเนื้อหาของข่าว/เรื่อง',
    },
    // --- Group: grammar_tame ---
    {
      'id': 'n3_10',
      'group': 'n3_grammar_tame',
      'question': '台風の＿＿、電車が止まりました。',
      'choices': ['ように', 'ために', 'ことに', 'ほどに'],
      'answer': 1,
      'explanation': '「〜ために」（名詞＋の＋ために）แปลว่า "เพราะว่า〜"\n台風のために = เพราะพายุไต้ฝุ่น（รถไฟจึงหยุดวิ่ง）\nใช้แสดงเหตุผล/สาเหตุ',
    },
  ],
};
