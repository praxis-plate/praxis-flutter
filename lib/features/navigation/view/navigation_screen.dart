import 'package:praxis/features/navigation/config/navigation_tab.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatelessWidget {
  final Widget child;

  const NavigationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;
    final selectedColor = theme.colorScheme.onSurface;

    final tabs = NavigationTab.buildTabs(s);

    final selectedIndex = NavigationTab.calculateSelectedIndex(
      location: location,
      tabs: tabs,
    );

    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: theme.cardColor,
          elevation: 0,
          indicatorColor: selectedColor.withValues(alpha: 0.08),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return theme.textTheme.labelSmall?.copyWith(
              fontSize: 11,
              color: selected
                  ? selectedColor
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 26,
              color: selected
                  ? selectedColor
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            );
          }),
        ),
        child: NavigationBar(
          height: 64,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => context.go(tabs[index].route),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: tabs.map((tab) => tab.destination).toList(),
        ),
      ),
      body: child,
    );
  }
}
