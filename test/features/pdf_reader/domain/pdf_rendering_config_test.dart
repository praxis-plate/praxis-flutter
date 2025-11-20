import 'package:codium/features/pdf_reader/domain/pdf_rendering_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PdfRenderingConfig', () {
    test('should use default values', () {
      const config = PdfRenderingConfig();

      expect(config.enableProgressiveRendering, true);
      expect(config.enableLazyLoading, true);
      expect(config.lazyLoadingThreshold, 100);
      expect(config.maxCachedPages, 3);
      expect(config.renderQuality, 2.0);
    });

    test('should enable lazy loading for large PDFs', () {
      const config = PdfRenderingConfig();

      expect(config.shouldUseLazyLoading(150), true);
      expect(config.shouldUseLazyLoading(100), false);
      expect(config.shouldUseLazyLoading(50), false);
    });

    test('should not use lazy loading when disabled', () {
      const config = PdfRenderingConfig(enableLazyLoading: false);

      expect(config.shouldUseLazyLoading(150), false);
    });

    test('should respect custom threshold', () {
      const config = PdfRenderingConfig(lazyLoadingThreshold: 50);

      expect(config.shouldUseLazyLoading(60), true);
      expect(config.shouldUseLazyLoading(50), false);
      expect(config.shouldUseLazyLoading(40), false);
    });

    test('should create copy with modified values', () {
      const config = PdfRenderingConfig();
      final modified = config.copyWith(
        enableProgressiveRendering: false,
        maxCachedPages: 5,
      );

      expect(modified.enableProgressiveRendering, false);
      expect(modified.maxCachedPages, 5);
      expect(modified.enableLazyLoading, true);
      expect(modified.lazyLoadingThreshold, 100);
    });
  });
}
