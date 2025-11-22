import 'package:codium/domain/models/pdf_reader/bookmark.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BookmarksPanel extends StatefulWidget {
  final String bookId;
  final VoidCallback onClose;
  final Function(int) onBookmarkTap;

  const BookmarksPanel({
    super.key,
    required this.bookId,
    required this.onClose,
    required this.onBookmarkTap,
  });

  @override
  State<BookmarksPanel> createState() => _BookmarksPanelState();
}

class _BookmarksPanelState extends State<BookmarksPanel> {
  List<Bookmark> _bookmarks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = GetIt.I<IPdfRepository>();
      final bookmarks = await repository.getBookmarks(widget.bookId);
      setState(() {
        _bookmarks = bookmarks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBookmark(String bookmarkId) async {
    try {
      final repository = GetIt.I<IPdfRepository>();
      await repository.deleteBookmark(bookmarkId);
      await _loadBookmarks();
      if (mounted) {
        final l10n = S.of(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.bookmarksDeleted)));
      }
    } catch (e) {
      if (mounted) {
        final l10n = S.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.bookmarksErrorDeleting(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _BookmarksPanelHeader(onClose: widget.onClose),
          Expanded(
            child: _BookmarksPanelContent(
              isLoading: _isLoading,
              error: _error,
              bookmarks: _bookmarks,
              onRetry: _loadBookmarks,
              onBookmarkTap: widget.onBookmarkTap,
              onDeleteBookmark: _deleteBookmark,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookmarksPanelHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _BookmarksPanelHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.bookmark, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              s.bookmarksTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }
}

class _BookmarksPanelContent extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<Bookmark> bookmarks;
  final VoidCallback onRetry;
  final Function(int) onBookmarkTap;
  final Function(String) onDeleteBookmark;

  const _BookmarksPanelContent({
    required this.isLoading,
    required this.error,
    required this.bookmarks,
    required this.onRetry,
    required this.onBookmarkTap,
    required this.onDeleteBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                s.bookmarksErrorLoading,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: Text(s.bookmarksRetry)),
            ],
          ),
        ),
      );
    }

    if (bookmarks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                s.bookmarksNoBookmarks,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s.bookmarksTapToAdd,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return _BookmarkItem(
          bookmark: bookmark,
          onTap: onBookmarkTap,
          onDelete: onDeleteBookmark,
        );
      },
    );
  }
}

class _BookmarkItem extends StatelessWidget {
  final Bookmark bookmark;
  final Function(int) onTap;
  final Function(String) onDelete;

  const _BookmarkItem({
    required this.bookmark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '${bookmark.pageNumber + 1}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(l10n.bookmarksPage(bookmark.pageNumber + 1)),
        subtitle: bookmark.note != null
            ? Text(bookmark.note!, maxLines: 2, overflow: TextOverflow.ellipsis)
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showDeleteConfirmation(context, bookmark),
        ),
        onTap: () => onTap(bookmark.pageNumber),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Bookmark bookmark) {
    final l10n = S.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.bookmarksDeleteTitle),
        content: Text(l10n.bookmarksDeleteMessage(bookmark.pageNumber + 1)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.bookmarksDeleteCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onDelete(bookmark.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.bookmarksDeleteConfirm),
          ),
        ],
      ),
    );
  }
}
