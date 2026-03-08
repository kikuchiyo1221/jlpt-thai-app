import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/vocabulary') ||
        location.startsWith('/grammar') ||
        location.startsWith('/kanji')) {
      return 1;
    }
    if (location.startsWith('/mock-test') ||
        location.startsWith('/kanji-reading-test')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/vocabulary');
            case 2:
              context.go('/mock-test');
            case 3:
              context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'หน้าแรก', // Home
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'เรียนรู้', // Learn
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'สอบ', // Test
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'โปรไฟล์', // Profile
          ),
        ],
      ),
    );
  }
}
