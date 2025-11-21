import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/features/library/bloc/library_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PdfBookCard extends StatelessWidget {
  final PdfBook book;

  const PdfBookCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _openBook(context),
      onLongPress: () => _showContextMenu(context),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 64,
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  if (book.isFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.9,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 16,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.author != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      book.author!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  _ProgressBar(
                    currentPage: book.currentPage,
                    totalPages: book.totalPages,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    S
                        .of(context)
                        .pdfBookPages(book.currentPage, book.totalPages),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBook(BuildContext context) {
    context.push('/pdf/${book.id}');
  }

  void _showContextMenu(BuildContext context) {
    final localizations = S.of(context);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: Text(localizations.pdfBookOpen),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _openBook(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    book.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  title: Text(
                    book.isFavorite
                        ? localizations.pdfBookRemoveFromFavorites
                        : localizations.pdfBookAddToFavorites,
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<LibraryBloc>().add(
                      ToggleFavoriteEvent(book.id),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(localizations.pdfBookRename),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _showRenameDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: theme.colorScheme.error),
                  title: Text(
                    localizations.pdfBookDelete,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _showDeleteConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: book.title);
    final localizations = S.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.pdfBookRenameTitle),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(localizations.pdfBookRenameCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(localizations.pdfBookRenameSave),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final localizations = S.of(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.pdfBookDeleteTitle),
          content: Text(localizations.pdfBookDeleteMessage(book.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(localizations.pdfBookDeleteCancel),
            ),
            TextButton(
              onPressed: () {
                context.read<LibraryBloc>().add(DeletePdfEvent(book.id));
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text(localizations.pdfBookDeleteConfirm),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _ProgressBar({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalPages > 0 ? currentPage / totalPages : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        minHeight: 6,
      ),
    );
  }
}
