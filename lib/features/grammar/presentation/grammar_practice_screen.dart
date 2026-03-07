import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/progress_service.dart';

class GrammarPracticeScreen extends StatefulWidget {
  final String level;
  final List<Map<String, String>> grammarList;

  const GrammarPracticeScreen({
    super.key,
    required this.level,
    required this.grammarList,
  });

  @override
  State<GrammarPracticeScreen> createState() => _GrammarPracticeScreenState();
}

class _GrammarPracticeScreenState extends State<GrammarPracticeScreen> {
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;
  late List<_GrammarQuiz> _quizzes;

  @override
  void initState() {
    super.initState();
    _quizzes = _generateQuizzes();
  }

  List<_GrammarQuiz> _generateQuizzes() {
    final rng = Random();
    return widget.grammarList.map((g) {
      // Generate a quiz: match pattern to meaning
      final correctMeaning = g['meaning']!;
      final otherMeanings = widget.grammarList
          .where((o) => o['pattern'] != g['pattern'])
          .map((o) => o['meaning']!)
          .toList()
        ..shuffle(rng);

      final choices = <String>[correctMeaning];
      for (final m in otherMeanings) {
        if (choices.length >= 4) break;
        if (!choices.contains(m)) choices.add(m);
      }
      // If not enough choices, add placeholders
      while (choices.length < 4) {
        choices.add('ไม่มีคำตอบที่ถูกต้อง');
      }
      choices.shuffle(rng);

      return _GrammarQuiz(
        pattern: g['pattern']!,
        example: g['example']!,
        translation: g['translation']!,
        correctMeaning: correctMeaning,
        choices: choices,
        correctIndex: choices.indexOf(correctMeaning),
      );
    }).toList();
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _quizzes[_currentIndex].correctIndex) {
        _correctCount++;
      }
    });
  }

  void _next() async {
    if (_currentIndex < _quizzes.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      // Finished
      await ProgressService.recordQuizResult(_correctCount, _quizzes.length);
      await ProgressService.addXp(_correctCount * AppConstants.xpPerCorrectAnswer);
      await ProgressService.updateStreak();
      if (mounted) _showResult();
    }
  }

  void _showResult() {
    final pct = (_correctCount / _quizzes.length * 100).round();
    final passed = pct >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: passed
                    ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)])
                    : const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                passed ? Icons.emoji_events : Icons.trending_up,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              passed ? 'เก่งมาก!' : 'พยายามอีกนิด!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ตอบถูก $_correctCount / ${_quizzes.length} ข้อ',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              '+${_correctCount * AppConstants.xpPerCorrectAnswer} XP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'กลับ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quizzes[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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
                    'ฝึกไวยากรณ์ ${widget.level}',
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
                      color: const Color(0xFFFF6584).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${_quizzes.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF6584),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _quizzes.length,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFFF6584).withValues(alpha: 0.12),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6584)),
                ),
              ),
              const SizedBox(height: 24),

              // Question: pattern + example
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6584).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'รูปแบบนี้แปลว่าอะไร?',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      quiz.pattern,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.example,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            quiz.translation,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Choices
              ...List.generate(quiz.choices.length, (i) {
                final isSelected = _selectedAnswer == i;
                final isCorrect = i == quiz.correctIndex;

                Color bgColor = Colors.white;
                Color borderColor = Colors.grey.shade200;
                Color textColor = AppTheme.textPrimary;

                if (_answered) {
                  if (isCorrect) {
                    bgColor = AppTheme.successColor.withValues(alpha: 0.06);
                    borderColor = AppTheme.successColor;
                    textColor = AppTheme.successColor;
                  } else if (isSelected && !isCorrect) {
                    bgColor = AppTheme.errorColor.withValues(alpha: 0.06);
                    borderColor = AppTheme.errorColor;
                    textColor = AppTheme.errorColor;
                  }
                } else if (isSelected) {
                  bgColor = AppTheme.primaryColor.withValues(alpha: 0.06);
                  borderColor = AppTheme.primaryColor;
                  textColor = AppTheme.primaryColor;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _selectAnswer(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: (isSelected || (_answered && isCorrect)) ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _answered && isCorrect
                                    ? AppTheme.successColor
                                    : (_answered && isSelected && !isCorrect)
                                        ? AppTheme.errorColor
                                        : isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: _answered
                                    ? Icon(
                                        isCorrect ? Icons.check : (isSelected ? Icons.close : null),
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : Text(
                                        String.fromCharCode(65 + i),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                quiz.choices[i],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: (isSelected || (_answered && isCorrect))
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: textColor,
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
              if (_answered)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      _currentIndex < _quizzes.length - 1 ? 'ถัดไป' : 'ดูผลลัพธ์',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _GrammarQuiz {
  final String pattern;
  final String example;
  final String translation;
  final String correctMeaning;
  final List<String> choices;
  final int correctIndex;

  _GrammarQuiz({
    required this.pattern,
    required this.example,
    required this.translation,
    required this.correctMeaning,
    required this.choices,
    required this.correctIndex,
  });
}
