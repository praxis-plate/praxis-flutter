import 'package:codium/core/exceptions/app_error_extensions.dart';
import 'package:codium/core/widgets/common_search_bar.dart';
import 'package:codium/features/library/bloc/library_bloc.dart';
import 'package:codium/features/library/widgets/pdf_book_card.dart';
import 'package:codium/s.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final LibraryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<LibraryBloc>()..add(LoadLibraryEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc.add(LoadLibraryEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: const _LibraryScreenContent(),
    );
  }
}

class _LibraryScreenContent extends StatelessWidget {
  const _LibraryScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).libraryTitle,
            style: theme.textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _importPdf(context),
              color: theme.colorScheme.primary,
              iconSize: 28,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).libraryTabAll),
              Tab(text: S.of(context).libraryTabFavorites),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(context, showFavoritesOnly: false),
            _buildTabContent(context, showFavoritesOnly: true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _importPdf(context),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context, {
    required bool showFavoritesOnly,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CommonSearchBar(
            hintText: S.of(context).librarySearchHint,
            onChanged: (value) {
              context.read<LibraryBloc>().add(SearchLibraryEvent(value));
            },
            onClear: () {
              context.read<LibraryBloc>().add(const SearchLibraryEvent(''));
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, state) {
              return switch (state) {
                LibraryLoadedState() => _buildLibraryContent(
                  context,
                  state,
                  showFavoritesOnly: showFavoritesOnly,
                ),
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
    );
  }

  Widget _buildLibraryContent(
    BuildContext context,
    LibraryLoadedState state, {
    required bool showFavoritesOnly,
  }) {
    final books = showFavoritesOnly
        ? state.filteredBooks.where((book) => book.isFavorite).toList()
        : state.filteredBooks;

    if (books.isEmpty) {
      return _buildEmptyState(
        context,
        state.searchQuery.isNotEmpty,
        showFavoritesOnly: showFavoritesOnly,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return PdfBookCard(book: books[index]);
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isSearching, {
    required bool showFavoritesOnly,
  }) {
    final theme = Theme.of(context);

    IconData icon;
    String message;
    String? subtitle;

    if (isSearching) {
      icon = Icons.search_off;
      message = S.of(context).libraryNoBooksFound;
    } else if (showFavoritesOnly) {
      icon = Icons.favorite_border;
      message = S.of(context).libraryNoFavorites;
      subtitle = S.of(context).libraryAddFavoritesHint;
    } else {
      icon = Icons.library_books_outlined;
      message = S.of(context).libraryNoPdfs;
      subtitle = S.of(context).libraryTapToImport;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, LibraryErrorState state) {
    final theme = Theme.of(context);
    final errorMessage =
        state.message ?? state.errorCode.localizedMessage(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              S.of(context).libraryErrorLoading,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
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
