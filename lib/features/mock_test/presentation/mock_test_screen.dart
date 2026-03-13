import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/data_service.dart';
import '../../../shared/services/progress_service.dart';
import '../../../shared/widgets/combo_indicator.dart';
import '../../../shared/widgets/furigana_text.dart';
import '../../../shared/widgets/teacher_feedback_card.dart';

class MockTestScreen extends StatefulWidget {
  const MockTestScreen({super.key});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  final _dataService = DataService();
  String _selectedLevel = 'N5';
  int _currentQuestion = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _showResult = false;
  bool _testStarted = false;
  bool _isLoading = false;
  List<int?> _userAnswers = [];
  List<Map<String, dynamic>> _questions = [];

  // Cached question pool per level
  final Map<String, List<Map<String, dynamic>>> _questionPool = {};

  // Track used questions and incorrect concept groups across retries
  final Map<String, Set<String>> _usedQuestionIds = {};
  final Map<String, Set<String>> _incorrectGroups = {};

  // Combo tracking
  int _combo = 0;
  int _maxCombo = 0;
  int _comboBonus = 0;

  static const int _questionsPerTest = 5;

  Future<List<Map<String, dynamic>>> _getPool() async {
    if (!_questionPool.containsKey(_selectedLevel)) {
      _questionPool[_selectedLevel] =
          await _dataService.loadQuestions(_selectedLevel);
    }
    return _questionPool[_selectedLevel]!;
  }

  List<Map<String, dynamic>> _selectQuestions(List<Map<String, dynamic>> pool) {
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

  void _startTest() async {
    setState(() => _isLoading = true);
    final pool = await _getPool();
    final questions = _selectQuestions(pool);
    setState(() {
      _questions = questions;
      _testStarted = true;
      _isLoading = false;
      _currentQuestion = 0;
      _selectedAnswer = null;
      _score = 0;
      _showResult = false;
      _userAnswers = List.filled(questions.length, null);
      _combo = 0;
      _maxCombo = 0;
      _comboBonus = 0;
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
            const SizedBox(height: 12),

            // Combo indicator
            if (_combo >= 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Center(
                  child: ComboIndicator(
                    combo: _combo,
                    bonusXp: _combo % AppConstants.comboThreshold == 0
                        ? AppConstants.xpPerComboBonus
                        : 0,
                  ),
                ),
              ),

            const SizedBox(height: 4),

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
                  FuriganaText(
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
              final choices = question['choices'] as List;
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
                            child: FuriganaText(
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

                ],
              ),
            ),
          ),

          // Next button (fixed at bottom)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }

  void _nextQuestion() async {
    final question = _questions[_currentQuestion];
    _userAnswers[_currentQuestion] = _selectedAnswer;
    final isCorrect = _selectedAnswer == question['answer'];
    if (isCorrect) {
      _score++;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;
      // Combo bonus
      if (_combo > 0 && _combo % AppConstants.comboThreshold == 0) {
        _comboBonus += AppConstants.xpPerComboBonus;
      }
    } else {
      _combo = 0;
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
      await ProgressService.addXp(_score * AppConstants.xpPerCorrectAnswer + _comboBonus);
      await ProgressService.updateStreak();
      await ProgressService.updateBestCombo(_maxCombo);
      await ProgressService.completeDailyChallenge();
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
            const SizedBox(height: 16),

            // Teacher Feedback
            TeacherFeedbackCard(percentage: percentage),

            // Combo result
            if (_maxCombo >= 2) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bolt, color: Color(0xFFF59E0B), size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'ベストコンボ: $_maxCombo',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    if (_comboBonus > 0) ...[
                      const SizedBox(width: 12),
                      Text(
                        '+$_comboBonus XP ボーナス',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

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
              final choices = question['choices'] as List;
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
                    FuriganaText(
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
