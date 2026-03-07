import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/data/vocabulary_data.dart';
import '../../../shared/data/kanji_data.dart';
import '../../../shared/data/grammar_data.dart';
import '../../vocabulary/presentation/vocabulary_detail_screen.dart';
import '../../kanji/presentation/kanji_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String _filter = 'all'; // all, vocab, kanji, grammar

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_SearchResult> _search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    final results = <_SearchResult>[];

    if (_filter == 'all' || _filter == 'vocab') {
      for (final level in vocabularyData.keys) {
        for (final v in vocabularyData[level]!) {
          if (v['word']!.contains(q) ||
              v['reading']!.contains(q) ||
              v['meaning']!.toLowerCase().contains(q)) {
            results.add(_SearchResult(
              type: 'vocab',
              level: level,
              title: v['word']!,
              subtitle: v['reading']!,
              detail: v['meaning']!,
              data: v,
            ));
          }
        }
      }
    }

    if (_filter == 'all' || _filter == 'kanji') {
      for (final level in kanjiData.keys) {
        for (final k in kanjiData[level]!) {
          if (k['character']!.contains(q) ||
              k['reading']!.contains(q) ||
              k['meaning']!.toLowerCase().contains(q)) {
            results.add(_SearchResult(
              type: 'kanji',
              level: level,
              title: k['character']!,
              subtitle: k['reading']!,
              detail: k['meaning']!,
              data: k,
            ));
          }
        }
      }
    }

    if (_filter == 'all' || _filter == 'grammar') {
      for (final level in grammarData.keys) {
        for (final g in grammarData[level]!) {
          if (g['pattern']!.contains(q) ||
              g['meaning']!.toLowerCase().contains(q) ||
              g['example']!.contains(q)) {
            results.add(_SearchResult(
              type: 'grammar',
              level: level,
              title: g['pattern']!,
              subtitle: g['meaning']!,
              detail: g['example']!,
              data: g,
            ));
          }
        }
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final results = _search(_query);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        'ค้นหา',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  Container(
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
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'พิมพ์คำญี่ปุ่น, ไทย หรือ อังกฤษ...',
                        hintStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                        prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: AppTheme.textSecondary, size: 20),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter chips
                  Row(
                    children: [
                      _filterChip('all', 'ทั้งหมด'),
                      const SizedBox(width: 8),
                      _filterChip('vocab', 'คำศัพท์'),
                      const SizedBox(width: 8),
                      _filterChip('kanji', 'คันจิ'),
                      const SizedBox(width: 8),
                      _filterChip('grammar', 'ไวยากรณ์'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Results
            Expanded(
              child: _query.isEmpty
                  ? _buildEmptyState()
                  : results.isEmpty
                      ? _buildNoResults()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final r = results[index];
                            return _buildResultCard(r);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final active = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          gradient: active ? AppTheme.primaryGradient : null,
          color: active ? null : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: active ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'ค้นหาคำศัพท์ คันจิ หรือไวยากรณ์',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'รองรับภาษาญี่ปุ่น ไทย และอังกฤษ',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'ไม่พบผลลัพธ์',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'ลองค้นหาด้วยคำอื่น',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(_SearchResult r) {
    final typeConfig = _typeConfigs[r.type]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onResultTap(r),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: typeConfig.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      r.title.length <= 2 ? r.title : r.title.substring(0, 2),
                      style: TextStyle(
                        fontSize: r.title.length <= 2 ? 24 : 18,
                        fontWeight: FontWeight.w700,
                        color: typeConfig.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            r.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeConfig.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              r.level,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: typeConfig.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              typeConfig.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        r.subtitle,
                        style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                      Text(
                        r.detail,
                        style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade300),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onResultTap(_SearchResult r) {
    switch (r.type) {
      case 'vocab':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => VocabularyDetailScreen(
            vocab: r.data,
            level: r.level,
          ),
        ));
      case 'kanji':
        final colors = [
          const Color(0xFF6C63FF),
          const Color(0xFFFF6584),
          const Color(0xFF00BFA6),
          const Color(0xFFF59E0B),
        ];
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => KanjiDetailScreen(
            kanji: r.data,
            level: r.level,
            color: colors[r.level.hashCode % colors.length],
          ),
        ));
      case 'grammar':
        // Just show the grammar info in a dialog for now
        final g = r.data;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6584), Color(0xFFFF8FA3)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(r.level,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Text(g['pattern']!,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                Text(g['meaning']!, style: TextStyle(fontSize: 15, color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g['example']!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(g['translation']!, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('ปิด'),
              ),
            ],
          ),
        );
    }
  }
}

class _SearchResult {
  final String type; // vocab, kanji, grammar
  final String level;
  final String title;
  final String subtitle;
  final String detail;
  final Map<String, String> data;

  _SearchResult({
    required this.type,
    required this.level,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.data,
  });
}

class _TypeConfig {
  final String label;
  final Color color;
  _TypeConfig(this.label, this.color);
}

final _typeConfigs = {
  'vocab': _TypeConfig('คำศัพท์', const Color(0xFF6C63FF)),
  'kanji': _TypeConfig('คันจิ', const Color(0xFF00BFA6)),
  'grammar': _TypeConfig('ไวยากรณ์', const Color(0xFFFF6584)),
};
