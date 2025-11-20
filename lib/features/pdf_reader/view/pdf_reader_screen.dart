import 'package:codium/core/exceptions/app_error_extensions.dart';
import 'package:codium/core/services/connectivity_service.dart';
import 'package:codium/core/widgets/feedback/offline_indicator.dart';
import 'package:codium/features/ai_explanation/bloc/ai_explanation_bloc.dart';
import 'package:codium/features/ai_explanation/widgets/explanation_bottom_sheet.dart';
import 'package:codium/features/pdf_reader/bloc/pdf_reader_bloc.dart';
import 'package:codium/features/pdf_reader/widgets/bookmarks_panel.dart';
import 'package:codium/features/pdf_reader/widgets/text_selection_menu.dart';
import 'package:flutter/material.dart';
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
  bool _showTextSelectionMenu = false;
  Offset _menuPosition = Offset.zero;
  String _selectedText = '';
  double _lastScrollPosition = 0;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    context.read<PdfReaderBloc>().add(OpenPdfEvent(widget.bookId));

    final connectivityService = GetIt.I<ConnectivityService>();
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
    final bloc = context.read<PdfReaderBloc>();
    bloc.add(SaveScrollPositionEvent(_lastScrollPosition));
    _pdfController?.dispose();
    super.dispose();
  }

  Future<void> _initializePdfController(
    String filePath,
    int initialPage,
    double? scrollPosition,
  ) async {
    _pdfController = PdfController(
      document: PdfDocument.openFile(filePath),
      initialPage: initialPage + 1,
    );

    if (scrollPosition != null) {
      _lastScrollPosition = scrollPosition;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
            icon: const Icon(Icons.bookmark),
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
                  icon: const Icon(Icons.bookmark_add),
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
              final errorMessage =
                  state.message ?? state.errorCode.localizedMessage(context);

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is PdfReaderLoadedState && _pdfController != null) {
              return Stack(
                children: [
                  Column(
                    children: [
                      if (!_isConnected) const OfflineIndicator(),
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
                              Text(
                                'Lazy loading enabled for large PDF',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: GestureDetector(
                          onLongPressStart: (details) {
                            _handleTextSelection(details.globalPosition, state);
                          },
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
                      ),
                      _buildPageIndicator(state),
                    ],
                  ),
                  if (_showTextSelectionMenu)
                    Positioned(
                      left: _menuPosition.dx,
                      top: _menuPosition.dy,
                      child: TextSelectionMenu(
                        selectedText: _selectedText,
                        isOffline: !_isConnected,
                        onExplain: () {
                          context.read<PdfReaderBloc>().add(
                            SelectTextEvent(
                              selectedText: _selectedText,
                              pageNumber: state.currentPage,
                            ),
                          );

                          context.read<AiExplanationBloc>().add(
                            RequestExplanationEvent(
                              selectedText: _selectedText,
                              context:
                                  'Context from PDF page ${state.currentPage + 1}',
                              pdfBookId: state.book.id,
                              pageNumber: state.currentPage,
                            ),
                          );

                          setState(() {
                            _showTextSelectionMenu = false;
                          });
                        },
                        onDismiss: () {
                          setState(() {
                            _showTextSelectionMenu = false;
                          });
                        },
                      ),
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

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Bookmark'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Page ${currentPage + 1}'),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Bookmark added')));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _handleTextSelection(Offset position, PdfReaderLoadedState state) {
    setState(() {
      _selectedText = 'Selected text from page ${state.currentPage + 1}';
      _menuPosition = Offset(position.dx - 50, position.dy - 60);
      _showTextSelectionMenu = true;
    });
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
