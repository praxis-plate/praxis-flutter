import 'package:codium/core/config/feature_flags.dart';
import 'package:codium/core/exceptions/app_error_extensions.dart';
import 'package:codium/core/widgets/feedback/offline_indicator.dart';
import 'package:codium/domain/services/connectivity_service.dart';
import 'package:codium/features/ai_explanation/bloc/ai_explanation_bloc.dart';
import 'package:codium/features/ai_explanation/widgets/explanation_bottom_sheet.dart';
import 'package:codium/features/pdf_reader/bloc/pdf_reader_bloc.dart';
import 'package:codium/features/pdf_reader/widgets/bookmarks_panel.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pdfx/pdfx.dart';

class PdfReaderScreen extends StatefulWidget {
  final String bookId;
  final int? initialPage;

  const PdfReaderScreen({super.key, required this.bookId, this.initialPage});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  PdfController? _pdfController;
  bool _showBookmarksPanel = false;
  double _lastScrollPosition = 0;
  bool _isConnected = true;
  late final PdfReaderBloc _pdfReaderBloc;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pdfReaderBloc = context.read<PdfReaderBloc>();
    _pdfReaderBloc.add(OpenPdfEvent(widget.bookId));

    final connectivityService = GetIt.I<IConnectivityService>();
    _isConnected = connectivityService.isConnected;

    connectivityService.connectivityStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  void dispose() {
    _pdfReaderBloc.add(SaveScrollPositionEvent(_lastScrollPosition));
    _pdfController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initializePdfController(
    String filePath,
    int initialPage,
    double? scrollPosition,
  ) async {
    try {
      _pdfController = PdfController(
        document: PdfDocument.openFile(filePath),
        initialPage: initialPage + 1,
      );

      if (scrollPosition != null) {
        _lastScrollPosition = scrollPosition;
      }

      setState(() {});
    } catch (e) {
      if (mounted) {
        final l10n = S.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pdfReaderErrorGeneral),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final state = _pdfReaderBloc.state;
          if (state is PdfReaderLoadedState &&
              _isConnected &&
              FeatureFlags.enableAiExplanations) {
            if (event.logicalKey == LogicalKeyboardKey.keyE &&
                (HardwareKeyboard.instance.isControlPressed ||
                    HardwareKeyboard.instance.isMetaPressed)) {
              _showEnhancedTextSelectionDialog(context, state);
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<PdfReaderBloc, PdfReaderState>(
            builder: (context, state) {
              if (state is PdfReaderLoadedState) {
                return Text(state.book.title);
              }
              return const Text('PDF Reader');
            },
          ),
          actions: [
            if (FeatureFlags.enableAiExplanations)
              BlocBuilder<PdfReaderBloc, PdfReaderState>(
                builder: (context, state) {
                  if (state is PdfReaderLoadedState) {
                    return IconButton(
                      icon: const Icon(Icons.lightbulb_outline),
                      tooltip: S.of(context).pdfReaderExplainPage,
                      onPressed: _isConnected
                          ? () => _showExplainPageDialog(context, state)
                          : null,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            IconButton(
              icon: Icon(
                Icons.bookmark,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                setState(() {
                  _showBookmarksPanel = !_showBookmarksPanel;
                });
              },
            ),
            BlocBuilder<PdfReaderBloc, PdfReaderState>(
              builder: (context, state) {
                if (state is PdfReaderLoadedState) {
                  return IconButton(
                    icon: Icon(
                      Icons.bookmark_add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      _showAddBookmarkDialog(context, state.currentPage);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        floatingActionButton: FeatureFlags.enableAiExplanations
            ? BlocBuilder<PdfReaderBloc, PdfReaderState>(
                builder: (context, state) {
                  if (state is PdfReaderLoadedState && _isConnected) {
                    return FloatingActionButton.extended(
                      onPressed: () =>
                          _showEnhancedTextSelectionDialog(context, state),
                      icon: const Icon(Icons.lightbulb_outline),
                      label: Text(S.of(context).pdfReaderAskAi),
                      tooltip: S.of(context).pdfReaderAskAiTooltip,
                      heroTag: 'askAiButton',
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            : null,
        body: MultiBlocListener(
          listeners: [
            BlocListener<AiExplanationBloc, AiExplanationState>(
              listener: (context, state) {
                if (state is AiExplanationLoadedState ||
                    state is AiExplanationErrorState) {
                  _showExplanationBottomSheet(context);
                }
              },
            ),
          ],
          child: BlocConsumer<PdfReaderBloc, PdfReaderState>(
            listener: (context, state) {
              if (state is PdfReaderLoadedState && _pdfController == null) {
                _initializePdfController(
                  state.book.filePath,
                  state.currentPage,
                  state.scrollPosition,
                );
              }
            },
            builder: (context, state) {
              if (state is PdfReaderLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PdfReaderErrorState) {
                final l10n = S.of(context);
                final errorMessage =
                    state.message ?? state.errorCode.localizedMessage(context);

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.pdfReaderErrorOpeningTitle,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          errorMessage,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(l10n.pdfReaderBackToLibrary),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is PdfReaderLoadedState && _pdfController != null) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        if (!_isConnected) const OfflineIndicator(),
                        if (_isConnected && FeatureFlags.enableAiExplanations)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.3),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    S.of(context).pdfReaderSelectTextHint,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (state.useLazyLoading)
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.speed,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    S.of(context).pdfReaderLazyLoading,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification is ScrollUpdateNotification) {
                                _lastScrollPosition =
                                    notification.metrics.pixels;
                              }
                              return false;
                            },
                            child: PdfView(
                              controller: _pdfController!,
                              onPageChanged: (page) {
                                context.read<PdfReaderBloc>().add(
                                  ChangePageEvent(page - 1),
                                );
                              },
                              onDocumentLoaded: (document) {},
                              onDocumentError: (error) {},
                            ),
                          ),
                        ),
                        _buildPageIndicator(state),
                      ],
                    ),
                    if (_showBookmarksPanel)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: BookmarksPanel(
                          bookId: state.book.id,
                          onClose: () {
                            setState(() {
                              _showBookmarksPanel = false;
                            });
                          },
                          onBookmarkTap: (pageNumber) {
                            _pdfController?.jumpToPage(pageNumber + 1);
                            setState(() {
                              _showBookmarksPanel = false;
                            });
                          },
                        ),
                      ),
                  ],
                );
              }

              return const Center(child: Text('No PDF loaded'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(PdfReaderLoadedState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Page ${state.currentPage + 1} of ${state.book.totalPages}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBookmarkDialog(BuildContext context, int currentPage) {
    final noteController = TextEditingController();
    final l10n = S.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.pdfReaderAddBookmarkTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.pdfReaderAddBookmarkPage(currentPage + 1)),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: l10n.pdfReaderAddBookmarkNote,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textAlignVertical: TextAlignVertical.top,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.pdfReaderAddBookmarkCancel),
          ),
          TextButton(
            onPressed: () {
              context.read<PdfReaderBloc>().add(
                AddBookmarkEvent(
                  pageNumber: currentPage,
                  note: noteController.text.isEmpty
                      ? null
                      : noteController.text,
                ),
              );
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.pdfReaderBookmarkAdded)),
              );
            },
            child: Text(l10n.pdfReaderAddBookmarkAdd),
          ),
        ],
      ),
    );
  }

  void _showExplainPageDialog(
    BuildContext context,
    PdfReaderLoadedState state,
  ) {
    _showEnhancedTextSelectionDialog(context, state);
  }

  void _showEnhancedTextSelectionDialog(
    BuildContext context,
    PdfReaderLoadedState state,
  ) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => _EnhancedTextSelectionDialog(
        textController: textController,
        state: state,
        onExplain: (text) {
          context.read<PdfReaderBloc>().add(
            SelectTextEvent(selectedText: text, pageNumber: state.currentPage),
          );

          context.read<AiExplanationBloc>().add(
            RequestExplanationEvent(
              selectedText: text,
              context:
                  'From ${state.book.title}, page ${state.currentPage + 1}',
              pdfBookId: state.book.id,
              pageNumber: state.currentPage,
            ),
          );
        },
      ),
    );
  }

  void _showExplanationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => const ExplanationBottomSheet(),
      ),
    );
  }
}

class _EnhancedTextSelectionDialog extends StatefulWidget {
  final TextEditingController textController;
  final PdfReaderLoadedState state;
  final Function(String) onExplain;

  const _EnhancedTextSelectionDialog({
    required this.textController,
    required this.state,
    required this.onExplain,
  });

  @override
  State<_EnhancedTextSelectionDialog> createState() =>
      _EnhancedTextSelectionDialogState();
}

class _EnhancedTextSelectionDialogState
    extends State<_EnhancedTextSelectionDialog> {
  String? _clipboardText;
  bool _isLoadingClipboard = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadClipboard();
  }

  Future<void> _loadClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (mounted) {
        setState(() {
          _clipboardText = clipboardData?.text;
          _isLoadingClipboard = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _clipboardText = null;
          _isLoadingClipboard = false;
        });
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    if (_clipboardText != null && _clipboardText!.isNotEmpty) {
      widget.textController.text = _clipboardText!;
    }
  }

  void _handleExplain() {
    if (_isProcessing) {
      return;
    }

    final text = widget.textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    widget.onExplain(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.lightbulb_outline),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.pdfReaderSelectText)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoadingClipboard)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_clipboardText != null && _clipboardText!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.content_paste,
                          size: 16,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${l10n.pdfReaderClipboardPreview} ${_clipboardText!.length > 40 ? '${_clipboardText!.substring(0, 40)}...' : _clipboardText!}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pasteFromClipboard,
                        icon: const Icon(Icons.content_paste, size: 16),
                        label: Text(
                          l10n.pdfReaderPasteFromClipboard,
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.content_paste_off,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.pdfReaderNoClipboardContent,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: widget.textController,
              decoration: InputDecoration(
                labelText: l10n.pdfReaderEnterText,
                hintText: l10n.pdfReaderEnterTextPlaceholder,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.text_fields),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              maxLines: 2,
              autofocus: true,
              onSubmitted: (_) => _handleExplain(),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close, color: theme.colorScheme.error),
              tooltip: l10n.pdfReaderCancel,
              style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.textController.clear();
                });
              },
              icon: Icon(
                Icons.backspace_outlined,
                color: theme.colorScheme.primary,
              ),
              style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _handleExplain,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
                icon: _isProcessing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lightbulb_outline, size: 16),
                label: Text(
                  _isProcessing
                      ? l10n.pdfReaderProcessing
                      : l10n.pdfReaderExplain,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
