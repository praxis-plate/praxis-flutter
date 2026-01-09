import 'package:codium/features/navigation/config/navigation_tab.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatelessWidget {
  final Widget child;

  const NavigationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final location = GoRouterState.of(context).uri.path;

    final tabs = NavigationTab.buildTabs(s);

    final selectedIndex = NavigationTab.calculateSelectedIndex(
      location: location,
      tabs: tabs,
    );

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => context.go(tabs[index].route),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: tabs.map((tab) => tab.destination).toList(),
      ),
      body: child,
    );
  }
}
