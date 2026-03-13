import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/teacher_character.dart';
import '../services/progress_service.dart';

class TeacherSelectionSheet extends StatefulWidget {
  final bool isFirstTime;

  const TeacherSelectionSheet({super.key, this.isFirstTime = false});

  static Future<void> show(BuildContext context, {bool isFirstTime = false}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: !isFirstTime,
      enableDrag: !isFirstTime,
      builder: (_) => TeacherSelectionSheet(isFirstTime: isFirstTime),
    );
  }

  @override
  State<TeacherSelectionSheet> createState() => _TeacherSelectionSheetState();
}

class _TeacherSelectionSheetState extends State<TeacherSelectionSheet> {
  String _selectedId = ProgressService.selectedTeacherId;

  @override
  void initState() {
    super.initState();
    if (_selectedId.isEmpty) {
      _selectedId = 'sakura'; // default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            widget.isFirstTime
                ? 'เลือกอาจารย์ของคุณ'
                : 'เปลี่ยนอาจารย์',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.isFirstTime
                ? 'อาจารย์จะให้คำแนะนำและกำลังใจในการเรียน'
                : 'เลือกอาจารย์ที่เหมาะกับสไตล์ของคุณ',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Teacher grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
            children: TeacherCharacter.allTeachers.map((teacher) {
              final isSelected = _selectedId == teacher.id;
              return _teacherCard(teacher, isSelected);
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Confirm button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                await ProgressService.setSelectedTeacherId(_selectedId);
                if (context.mounted) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'ยืนยัน',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _teacherCard(TeacherCharacter teacher, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedId = teacher.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? teacher.color.withValues(alpha: 0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? teacher.color : Colors.grey.shade200,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: teacher.color.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          teacher.color,
                          teacher.color.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: teacher.color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        teacher.kanjiAvatar,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
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
                    child: Icon(teacher.icon, size: 14, color: teacher.color),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Name
              Text(
                teacher.nameJp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? teacher.color : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),

              // Title
              Text(
                teacher.title,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // Personality
              Text(
                teacher.personality,
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Selected indicator
              if (isSelected) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: teacher.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '✓ เลือกแล้ว',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
