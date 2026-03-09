import 'package:codium/core/bloc/theme/theme_cubit.dart';
import 'package:codium/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:codium/core/router/route_constants.dart';
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

class _OnboardingScreenContent extends StatefulWidget {
  const _OnboardingScreenContent();

  @override
  State<_OnboardingScreenContent> createState() =>
      _OnboardingScreenContentState();
}

class _OnboardingScreenContentState extends State<_OnboardingScreenContent> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleteState) {
          context.go(RouteConstants.root);
        }
      },
      child: Scaffold(
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return switch (state) {
              OnboardingPage1State() ||
              OnboardingPage2State() ||
              OnboardingPage3State() => _OnboardingPager(
                pageController: _pageController,
                currentPage: _currentPage,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
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

class _OnboardingPager extends StatelessWidget {
  const _OnboardingPager({
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final pages = [
      (
        icon: Icons.school_rounded,
        title: s.onboardingTitle1,
        description: s.onboardingDescription1,
      ),
      (
        icon: Icons.task_alt_rounded,
        title: s.onboardingTitle2,
        description: s.onboardingDescription2,
      ),
      (
        icon: Icons.emoji_events_rounded,
        title: s.onboardingTitle3,
        description: s.onboardingDescription3,
      ),
    ];
    final isLastPage = currentPage == pages.length - 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    final colorScheme = Theme.of(context).colorScheme;

                    return IconButton.outlined(
                      onPressed: () => context.read<ThemeCubit>().setDarkTheme(
                        !themeState.isDarkTheme,
                      ),
                      tooltip: s.profileSetDarkMode,
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        foregroundColor: colorScheme.onSurface,
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      icon: Icon(
                        themeState.isDarkTheme
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                    );
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<OnboardingBloc>().add(
                      CompleteOnboardingEvent(),
                    );
                  },
                  child: Text(s.onboardingSkip),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return _OnboardingPageContent(
                    icon: page.icon,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),
            _PageIndicator(currentPage: currentPage),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => isLastPage
                    ? context.read<OnboardingBloc>().add(
                        CompleteOnboardingEvent(),
                      )
                    : pageController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                child: Text(s.onboardingNext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageContent extends StatelessWidget {
  const _OnboardingPageContent({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
