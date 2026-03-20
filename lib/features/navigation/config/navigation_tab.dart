import 'package:codium/core/router/router_exports.dart';
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
        route: RouteConstants.home,
        routePrefix: RouteConstants.home,
        destination: NavigationDestination(
          selectedIcon: const Icon(Icons.grid_view_rounded),
          icon: const Icon(Icons.grid_view_rounded),
          label: s.navigationHomeTitle,
        ),
      ),
    );

    tabs.add(
      NavigationTab(
        route: RouteConstants.learning,
        routePrefix: RouteConstants.learning,
        destination: NavigationDestination(
          selectedIcon: const Icon(Icons.play_circle_outline_rounded),
          icon: const Icon(Icons.play_circle_outline_rounded),
          label: s.navigationLearningTitle,
        ),
      ),
    );

    tabs.add(
      NavigationTab(
        route: RouteConstants.profile,
        routePrefix: RouteConstants.profile,
        destination: NavigationDestination(
          selectedIcon: const Icon(Icons.person_outline_rounded),
          icon: const Icon(Icons.person_outline_rounded),
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
