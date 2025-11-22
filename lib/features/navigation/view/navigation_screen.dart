import 'package:codium/core/config/feature_flags.dart';
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
  int _selectedIndex = 0;
  String _lastLocation = '';

  int _calculateSelectedIndex(String location) {
    if (FeatureFlags.enableCourses && location.startsWith('/home')) return 0;
    if (location.startsWith('/library')) {
      return FeatureFlags.enableCourses ? 1 : 0;
    }
    if (FeatureFlags.enableCourses && location.startsWith('/learning')) {
      return 2;
    }
    if (location.startsWith('/history')) {
      return FeatureFlags.enableCourses ? 3 : 1;
    }
    if (FeatureFlags.enableProfile && location.startsWith('/profile')) {
      return FeatureFlags.enableCourses ? 4 : 2;
    }
    return 0;
  }

  void _updateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location != _lastLocation) {
      _lastLocation = location;
      final newIndex = _calculateSelectedIndex(location);
      if (newIndex != _selectedIndex) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedIndex = newIndex;
            });
          }
        });
      }
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    if (FeatureFlags.enableCourses) {
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
          if (FeatureFlags.enableProfile) {
            context.go('/profile');
          }
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.go('/library');
          break;
        case 1:
          context.go('/history');
          break;
        case 2:
          if (FeatureFlags.enableProfile) {
            context.go('/profile');
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    _updateSelectedIndex(context);

    final destinations = <NavigationDestination>[
      if (FeatureFlags.enableCourses)
        NavigationDestination(
          selectedIcon: const Icon(Icons.home_rounded),
          icon: const Icon(Icons.home_outlined),
          label: s.navigationHomeTitle,
        ),
      NavigationDestination(
        selectedIcon: const Icon(Icons.library_books_rounded),
        icon: const Icon(Icons.library_books_outlined),
        label: s.navigationLibraryTitle,
      ),
      if (FeatureFlags.enableCourses)
        NavigationDestination(
          selectedIcon: const Icon(Icons.science_rounded),
          icon: const Icon(Icons.science_rounded),
          label: s.navigationLearningTitle,
        ),
      NavigationDestination(
        selectedIcon: const Icon(Icons.history_rounded),
        icon: const Icon(Icons.history_outlined),
        label: s.navigationHistoryTitle,
      ),
      if (FeatureFlags.enableProfile)
        NavigationDestination(
          selectedIcon: const Icon(Icons.person_rounded),
          icon: const Icon(Icons.person_outlined),
          label: s.navigationProfileTitle,
        ),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => _onItemTapped(context, index),
        selectedIndex: _selectedIndex,
        destinations: destinations,
      ),
      body: widget.child,
    );
  }
}
