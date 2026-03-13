import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/data_service.dart';
import '../../../shared/services/progress_service.dart';
import 'kanji_detail_screen.dart';

class KanjiScreen extends StatefulWidget {
  const KanjiScreen({super.key});

  @override
  State<KanjiScreen> createState() => _KanjiScreenState();
}

class _KanjiScreenState extends State<KanjiScreen> {
  final _dataService = DataService();
  String _selectedLevel = 'N5';
  List<Map<String, dynamic>> _kanjiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _dataService.loadKanji(_selectedLevel);
    setState(() {
      _kanjiList = data;
      _isLoading = false;
    });
  }

  void _changeLevel(String level) {
    _selectedLevel = level;
    _loadData();
  }

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
                  'คันจิ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _levelTab('N5'),
                    const SizedBox(width: 8),
                    _levelTab('N4'),
                    const SizedBox(width: 8),
                    _levelTab('N3'),
                    const Spacer(),
                    Text(
                      '${_kanjiList.length} ตัว',
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: _kanjiList.length,
                    itemBuilder: (context, index) {
                      final kanji = _kanjiList[index];
                      final character =
                          kanji['character']?.toString() ?? '';
                      final reading = kanji['reading']?.toString() ??
                          kanji['onyomi']?.toString() ??
                          '';
                      final meaning = kanji['meaning']?.toString() ?? '';
                      final colors = [
                        const Color(0xFF6C63FF),
                        const Color(0xFFFF6584),
                        const Color(0xFF00BFA6),
                        const Color(0xFFF59E0B),
                        const Color(0xFF3B82F6),
                        const Color(0xFFEC4899),
                        const Color(0xFF8B5CF6),
                        const Color(0xFF14B8A6),
                      ];
                      final color = colors[index % colors.length];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              final kanjiStr = kanji.map(
                                  (k, v) => MapEntry(k, v.toString()));
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => KanjiDetailScreen(
                                    kanji: kanjiStr,
                                    level: _selectedLevel,
                                    color: color,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: color
                                              .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Center(
                                          child: Text(
                                            character,
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w700,
                                              color: color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (ProgressService.isWordLearned(
                                          'kanji_${_selectedLevel}_$character'))
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppTheme.successColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    reading,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    meaning,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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

  Widget _levelTab(String label) {
    final active = _selectedLevel == label;
    return GestureDetector(
      onTap: () => _changeLevel(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xFF00BFA6), Color(0xFF4DD0B8)],
                )
              : null,
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
      ),
    );
  }
}
