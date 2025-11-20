import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatefulWidget {
  final Widget child;

  const NavigationScreen({super.key, required this.child});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/learning')) return 2;
    if (location.startsWith('/history')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/library');
        break;
      case 2:
        context.go('/learning');
        break;
      case 3:
        context.go('/history');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.surfaceBright, width: 1),
          ),
        ),
        child: NavigationBarTheme(
          data: theme.navigationBarTheme,
          child: NavigationBar(
            onDestinationSelected: (index) => _onItemTapped(context, index),
            elevation: 1,
            indicatorColor: theme.colorScheme.primaryContainer,
            selectedIndex: selectedIndex,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: const Icon(Icons.home_rounded),
                icon: const Icon(Icons.home_rounded),
                label: S.of(context).navigationMainTitle,
              ),
              const NavigationDestination(
                selectedIcon: Icon(Icons.library_books_rounded),
                icon: Icon(Icons.library_books_outlined),
                label: 'Library',
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.science_rounded),
                icon: const Icon(Icons.science_rounded),
                label: S.of(context).navigationLearningTitle,
              ),
              const NavigationDestination(
                selectedIcon: Icon(Icons.history_rounded),
                icon: Icon(Icons.history_outlined),
                label: 'History',
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.settings_rounded),
                icon: const Icon(Icons.settings_rounded),
                label: S.of(context).navigationProfileTitle,
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }
}
