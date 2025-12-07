import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/explanation/explanation_model.dart';
import 'package:codium/domain/repositories/i_pdf_repository.dart';
import 'package:codium/features/explanation_history/bloc/explanation_history_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<ExplanationHistoryBloc>()..add(LoadHistoryEvent()),
      child: const _HistoryScreenContent(),
    );
  }
}

class _HistoryScreenContent extends StatelessWidget {
  const _HistoryScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).historyTitle,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CommonSearchBar(
              hintText: S.of(context).historySearchHint,
              onChanged: (value) {
                context.read<ExplanationHistoryBloc>().add(
                  SearchHistoryEvent(value),
                );
              },
              onClear: () {
                context.read<ExplanationHistoryBloc>().add(
                  const SearchHistoryEvent(''),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ExplanationHistoryBloc, ExplanationHistoryState>(
              builder: (context, state) {
                return switch (state) {
                  ExplanationHistoryLoadedState() => _HistoryContent(
                    state: state,
                  ),
                  ExplanationHistoryLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ExplanationHistoryErrorState() => _HistoryErrorState(
                    state: state,
                  ),
                  ExplanationHistoryInitialState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  final ExplanationHistoryLoadedState state;

  const _HistoryContent({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.groupedExplanations.isEmpty) {
      return _HistoryEmptyState(isSearching: state.searchQuery.isNotEmpty);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.groupedExplanations.length,
      itemBuilder: (context, index) {
        final pdfId = state.groupedExplanations.keys.elementAt(index);
        final explanations = state.groupedExplanations[pdfId]!;

        return _PdfGroupCard(pdfId: pdfId, explanations: explanations);
      },
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  final bool isSearching;

  const _HistoryEmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.history,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? S.of(context).historyNoExplanationsFound
                  : S.of(context).historyNoHistory,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (!isSearching)
              Text(
                S.of(context).historyStartReading,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

class _HistoryErrorState extends StatelessWidget {
  final ExplanationHistoryErrorState state;

  const _HistoryErrorState({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorMessage =
        state.message ?? state.errorCode.localizedMessage(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            S.of(context).historyErrorLoading,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ExplanationHistoryBloc>().add(LoadHistoryEvent());
            },
            child: Text(S.of(context).historyRetry),
          ),
        ],
      ),
    );
  }
}

class _PdfGroupCard extends StatefulWidget {
  final int pdfId;
  final List<ExplanationModel> explanations;

  const _PdfGroupCard({required this.pdfId, required this.explanations});

  @override
  State<_PdfGroupCard> createState() => _PdfGroupCardState();
}

class _PdfGroupCardState extends State<_PdfGroupCard> {
  String? _pdfTitle;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdfTitle();
  }

  Future<void> _loadPdfTitle() async {
    try {
      final pdfRepository = GetIt.I<IPdfRepository>();
      final result = await pdfRepository.getBookById(widget.pdfId);
      if (mounted) {
        setState(() {
          _pdfTitle = result.dataOrNull?.title;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _pdfTitle = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _pdfTitle ?? S.of(context).historyUnknownPdf,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Text(
                  '${widget.explanations.length} ${widget.explanations.length == 1 ? S.of(context).historyExplanation : S.of(context).historyExplanations}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.explanations.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _ExplanationItem(explanation: widget.explanations[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _ExplanationItem extends StatelessWidget {
  final ExplanationModel explanation;

  const _ExplanationItem({required this.explanation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, y • HH:mm');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        explanation.selectedText,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            explanation.explanation,
            style: theme.textTheme.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                dateFormat.format(explanation.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.bookmark_outline,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                S.of(context).bookmarksPage(explanation.pageNumber),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => _showDeleteDialog(context),
      ),
      onTap: () => _navigateToPdfLocation(context),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(context).historyDeleteTitle),
        content: Text(S.of(context).historyDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(S.of(context).historyDeleteCancel),
          ),
          TextButton(
            onPressed: () {
              context.read<ExplanationHistoryBloc>().add(
                DeleteHistoryEvent(explanation.id),
              );
              Navigator.of(dialogContext).pop();
            },
            child: Text(S.of(context).historyDeleteConfirm),
          ),
        ],
      ),
    );
  }

  void _navigateToPdfLocation(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/pdf-reader',
      arguments: {
        'bookId': explanation.pdfBookId,
        'initialPage': explanation.pageNumber,
      },
    );
  }
}
