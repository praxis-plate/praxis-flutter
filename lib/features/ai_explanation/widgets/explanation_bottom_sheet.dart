import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/domain/models/ai_explanation/ai_explanation.dart';
import 'package:codium/features/ai_explanation/bloc/ai_explanation_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ExplanationBottomSheet extends StatelessWidget {
  const ExplanationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiExplanationBloc, AiExplanationState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _BottomSheetHandle(),
              Flexible(child: _BottomSheetContent(state: state)),
            ],
          ),
        );
      },
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  final AiExplanationState state;

  const _BottomSheetContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      AiExplanationInitialState() => const SizedBox.shrink(),
      AiExplanationLoadingState() => _LoadingContent(
        state: state as AiExplanationLoadingState,
      ),
      AiExplanationLoadedState() => _LoadedContent(
        state: state as AiExplanationLoadedState,
      ),
      AiExplanationErrorState() => _ErrorContent(
        state: state as AiExplanationErrorState,
      ),
    };
  }
}

class _LoadingContent extends StatelessWidget {
  final AiExplanationLoadingState state;

  const _LoadingContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            state.pageNumber != null
                ? s.explanationAnalyzingPage(state.pageNumber! + 1)
                : s.explanationGenerating,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            s.explanationSelected(state.selectedText),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoadedContent extends StatelessWidget {
  final AiExplanationLoadedState state;

  const _LoadedContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final explanation = state.explanation;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s.explanationTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${explanation.selectedText}"',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.bookmark_outline,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Page ${explanation.pageNumber + 1}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          MarkdownBody(
            data: explanation.explanation,
            styleSheet: MarkdownStyleSheet(
              p: theme.textTheme.bodyMedium,
              h1: theme.textTheme.titleMedium,
              h2: theme.textTheme.titleSmall,
              code: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                backgroundColor: theme.cardColor,
              ),
              codeblockDecoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (explanation.sources.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(s.explanationSources, style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            ...explanation.sources.map((source) => _SourceCard(source: source)),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final SearchSource source;

  const _SourceCard({required this.source});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      source.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                source.snippet,
                style: theme.textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                source.url,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.6,
                  ),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final AiExplanationErrorState state;

  const _ErrorContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final errorMessage =
        state.message ?? state.errorCode.localizedMessage(context);

    String actionableMessage = errorMessage;
    if (state.isOffline) {
      actionableMessage = s.explanationNoInternetMessage;
    } else if (state.errorCode == AppErrorCode.rateLimitExceeded) {
      actionableMessage = errorMessage;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            state.isOffline ? Icons.wifi_off : Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            state.isOffline ? s.explanationNoInternet : s.explanationError,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            actionableMessage,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (state.canRetry) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AiExplanationBloc>().add(
                  const RetryExplanationEvent(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text(s.explanationRetry),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
