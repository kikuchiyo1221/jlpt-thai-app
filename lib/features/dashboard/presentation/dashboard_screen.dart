import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/teacher_character.dart';
import '../../../shared/services/progress_service.dart';
import '../../../shared/widgets/teacher_selection_sheet.dart';
import '../../search/presentation/search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ProgressService.hasSelectedTeacher) {
        TeacherSelectionSheet.show(context, isFirstTime: true).then((_) {
          if (mounted) setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasTeacher = ProgressService.hasSelectedTeacher;
    final teacher = hasTeacher
        ? TeacherCharacter.getById(ProgressService.selectedTeacherId)
        : null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with teacher greeting
            Row(
              children: [
                if (teacher != null) ...[
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              teacher.color,
                              teacher.color.withValues(alpha: 0.7),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            teacher.kanjiAvatar,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(teacher.icon, size: 13, color: teacher.color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher?.greeting ?? 'สวัสดี!',
                        style: TextStyle(
                          fontSize: teacher != null ? 16 : 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            ProgressService.playerTitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: teacher?.color ?? AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            ' (${ProgressService.playerTitleJp})',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Daily Challenge Card
            _dailyChallengeCard(teacher),
            const SizedBox(height: 16),

            // Stats Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(Icons.local_fire_department, '${ProgressService.streak} วัน', 'สตรีค', const Color(0xFFFFD700)),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _statItem(Icons.star_rounded, '${ProgressService.totalXp} XP', 'ประสบการณ์', const Color(0xFFFFD700)),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _statItem(Icons.emoji_events, 'Lv.${ProgressService.level}', 'ระดับ', const Color(0xFFFFD700)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // XP Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'เลเวลถัดไป',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            '${ProgressService.totalXp % ProgressService.xpToNextLevel} / ${ProgressService.xpToNextLevel} XP',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: ProgressService.xpProgress,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Level Selection
            Text(
              'เลือกระดับ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _levelCard('N5', AppTheme.n5Color, 0.0),
                const SizedBox(width: 12),
                _levelCard('N4', AppTheme.n4Color, 0.0),
                const SizedBox(width: 12),
                _levelCard('N3', AppTheme.n3Color, 0.0),
              ],
            ),
            const SizedBox(height: 28),

            // Study Menu
            Text(
              'เริ่มเรียน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _menuCard(
              context,
              icon: Icons.translate,
              title: 'คำศัพท์',
              subtitle: 'เรียนรู้คำศัพท์ใหม่',
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
              ),
              onTap: () => context.go('/vocabulary'),
            ),
            _menuCard(
              context,
              icon: Icons.auto_stories,
              title: 'ไวยากรณ์',
              subtitle: 'เรียนรู้รูปแบบไวยากรณ์',
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)],
              ),
              onTap: () => context.go('/grammar'),
            ),
            _menuCard(
              context,
              icon: Icons.brush_outlined,
              title: 'คันจิ',
              subtitle: 'เรียนรู้ตัวอักษรคันจิ',
              gradient: const LinearGradient(
                colors: [Color(0xFF00BFA6), Color(0xFF4DD0B8)],
              ),
              onTap: () => context.go('/kanji'),
            ),
            _menuCard(
              context,
              icon: Icons.spellcheck,
              title: 'ทดสอบการอ่านคันจิ',
              subtitle: 'ทดสอบการอ่านตัวคันจิ',
              gradient: const LinearGradient(
                colors: [Color(0xFFE67E22), Color(0xFFF39C12)],
              ),
              onTap: () => context.go('/kanji-reading-test'),
            ),
            _menuCard(
              context,
              icon: Icons.quiz_outlined,
              title: 'สอบจำลอง',
              subtitle: 'ทดสอบความรู้ของคุณ',
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              ),
              onTap: () => context.go('/mock-test'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyChallengeCard(TeacherCharacter? teacher) {
    final completed = ProgressService.isDailyChallengeCompleted;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: completed
            ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)])
            : LinearGradient(colors: [
                const Color(0xFFF59E0B),
                const Color(0xFFFBBF24),
              ]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (completed ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                .withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              completed ? Icons.check_circle : Icons.flag,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ชาเลนจ์ประจำวัน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  completed
                      ? 'สำเร็จแล้ว！ +30 XP'
                      : 'ทำแบบทดสอบวันนี้ 1 ครั้ง → +30 XP',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _levelCard(String level, Color color, double progress) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              level,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
