import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAsset extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  const SvgAsset(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bundle = DefaultAssetBundle.of(context);

    return FutureBuilder<String>(
      future: bundle.loadString(assetPath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(
            snapshot.data!,
            width: width,
            height: height,
            fit: fit,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
          );
        }

        if (snapshot.hasError) {
          return _MissingSvgAssetPlaceholder(
            width: width,
            height: height,
            color: color,
          );
        }

        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }
}

class _MissingSvgAssetPlaceholder extends StatelessWidget {
  const _MissingSvgAssetPlaceholder({this.width, this.height, this.color});

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.outline;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.24)),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported_outlined, color: iconColor),
    );
  }
}

class ShiftAsset extends StatelessWidget {
  final ShiftState state;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  const ShiftAsset(
    this.state, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgAsset(
      state.assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}

enum ShiftState {
  achievementStar('assets/images/shift/states/positive/achievement_star.svg'),
  celebrate('assets/images/shift/states/positive/celebrate.svg'),
  correctCheck('assets/images/shift/states/positive/correct_check.svg'),
  lessonTrophy('assets/images/shift/states/positive/lesson_trophy.svg'),
  streakFlame('assets/images/shift/states/positive/streak_flame.svg'),
  thumbsUp('assets/images/shift/states/positive/thumbs_up.svg'),
  almostThere('assets/images/shift/states/negative/almost_there.svg'),
  bugError('assets/images/shift/states/negative/bug_error.svg'),
  retry('assets/images/shift/states/negative/retry.svg'),
  thinking('assets/images/shift/states/negative/thinking.svg'),
  wrongSad('assets/images/shift/states/negative/wrong_sad.svg');

  final String assetPath;

  const ShiftState(this.assetPath);
}

class OnboardingAsset extends StatelessWidget {
  final int pageNumber;
  final double? size;

  const OnboardingAsset({super.key, required this.pageNumber, this.size = 300});

  @override
  Widget build(BuildContext context) {
    return SvgAsset(
      'assets/images/onboarding/onboarding_$pageNumber.svg',
      width: size,
      height: size,
    );
  }
}

class EmptyStateAsset extends StatelessWidget {
  final EmptyStateType type;
  final double? size;

  const EmptyStateAsset({super.key, required this.type, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SvgAsset(
      'assets/images/empty_states/${type.fileName}',
      width: size,
      height: size,
    );
  }
}

enum EmptyStateType {
  library('empty_library.svg'),
  history('empty_history.svg'),
  bookmarks('empty_bookmarks.svg'),
  noInternet('no_internet.svg'),
  searchEmpty('search_empty.svg');

  final String fileName;
  const EmptyStateType(this.fileName);
}
