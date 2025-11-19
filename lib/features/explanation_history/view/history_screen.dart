import 'package:codium/domain/models/ai_explanation/explanation.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:codium/features/explanation_history/bloc/explanation_history_bloc.dart';
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
        title: Text('Explanation History', style: theme.textTheme.titleLarge),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: _SearchBar()),
          Expanded(
            child: BlocBuilder<ExplanationHistoryBloc, ExplanationHistoryState>(
              builder: (context, state) {
                return switch (state) {
                  ExplanationHistoryLoadedState() => _buildHistoryContent(
                    context,
                    state,
                  ),
                  ExplanationHistoryLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ExplanationHistoryErrorState() => _buildErrorState(
                    context,
                    state,
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

  Widget _buildHistoryContent(
    BuildContext context,
    ExplanationHistoryLoadedState state,
  ) {
    if (state.groupedExplanations.isEmpty) {
      return _buildEmptyState(context, state.searchQuery.isNotEmpty);
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

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    final theme = Theme.of(context);

    return Center(
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
            isSearching ? 'No explanations found' : 'No explanation history',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          if (!isSearching)
            Text(
              'Start reading and ask for explanations',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ExplanationHistoryErrorState state,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('Error loading history', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            state.message,
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
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search explanations...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  context.read<ExplanationHistoryBloc>().add(
                    const SearchHistoryEvent(''),
                  );
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (value) {
        context.read<ExplanationHistoryBloc>().add(SearchHistoryEvent(value));
      },
    );
  }
}

class _PdfGroupCard extends StatefulWidget {
  final String pdfId;
  final List<Explanation> explanations;

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
      final book = await pdfRepository.getBookById(widget.pdfId);
      if (mounted) {
        setState(() {
          _pdfTitle = book?.title ?? 'Unknown PDF';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _pdfTitle = 'Unknown PDF';
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
                          _pdfTitle ?? 'Unknown PDF',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Text(
                  '${widget.explanations.length} ${widget.explanations.length == 1 ? 'explanation' : 'explanations'}',
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
  final Explanation explanation;

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
                'Page ${explanation.pageNumber}',
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
        title: const Text('Delete Explanation'),
        content: const Text(
          'Are you sure you want to delete this explanation from history?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ExplanationHistoryBloc>().add(
                DeleteHistoryEvent(explanation.id),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToPdfLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigate to ${explanation.selectedText} on page ${explanation.pageNumber}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
