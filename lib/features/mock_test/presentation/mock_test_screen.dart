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

  List<Map<String, dynamic>> get _questions => _questionsData[_selectedLevel]!;

  void _startTest() {
    setState(() {
      _testStarted = true;
      _currentQuestion = 0;
      _selectedAnswer = null;
      _score = 0;
      _showResult = false;
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: passed
                      ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)])
                      : const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (passed ? AppTheme.successColor : AppTheme.warningColor)
                          .withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  passed ? Icons.emoji_events : Icons.trending_up,
                  color: Colors.white,
                  size: 56,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'JLPT $_selectedLevel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ตอบถูก $_score/${_questions.length} ข้อ',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                passed ? 'เก่งมาก!' : 'พยายามอีกนิดนะ!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: passed ? AppTheme.successColor : AppTheme.warningColor,
                ),
              ),
              const SizedBox(height: 40),
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
            ],
          ),
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
    },
    {
      'question': '昨日、友だち＿＿映画を見ました。',
      'choices': ['を', 'に', 'と', 'で'],
      'answer': 2,
    },
    {
      'question': '「おおきい」の漢字はどれですか。',
      'choices': ['小さい', '大きい', '多きい', '太きい'],
      'answer': 1,
    },
    {
      'question': 'まいにち にほんご＿＿べんきょうします。',
      'choices': ['が', 'に', 'を', 'で'],
      'answer': 2,
    },
    {
      'question': '「がっこう」はどういう意味ですか。',
      'choices': ['โรงพยาบาล', 'โรงเรียน', 'ห้องสมุด', 'สถานี'],
      'answer': 1,
    },
  ],
  'N4': [
    {
      'question': '会議に＿＿前に、資料を読んでおいてください。',
      'choices': ['出る', '出た', '出て', '出よう'],
      'answer': 0,
    },
    {
      'question': 'このケーキはおいしい＿＿です。',
      'choices': ['よう', 'そう', 'らしい', 'みたい'],
      'answer': 1,
    },
    {
      'question': '日本に来て＿＿、毎日日本語を使っています。',
      'choices': ['から', 'まで', 'ので', 'のに'],
      'answer': 0,
    },
    {
      'question': '先生に＿＿て、漢字の読み方を教えてもらいました。',
      'choices': ['聞い', '聞き', '聞か', '聞く'],
      'answer': 0,
    },
    {
      'question': '電車が＿＿そうです。（もうすぐ来る）',
      'choices': ['来る', '来', '来い', '来た'],
      'answer': 1,
    },
  ],
  'N3': [
    {
      'question': '彼は何も言わない＿＿、部屋を出て行った。',
      'choices': ['まま', 'ほど', 'ばかり', 'だけ'],
      'answer': 0,
    },
    {
      'question': 'この問題は難し＿＿、誰にもわからなかった。',
      'choices': ['すぎて', 'すぎる', 'すぎた', 'すぎ'],
      'answer': 0,
    },
    {
      'question': '努力した＿＿、結果が出なかった。',
      'choices': ['のに', 'ので', 'から', 'けど'],
      'answer': 0,
    },
    {
      'question': '彼女は歌手として＿＿、女優としても有名です。',
      'choices': ['だけでなく', 'ばかりか', 'しか', 'どころか'],
      'answer': 0,
    },
    {
      'question': '社長＿＿意見を言うのは勇気がいる。',
      'choices': ['に関して', 'にとって', 'に対して', 'について'],
      'answer': 2,
    },
  ],
};
