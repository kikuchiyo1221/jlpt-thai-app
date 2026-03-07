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

  List<Map<String, dynamic>> get _questions => _questionsData[_selectedLevel]!;

  void _startTest() {
    setState(() {
      _testStarted = true;
      _currentQuestion = 0;
      _selectedAnswer = null;
      _score = 0;
      _showResult = false;
      _userAnswers = List.filled(_questions.length, null);
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
            _testLevelCard('N5', 'พื้นฐาน', '${_questionsData['N5']!.length} ข้อ',
                const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)])),
            const SizedBox(height: 14),
            _testLevelCard('N4', 'ระดับกลาง-ต้น', '${_questionsData['N4']!.length} ข้อ',
                const LinearGradient(colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)])),
            const SizedBox(height: 14),
            _testLevelCard('N3', 'ระดับกลาง', '${_questionsData['N3']!.length} ข้อ',
                const LinearGradient(colors: [Color(0xFF00BFA6), Color(0xFF4DD0B8)])),
          ],
        ),
      ),
    );
  }

  Widget _testLevelCard(String level, String description, String questionCount, LinearGradient gradient) {
    final isSelected = _selectedLevel == level;
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
    if (_selectedAnswer == question['answer']) {
      _score++;
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

final _questionsData = {
  'N5': [
    {
      'question': '「たべる」の漢字はどれですか。',
      'choices': ['食べる', '飲べる', '読べる', '聞べる'],
      'answer': 0,
      'explanation': '「食べる」（たべる）แปลว่า กิน\n食 = อาหาร/กิน　飲 = ดื่ม　読 = อ่าน　聞 = ฟัง',
    },
    {
      'question': '昨日、友だち＿＿映画を見ました。',
      'choices': ['を', 'に', 'と', 'で'],
      'answer': 2,
      'explanation': '助詞「と」ใช้เมื่อทำกิจกรรมร่วมกับคนอื่น แปลว่า "กับ"\n友だちと映画を見ました = ดูหนังกับเพื่อน',
    },
    {
      'question': '「おおきい」の漢字はどれですか。',
      'choices': ['小さい', '大きい', '多きい', '太きい'],
      'answer': 1,
      'explanation': '「大きい」（おおきい）แปลว่า ใหญ่\n小さい = เล็ก　大 = ใหญ่　多 = มาก　太 = อ้วน/หนา',
    },
    {
      'question': 'まいにち にほんご＿＿べんきょうします。',
      'choices': ['が', 'に', 'を', 'で'],
      'answer': 2,
      'explanation': '助詞「を」ใช้แสดงกรรมของกริยา (สิ่งที่ถูกกระทำ)\nにほんごを勉強します = เรียนภาษาญี่ปุ่น',
    },
    {
      'question': '「がっこう」はどういう意味ですか。',
      'choices': ['โรงพยาบาล', 'โรงเรียน', 'ห้องสมุด', 'สถานี'],
      'answer': 1,
      'explanation': '「学校」（がっこう）แปลว่า โรงเรียน\nโรงพยาบาล = 病院　ห้องสมุด = 図書館　สถานี = 駅',
    },
  ],
  'N4': [
    {
      'question': '会議に＿＿前に、資料を読んでおいてください。',
      'choices': ['出る', '出た', '出て', '出よう'],
      'answer': 0,
      'explanation': '文法「〜前に」ต้องใช้กริยารูปพจนานุกรม (辞書形)\n出る前に = ก่อนออก（ไปประชุม）\nรูปนี้แปลว่า "ก่อนที่จะ〜 กรุณาอ่านเอกสารไว้ก่อน"',
    },
    {
      'question': 'このケーキはおいしい＿＿です。',
      'choices': ['よう', 'そう', 'らしい', 'みたい'],
      'answer': 1,
      'explanation': '「〜そうです」ใช้กับคำคุณศัพท์เมื่อดูจากรูปลักษณ์ แปลว่า "ดูเหมือนว่า〜"\nおいしそう = ดูอร่อย（ตัดい出してใช้そう）\nต่างจาก よう/みたい ที่ต้องต่อท้ายแบบอื่น',
    },
    {
      'question': '日本に来て＿＿、毎日日本語を使っています。',
      'choices': ['から', 'まで', 'ので', 'のに'],
      'answer': 0,
      'explanation': '「〜てから」แปลว่า "ตั้งแต่〜" ใช้แสดงจุดเริ่มต้นของการกระทำ\n日本に来てから = ตั้งแต่มาญี่ปุ่น（ก็ใช้ภาษาญี่ปุ่นทุกวัน）',
    },
    {
      'question': '先生に＿＿て、漢字の読み方を教えてもらいました。',
      'choices': ['聞い', '聞き', '聞か', '聞く'],
      'answer': 0,
      'explanation': '「聞く」เป็นกริยาหมู่ 1 (五段動詞) รูป て → 聞いて\nกริยาที่ลงท้าย く → いて（เช่น 書く→書いて）\n聞いて教えてもらう = ถามแล้วให้สอน',
    },
    {
      'question': '電車が＿＿そうです。（もうすぐ来る）',
      'choices': ['来る', '来', '来い', '来た'],
      'answer': 1,
      'explanation': '「〜そうです」（ดูเหมือนว่าจะ〜）ใช้กับกริยา ต้องตัด語尾ออก\n来る → 来（き）そうです = ดูเหมือนรถไฟจะมา\nต่างจาก来るそうです（ได้ยินมาว่า = 伝聞）',
    },
  ],
  'N3': [
    {
      'question': '彼は何も言わない＿＿、部屋を出て行った。',
      'choices': ['まま', 'ほど', 'ばかり', 'だけ'],
      'answer': 0,
      'explanation': '「〜まま」แปลว่า "ในสภาพที่〜" "โดยที่ยังคง〜"\n何も言わないまま = โดยไม่พูดอะไรเลย（ก็ออกไปจากห้อง）\nแสดงว่าสภาพเดิมไม่เปลี่ยนแปลง',
    },
    {
      'question': 'この問題は難し＿＿、誰にもわからなかった。',
      'choices': ['すぎて', 'すぎる', 'すぎた', 'すぎ'],
      'answer': 0,
      'explanation': '「〜すぎる」แปลว่า "〜เกินไป" ใช้รูป て เพื่อเชื่อมเหตุผล\n難しすぎて = ยากเกินไป（จนไม่มีใครเข้าใจ）\nคำคุณศัพท์ い → ตัด い + すぎて',
    },
    {
      'question': '努力した＿＿、結果が出なかった。',
      'choices': ['のに', 'ので', 'から', 'けど'],
      'answer': 0,
      'explanation': '「〜のに」แปลว่า "ทั้งๆ ที่〜" แสดงความขัดแย้ง/ผิดหวัง\n努力したのに = ทั้งๆ ที่พยายามแล้ว（แต่ไม่ได้ผลลัพธ์）\nต่างจาก ので/から（เพราะว่า）และ けど（แต่ว่า ไม่มีอารมณ์ผิดหวัง）',
    },
    {
      'question': '彼女は歌手として＿＿、女優としても有名です。',
      'choices': ['だけでなく', 'ばかりか', 'しか', 'どころか'],
      'answer': 0,
      'explanation': '「〜だけでなく」แปลว่า "ไม่เพียงแค่〜（แต่ยังอีกด้วย）"\n歌手としてだけでなく、女優としても = ไม่เพียงแค่ในฐานะนักร้อง แต่ยังเป็นนักแสดงที่มีชื่อเสียงด้วย\nしか ใช้กับปฏิเสธ, どころか แสดงระดับมากกว่า',
    },
    {
      'question': '社長＿＿意見を言うのは勇気がいる。',
      'choices': ['に関して', 'にとって', 'に対して', 'について'],
      'answer': 2,
      'explanation': '「〜に対して」แปลว่า "ต่อ〜" ใช้แสดงเป้าหมายของการกระทำ\n社長に対して意見を言う = แสดงความเห็นต่อประธานบริษัท\nに関して/について = เกี่ยวกับ, にとって = สำหรับ',
    },
  ],
};
