import 'package:codium/features/learning/view/learning_screen.dart';
import 'package:codium/features/main/view/main_screen.dart';
import 'package:codium/features/profile/view/profile_screen.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.surfaceBright,
              width: 1,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: theme.navigationBarTheme,
          child: NavigationBar(
            onDestinationSelected: selectPage,
            elevation: 1,
            indicatorColor: theme.colorScheme.primaryContainer,
            selectedIndex: _currentPageIndex,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: const Icon(Icons.home_rounded),
                icon: const Icon(Icons.home_rounded),
                label: S.of(context).navigationMainTitle,
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.science_rounded),
                icon: const Icon(Icons.science_rounded),
                label: S.of(context).navigationLearningTitle,
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.settings_rounded),
                icon: const Icon(Icons.settings_rounded),
                // icon: const Badge(
                //   label: Text('2'),
                //   child: Icon(Icons.settings_rounded),
                // ),
                label: S.of(context).navigationProfileTitle,
              ),
            ],
          ),
        ),
      ),
      body: <Widget>[
        const MainScreen(),
        const LearningScreen(),
        const ProfileScreen(),
      ][_currentPageIndex],
    );
  }
}
