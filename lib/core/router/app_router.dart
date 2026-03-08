import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/vocabulary/presentation/vocabulary_screen.dart';
import '../../features/grammar/presentation/grammar_screen.dart';
import '../../features/kanji/presentation/kanji_screen.dart';
import '../../features/mock_test/presentation/mock_test_screen.dart';
import '../../features/kanji_reading_test/presentation/kanji_reading_test_screen.dart';
import '../../features/gamification/presentation/profile_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/vocabulary',
          builder: (context, state) => const VocabularyScreen(),
        ),
        GoRoute(
          path: '/grammar',
          builder: (context, state) => const GrammarScreen(),
        ),
        GoRoute(
          path: '/kanji',
          builder: (context, state) => const KanjiScreen(),
        ),
        GoRoute(
          path: '/mock-test',
          builder: (context, state) => const MockTestScreen(),
        ),
        GoRoute(
          path: '/kanji-reading-test',
          builder: (context, state) => const KanjiReadingTestScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
