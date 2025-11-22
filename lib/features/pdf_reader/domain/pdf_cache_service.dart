import 'dart:collection';

import 'package:pdfx/pdfx.dart';

class PdfCacheService {
  final int _maxCachedPages;
  final LinkedHashMap<int, PdfPageImage> _pageCache = LinkedHashMap();

  PdfCacheService({int maxCachedPages = 3}) : _maxCachedPages = maxCachedPages;

  PdfPageImage? getCachedPage(int pageNumber) {
    return _pageCache[pageNumber];
  }

  void cachePage(int pageNumber, PdfPageImage pageImage) {
    if (_pageCache.length >= _maxCachedPages) {
      final firstKey = _pageCache.keys.first;
      _pageCache.remove(firstKey);
    }
    _pageCache[pageNumber] = pageImage;
  }

  void clearCache() {
    _pageCache.clear();
  }

  bool isCached(int pageNumber) {
    return _pageCache.containsKey(pageNumber);
  }

  List<int> getCachedPageNumbers() {
    return _pageCache.keys.toList();
  }

  void preloadAdjacentPages(int currentPage, int totalPages) {
    final pagesToPreload = <int>[];

    if (currentPage > 0) {
      pagesToPreload.add(currentPage - 1);
    }

    if (currentPage < totalPages - 1) {
      pagesToPreload.add(currentPage + 1);
    }

    for (final page in pagesToPreload) {
      if (!isCached(page)) {}
    }
  }
}
