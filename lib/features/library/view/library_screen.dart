import 'package:codium/core/exceptions/app_error_extensions.dart';
import 'package:codium/features/library/bloc/library_bloc.dart';
import 'package:codium/features/library/widgets/pdf_book_card.dart';
import 'package:codium/generated/l10n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<LibraryBloc>()..add(LoadLibraryEvent()),
      child: const _LibraryScreenContent(),
    );
  }
}

class _LibraryScreenContent extends StatelessWidget {
  const _LibraryScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).libraryTitle,
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _importPdf(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: _SearchBar()),
          Expanded(
            child: BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                return switch (state) {
                  LibraryLoadedState() => _buildLibraryContent(context, state),
                  LibraryLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  LibraryErrorState() => _buildErrorState(context, state),
                  LibraryInitialState() => const Center(
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

  Widget _buildLibraryContent(BuildContext context, LibraryLoadedState state) {
    if (state.filteredBooks.isEmpty) {
      return _buildEmptyState(context, state.searchQuery.isNotEmpty);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.filteredBooks.length,
      itemBuilder: (context, index) {
        return PdfBookCard(book: state.filteredBooks[index]);
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
            isSearching ? Icons.search_off : Icons.library_books_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? S.of(context).libraryNoBooksFound
                : S.of(context).libraryNoPdfs,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          if (!isSearching)
            Text(
              S.of(context).libraryTapToImport,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, LibraryErrorState state) {
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
            S.of(context).libraryErrorLoading,
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
              context.read<LibraryBloc>().add(LoadLibraryEvent());
            },
            child: Text(S.of(context).libraryRetry),
          ),
        ],
      ),
    );
  }

  Future<void> _importPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      if (context.mounted) {
        context.read<LibraryBloc>().add(
          ImportPdfEvent(result.files.single.path!),
        );
      }
    }
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
        hintText: S.of(context).librarySearchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  context.read<LibraryBloc>().add(const SearchLibraryEvent(''));
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (value) {
        context.read<LibraryBloc>().add(SearchLibraryEvent(value));
      },
    );
  }
}
