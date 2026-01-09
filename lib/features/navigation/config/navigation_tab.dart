import 'package:codium/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NavigationTab {
  final String route;
  final String routePrefix;
  final NavigationDestination destination;

  const NavigationTab({
    required this.route,
    required this.routePrefix,
    required this.destination,
  });

  static List<NavigationTab> buildTabs(AppLocalizations s) {
    final tabs = <NavigationTab>[];

    tabs.add(
      NavigationTab(
        route: '/home',
        routePrefix: '/home',
        destination: NavigationDestination(
          selectedIcon: const Icon(Icons.home_rounded),
          icon: const Icon(Icons.home_outlined),
          label: s.navigationHomeTitle,
        ),
      ),
    );

    tabs.add(
      NavigationTab(
        route: '/learning',
        routePrefix: '/learning',
        destination: NavigationDestination(
          selectedIcon: const Icon(Icons.science_rounded),
          icon: const Icon(Icons.science_outlined),
          label: s.navigationLearningTitle,
        ),
      ),
    );

    tabs.add(
      NavigationTab(
        route: '/profile',
        routePrefix: '/profile',
        destination: NavigationDestination(
          selectedIcon: const Icon(Icons.person_rounded),
          icon: const Icon(Icons.person_outlined),
          label: s.navigationProfileTitle,
        ),
      ),
    );

    return tabs;
  }

  static int calculateSelectedIndex({
    required String location,
    required List<NavigationTab> tabs,
  }) {
    final index = tabs.indexWhere(
      (tab) => location.startsWith(tab.routePrefix),
    );
    return index == -1 ? 0 : index;
  }
}
