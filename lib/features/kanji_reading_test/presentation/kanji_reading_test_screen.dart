import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/data_service.dart';
import '../../../shared/services/progress_service.dart';
import '../../../shared/widgets/combo_indicator.dart';
import '../../../shared/widgets/teacher_feedback_card.dart';

class KanjiReadingTestScreen extends StatefulWidget {
  const KanjiReadingTestScreen({super.key});

  @override
  State<KanjiReadingTestScreen> createState() => _KanjiReadingTestScreenState();
}

class _KanjiReadingTestScreenState extends State<KanjiReadingTestScreen> {
  final _dataService = DataService();
  String _selectedLevel = 'N5';
  int _currentQuestion = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _showResult = false;
  bool _testStarted = false;
  bool _isLoading = false;
  List<int?> _userAnswers = [];
  List<_KanjiQuestion> _questions = [];

  // Cached kanji pool and counts per level
  final Map<String, List<Map<String, dynamic>>> _kanjiPool = {};
  final Map<String, int> _kanjiCounts = {};

  // Track used kanji indices and incorrect ones for adaptive retry
  final Map<String, Set<int>> _usedIndices = {};
  final Map<String, Set<int>> _incorrectIndices = {};

  // Combo tracking
  int _combo = 0;
  int _maxCombo = 0;
  int _comboBonus = 0;

  static const int _questionsPerTest = 5;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    for (final level in ['N5', 'N4', 'N3']) {
      final data = await _dataService.loadKanji(level);
      _kanjiPool[level] = data;
      _kanjiCounts[level] = data.length;
    }
    if (mounted) setState(() {});
  }

  List<_KanjiQuestion> _generateQuestions(List<Map<String, dynamic>> pool) {
    final used = _usedIndices[_selectedLevel] ??= {};
    final incorrect = _incorrectIndices[_selectedLevel] ??= {};

    final selectedIndices = <int>[];

    // 1) Prioritize previously incorrect kanji
    for (final idx in incorrect.toList()) {
      if (selectedIndices.length >= _questionsPerTest) break;
      if (!used.contains(idx)) {
        selectedIndices.add(idx);
      }
    }

    // 2) Fill with unseen kanji
    final unseen = List.generate(pool.length, (i) => i)
        .where((i) => !used.contains(i) && !selectedIndices.contains(i))
        .toList();
    unseen.shuffle();
    for (final idx in unseen) {
      if (selectedIndices.length >= _questionsPerTest) break;
      selectedIndices.add(idx);
    }

    // 3) If pool exhausted, reset tracking
    if (selectedIndices.length < _questionsPerTest) {
      used.clear();
      incorrect.clear();
      final all = List.generate(pool.length, (i) => i)
          .where((i) => !selectedIndices.contains(i))
          .toList();
      all.shuffle();
      for (final idx in all) {
        if (selectedIndices.length >= _questionsPerTest) break;
        selectedIndices.add(idx);
      }
    }

    // Mark as used
    used.addAll(selectedIndices);

    // Generate questions
    final questions = <_KanjiQuestion>[];
    for (final idx in selectedIndices) {
      final kanji = pool[idx];
      final correctReading = kanji['reading']?.toString() ?? kanji['onyomi']?.toString() ?? '';

      // Pick 3 wrong readings from other kanji
      final otherReadings = pool
          .asMap()
          .entries
          .where((e) => e.key != idx)
          .map((e) => e.value['reading']?.toString() ?? e.value['onyomi']?.toString() ?? '')
          .toList();
      otherReadings.shuffle();
      final wrongReadings = otherReadings.take(3).toList();

      // Build choices and shuffle
      final choices = [correctReading, ...wrongReadings];
      final correctIndex = 0; // before shuffle
      // Create index mapping for shuffle
      final indices = List.generate(choices.length, (i) => i);
      indices.shuffle();
      final shuffledChoices = indices.map((i) => choices[i]).toList();
      final answer = indices.indexOf(correctIndex);

      questions.add(_KanjiQuestion(
        kanjiIndex: idx,
        character: kanji['character']?.toString() ?? '',
        correctReading: correctReading,
        meaning: kanji['meaning']?.toString() ?? '',
        choices: shuffledChoices,
        answer: answer,
      ));
    }

    questions.shuffle();
    return questions;
  }

  void _startTest() async {
    setState(() => _isLoading = true);
    if (!_kanjiPool.containsKey(_selectedLevel)) {
      final data = await _dataService.loadKanji(_selectedLevel);
      _kanjiPool[_selectedLevel] = data;
      _kanjiCounts[_selectedLevel] = data.length;
    }
    final pool = _kanjiPool[_selectedLevel]!;
    final questions = _generateQuestions(pool);
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
              'ทดสอบการอ่านคันจิ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เลือกระดับที่ต้องการทดสอบ',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            _testLevelCard(
              'N5',
              'พื้นฐาน',
              '${_kanjiCounts['N5'] ?? '...'} ตัวอักษร',
              const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)]),
            ),
            const SizedBox(height: 14),
            _testLevelCard(
              'N4',
              'ระดับกลาง-ต้น',
              '${_kanjiCounts['N4'] ?? '...'} ตัวอักษร',
              const LinearGradient(colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)]),
            ),
            const SizedBox(height: 14),
            _testLevelCard(
              'N3',
              'ระดับกลาง',
              '${_kanjiCounts['N3'] ?? '...'} ตัวอักษร',
              const LinearGradient(colors: [Color(0xFF00BFA6), Color(0xFF4DD0B8)]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testLevelCard(
      String level, String description, String kanjiCount, LinearGradient gradient) {
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
                    kanjiCount,
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
                  'คันจิ $_selectedLevel',
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

            // Question Card with large kanji
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Column(
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
                  const SizedBox(height: 16),
                  Text(
                    question.character,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'この漢字の読み方はどれですか。',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Choices
            ...List.generate(question.choices.length, (i) {
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
                              question.choices[i],
                              style: TextStyle(
                                fontSize: 16,
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
                  _currentQuestion < _questions.length - 1 ? 'ถัดไป' : 'ดูผลลัพธ์',
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
    final isCorrect = _selectedAnswer == question.answer;

    if (isCorrect) {
      _score++;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;
      if (_combo > 0 && _combo % AppConstants.comboThreshold == 0) {
        _comboBonus += AppConstants.xpPerComboBonus;
      }
      _incorrectIndices[_selectedLevel]?.remove(question.kanjiIndex);
    } else {
      _combo = 0;
      (_incorrectIndices[_selectedLevel] ??= {}).add(question.kanjiIndex);
    }

    if (_currentQuestion >= _questions.length - 1) {
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
              final isCorrect = userAnswer == question.answer;

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
                    // Question header
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
                        const Spacer(),
                        // Show the kanji character
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              question.character,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                '${String.fromCharCode(65 + userAnswer)}. ${question.choices[userAnswer]}',
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
                              '${String.fromCharCode(65 + question.answer)}. ${question.choices[question.answer]}',
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

                    // Explanation with meaning
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
                              '「${question.character}」の読み方: ${question.correctReading}\nความหมาย: ${question.meaning}',
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

class _KanjiQuestion {
  final int kanjiIndex;
  final String character;
  final String correctReading;
  final String meaning;
  final List<String> choices;
  final int answer;

  _KanjiQuestion({
    required this.kanjiIndex,
    required this.character,
    required this.correctReading,
    required this.meaning,
    required this.choices,
    required this.answer,
  });
}
