import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ComboIndicator extends StatelessWidget {
  final int combo;
  final int bonusXp;

  const ComboIndicator({
    super.key,
    required this.combo,
    this.bonusXp = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (combo < 2) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: combo >= 5
              ? [const Color(0xFFFF6584), const Color(0xFFFF8FA3)]
              : combo >= 3
                  ? [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]
                  : [AppTheme.primaryColor, const Color(0xFF9D97FF)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: (combo >= 5
                    ? const Color(0xFFFF6584)
                    : combo >= 3
                        ? const Color(0xFFF59E0B)
                        : AppTheme.primaryColor)
                .withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            combo >= 5 ? Icons.local_fire_department : Icons.bolt,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '$combo Combo！',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          if (bonusXp > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$bonusXp XP',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
