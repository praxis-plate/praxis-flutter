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
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
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
