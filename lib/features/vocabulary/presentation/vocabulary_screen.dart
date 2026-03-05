import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'คำศัพท์',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _levelTab('N5', true),
                    const SizedBox(width: 8),
                    _levelTab('N4', false),
                    const SizedBox(width: 8),
                    _levelTab('N3', false),
                    const Spacer(),
                    Text(
                      '${_sampleVocab.length} คำ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _sampleVocab.length,
              itemBuilder: (context, index) {
                final vocab = _sampleVocab[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  vocab['word']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vocab['reading']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    vocab['meaning']!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.volume_up_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: active ? AppTheme.primaryGradient : null,
        color: active ? null : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: active ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

final _sampleVocab = [
  {'word': '食べる', 'reading': 'たべる', 'meaning': 'กิน (kin) - to eat'},
  {'word': '飲む', 'reading': 'のむ', 'meaning': 'ดื่ม (duem) - to drink'},
  {'word': '行く', 'reading': 'いく', 'meaning': 'ไป (pai) - to go'},
  {'word': '来る', 'reading': 'くる', 'meaning': 'มา (ma) - to come'},
  {'word': '見る', 'reading': 'みる', 'meaning': 'ดู (du) - to see'},
  {'word': '聞く', 'reading': 'きく', 'meaning': 'ฟัง (fang) - to listen'},
  {'word': '読む', 'reading': 'よむ', 'meaning': 'อ่าน (an) - to read'},
  {'word': '書く', 'reading': 'かく', 'meaning': 'เขียน (khian) - to write'},
  {'word': '話す', 'reading': 'はなす', 'meaning': 'พูด (phut) - to speak'},
  {'word': '買う', 'reading': 'かう', 'meaning': 'ซื้อ (sue) - to buy'},
];
