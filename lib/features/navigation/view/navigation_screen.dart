import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatefulWidget {
  final Widget child;

  const NavigationScreen({super.key, required this.child});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

// TODO: Раскомментировать в фиче курсов
class _NavigationScreenState extends State<NavigationScreen> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    // if (location.startsWith('/home')) return 0;
    if (location.startsWith('/library')) return 0;
    // if (location.startsWith('/learning')) return 1;
    if (location.startsWith('/history')) return 1;
    // TEMPORARILY DISABLED: Profile tab
    // if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      // case 0:
      //   context.go('/home');
      //   break;
      case 0:
        context.go('/library');
        break;
      // case 1:
      //   context.go('/learning');
      //   break;
      case 1:
        context.go('/history');
        break;
      // TEMPORARILY DISABLED: Profile tab
      // case 3:
      //   context.go('/profile');
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => _onItemTapped(context, index),
        selectedIndex: selectedIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.library_books_rounded),
            icon: const Icon(Icons.library_books_outlined),
            label: S.of(context).navigationLibraryTitle,
          ),
          // NavigationDestination(
          //   selectedIcon: const Icon(Icons.science_rounded),
          //   icon: const Icon(Icons.science_rounded),
          //   label: S.of(context).navigationLearningTitle,
          // ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.history_rounded),
            icon: const Icon(Icons.history_outlined),
            label: S.of(context).navigationHistoryTitle,
          ),
        ],
      ),
      body: widget.child,
    );
  }
}
