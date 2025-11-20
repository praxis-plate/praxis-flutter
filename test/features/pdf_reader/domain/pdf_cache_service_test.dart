import 'package:codium/features/pdf_reader/domain/pdf_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pdfx/pdfx.dart';

@GenerateMocks([PdfPageImage])
import 'pdf_cache_service_test.mocks.dart';

void main() {
  group('PdfCacheService', () {
    late PdfCacheService cacheService;

    setUp(() {
      cacheService = PdfCacheService(maxCachedPages: 3);
    });

    test('should cache pages up to max limit', () {
      final page1 = MockPdfPageImage();
      final page2 = MockPdfPageImage();
      final page3 = MockPdfPageImage();

      cacheService.cachePage(1, page1);
      cacheService.cachePage(2, page2);
      cacheService.cachePage(3, page3);

      expect(cacheService.isCached(1), true);
      expect(cacheService.isCached(2), true);
      expect(cacheService.isCached(3), true);
      expect(cacheService.getCachedPageNumbers().length, 3);
    });

    test('should remove oldest page when exceeding max limit', () {
      final page1 = MockPdfPageImage();
      final page2 = MockPdfPageImage();
      final page3 = MockPdfPageImage();
      final page4 = MockPdfPageImage();

      cacheService.cachePage(1, page1);
      cacheService.cachePage(2, page2);
      cacheService.cachePage(3, page3);
      cacheService.cachePage(4, page4);

      expect(cacheService.isCached(1), false);
      expect(cacheService.isCached(2), true);
      expect(cacheService.isCached(3), true);
      expect(cacheService.isCached(4), true);
      expect(cacheService.getCachedPageNumbers().length, 3);
    });

    test('should retrieve cached page', () {
      final page1 = MockPdfPageImage();
      cacheService.cachePage(1, page1);

      final retrieved = cacheService.getCachedPage(1);
      expect(retrieved, page1);
    });

    test('should return null for non-cached page', () {
      final retrieved = cacheService.getCachedPage(99);
      expect(retrieved, null);
    });

    test('should clear all cached pages', () {
      final page1 = MockPdfPageImage();
      final page2 = MockPdfPageImage();

      cacheService.cachePage(1, page1);
      cacheService.cachePage(2, page2);

      cacheService.clearCache();

      expect(cacheService.isCached(1), false);
      expect(cacheService.isCached(2), false);
      expect(cacheService.getCachedPageNumbers().length, 0);
    });

    test('should identify pages to preload for middle page', () {
      cacheService.preloadAdjacentPages(5, 10);
    });

    test('should identify pages to preload for first page', () {
      cacheService.preloadAdjacentPages(0, 10);
    });

    test('should identify pages to preload for last page', () {
      cacheService.preloadAdjacentPages(9, 10);
    });
  });
}
