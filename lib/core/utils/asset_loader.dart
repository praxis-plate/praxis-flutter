import 'dart:convert';

import 'package:flutter/services.dart';

class AssetLoader {
  AssetLoader._();

  static final Map<String, Future<List<String>>> _cacheByPrefix = {};

  static Future<List<String>> loadByPrefix(
    String assetPrefix, {
    AssetBundle? assetBundle,
  }) {
    final resolvedAssetBundle = assetBundle ?? rootBundle;
    return _cacheByPrefix.putIfAbsent(
      assetPrefix,
      () => _loadByPrefix(assetPrefix, assetBundle: resolvedAssetBundle),
    );
  }

  static void clearCache([String? assetPrefix]) {
    if (assetPrefix == null) {
      _cacheByPrefix.clear();
      return;
    }
    _cacheByPrefix.remove(assetPrefix);
  }

  static Future<List<String>> _loadByPrefix(
    String assetPrefix, {
    required AssetBundle assetBundle,
  }) async {
    final List<String> assetsFromBinary = await _tryLoadFromManifestBinary(
      assetPrefix,
      assetBundle: assetBundle,
    );

    if (assetsFromBinary.isNotEmpty) {
      return assetsFromBinary;
    }

    return _tryLoadFromManifestJson(assetPrefix, assetBundle: assetBundle);
  }

  static Future<List<String>> _tryLoadFromManifestBinary(
    String assetPrefix, {
    required AssetBundle assetBundle,
  }) async {
    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(
        assetBundle,
      );

      return _filterByPrefix(manifest.listAssets(), assetPrefix);
    } on Exception {
      return const [];
    }
  }

  static Future<List<String>> _tryLoadFromManifestJson(
    String assetPrefix, {
    required AssetBundle assetBundle,
  }) async {
    try {
      final String manifestContent = await assetBundle.loadString(
        'AssetManifest.json',
      );

      final Map<String, dynamic> manifest =
          json.decode(manifestContent) as Map<String, dynamic>;

      return _filterByPrefix(manifest.keys, assetPrefix);
    } on Exception {
      return const [];
    }
  }

  static List<String> _filterByPrefix(
    Iterable<String> assetKeys,
    String assetPrefix,
  ) {
    return assetKeys
        .where((String key) => key.startsWith(assetPrefix))
        .toList();
  }
}
