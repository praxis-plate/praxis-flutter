import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButtonHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackPressed;
  final bool Function()? canGoBack;

  const BackButtonHandler({
    super.key,
    required this.child,
    this.onBackPressed,
    this.canGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canGoBack?.call() ?? context.canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (onBackPressed != null) {
            onBackPressed!();
          } else if (context.canPop()) {
            context.pop();
          }
        }
      },
      child: child,
    );
  }
}

class ConfirmExitBackButtonHandler extends StatelessWidget {
  final Widget child;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;

  const ConfirmExitBackButtonHandler({
    super.key,
    required this.child,
    this.title = 'Exit',
    this.message = 'Are you sure you want to exit?',
    this.confirmText = 'Exit',
    this.cancelText = 'Cancel',
  });

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _showExitConfirmation(context);
          if (shouldExit && context.mounted) {
            if (context.canPop()) {
              context.pop();
            }
          }
        }
      },
      child: child,
    );
  }
}

class SaveBeforeExitBackButtonHandler extends StatelessWidget {
  final Widget child;
  final Future<bool> Function() onSave;
  final String title;
  final String message;
  final String saveText;
  final String discardText;
  final String cancelText;

  const SaveBeforeExitBackButtonHandler({
    super.key,
    required this.child,
    required this.onSave,
    this.title = 'Unsaved Changes',
    this.message = 'You have unsaved changes. What would you like to do?',
    this.saveText = 'Save',
    this.discardText = 'Discard',
    this.cancelText = 'Cancel',
  });

  Future<bool?> _showSaveDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(discardText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(saveText),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldSave = await _showSaveDialog(context);
          if (shouldSave == null) {
            return;
          }

          if (shouldSave) {
            final saved = await onSave();
            if (!saved) {
              return;
            }
          }

          if (context.mounted && context.canPop()) {
            context.pop();
          }
        }
      },
      child: child,
    );
  }
}
