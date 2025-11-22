class PdfRenderingConfig {
  final bool enableProgressiveRendering;
  final bool enableLazyLoading;
  final int lazyLoadingThreshold;
  final int maxCachedPages;
  final double renderQuality;

  const PdfRenderingConfig({
    this.enableProgressiveRendering = true,
    this.enableLazyLoading = true,
    this.lazyLoadingThreshold = 100,
    this.maxCachedPages = 3,
    this.renderQuality = 2.0,
  });

  bool shouldUseLazyLoading(int totalPages) {
    return enableLazyLoading && totalPages > lazyLoadingThreshold;
  }

  PdfRenderingConfig copyWith({
    bool? enableProgressiveRendering,
    bool? enableLazyLoading,
    int? lazyLoadingThreshold,
    int? maxCachedPages,
    double? renderQuality,
  }) {
    return PdfRenderingConfig(
      enableProgressiveRendering:
          enableProgressiveRendering ?? this.enableProgressiveRendering,
      enableLazyLoading: enableLazyLoading ?? this.enableLazyLoading,
      lazyLoadingThreshold: lazyLoadingThreshold ?? this.lazyLoadingThreshold,
      maxCachedPages: maxCachedPages ?? this.maxCachedPages,
      renderQuality: renderQuality ?? this.renderQuality,
    );
  }
}
