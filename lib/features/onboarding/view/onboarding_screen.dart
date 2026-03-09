import 'package:codium/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<OnboardingBloc>()..add(CheckOnboardingStatusEvent()),
      child: const _OnboardingScreenContent(),
    );
  }
}

class _OnboardingScreenContent extends StatelessWidget {
  const _OnboardingScreenContent();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleteState) {
          context.go('/navigation');
        }
      },
      child: Scaffold(
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return switch (state) {
              OnboardingPage1State() => const _OnboardingPage1(),
              OnboardingPage2State() => const _OnboardingPage2(),
              OnboardingPage3State() => const _OnboardingPage3(),
              OnboardingLanguageSelectionState() =>
                const _LanguageSelectionPage(),
              OnboardingCompleteState() => const Center(
                child: CircularProgressIndicator(),
              ),
              OnboardingInitialState() => const Center(
                child: CircularProgressIndicator(),
              ),
              OnboardingErrorState() => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message ?? s.onboardingErrorUnknown,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}

class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1();

  @override
  Widget build(BuildContext context) {
    return _OnboardingStepPage(
      icon: Icons.auto_awesome,
      title: S.of(context).onboardingTitle1,
      description: S.of(context).onboardingDescription1,
      currentPage: 0,
      onNext: () => context.read<OnboardingBloc>().add(NextPageEvent()),
    );
  }
}

class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2();

  @override
  Widget build(BuildContext context) {
    return _OnboardingStepPage(
      icon: Icons.menu_book,
      title: S.of(context).onboardingTitle2,
      description: S.of(context).onboardingDescription2,
      currentPage: 1,
      onNext: () => context.read<OnboardingBloc>().add(NextPageEvent()),
    );
  }
}

class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3();

  @override
  Widget build(BuildContext context) {
    return _OnboardingStepPage(
      icon: Icons.bookmark,
      title: S.of(context).onboardingTitle3,
      description: S.of(context).onboardingDescription3,
      currentPage: 2,
      onNext: () => context.read<OnboardingBloc>().add(NextPageEvent()),
    );
  }
}

class _OnboardingStepPage extends StatelessWidget {
  const _OnboardingStepPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.onNext,
  });

  final IconData icon;
  final String title;
  final String description;
  final int currentPage;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(CompleteOnboardingEvent());
                },
                child: Text(s.onboardingSkip),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 120, color: theme.colorScheme.primary),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _PageIndicator(currentPage: currentPage),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onNext,
                child: Text(s.onboardingNext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSelectionPage extends StatelessWidget {
  const _LanguageSelectionPage();

  static const List<Map<String, String>> languages = [
    {'name': 'Python', 'icon': '🐍'},
    {'name': 'JavaScript', 'icon': '📜'},
    {'name': 'Dart', 'icon': '🎯'},
    {'name': 'Java', 'icon': '☕'},
    {'name': 'C++', 'icon': '⚡'},
    {'name': 'Rust', 'icon': '🦀'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              S.of(context).onboardingLanguageTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).onboardingLanguageDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final language = languages[index];
                  return _LanguageCard(
                    name: language['name']!,
                    icon: language['icon']!,
                    onTap: () {
                      context.read<OnboardingBloc>().add(
                        SelectLanguageEvent(language['name']!),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<OnboardingBloc>().add(CompleteOnboardingEvent());
              },
              child: Text(S.of(context).onboardingSkipForNow),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String name;
  final String icon;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;

  const _PageIndicator({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == currentPage;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
