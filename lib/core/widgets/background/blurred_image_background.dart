import 'dart:math';
import 'dart:ui';

import 'package:codium/core/utils/asset_loader.dart';
import 'package:flutter/material.dart';

class BlurredImageBackground extends StatefulWidget {
  static final Random _random = Random();

  final String? assetPath;
  final double blurSigma;
  final BoxFit fit;

  const BlurredImageBackground({
    super.key,
    this.assetPath,
    this.blurSigma = 18,
    this.fit = BoxFit.cover,
  }) : assert(blurSigma > 0, 'blurSigma must be > 0');

  @override
  State<BlurredImageBackground> createState() => _BlurredImageBackgroundState();
}

class _BlurredImageBackgroundState extends State<BlurredImageBackground> {
  late Future<String?> _assetFuture;

  @override
  void initState() {
    super.initState();
    _assetFuture = _resolveAsset(widget.assetPath);
  }

  @override
  void didUpdateWidget(BlurredImageBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _assetFuture = _resolveAsset(widget.assetPath);
    }
  }

  Future<String?> _resolveAsset(String? assetPath) async {
    if (assetPath != null && assetPath.isNotEmpty) {
      return widget.assetPath;
    }

    final assets = await AssetLoader.loadByPrefix(
      'assets/images/blur-backgrounds/',
    );

    if (assets.isEmpty) {
      return null;
    }

    return _pickRandom(assets);
  }

  String _pickRandom(List<String> assets) {
    return assets[BlurredImageBackground._random.nextInt(assets.length)];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _assetFuture,
      builder: (context, snapshot) {
        final asset = snapshot.data;
        if (asset == null || asset.isEmpty) {
          return const SizedBox.expand();
        }

        final image = Image.asset(
          asset,
          fit: widget.fit,
          filterQuality: FilterQuality.high,
          width: double.infinity,
          height: double.infinity,
        );

        return ClipRRect(
          child: SizedBox.expand(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: widget.blurSigma,
                sigmaY: widget.blurSigma,
              ),
              child: image,
            ),
          ),
        );
      },
    );
  }
}
