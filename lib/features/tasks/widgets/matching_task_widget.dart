import 'dart:convert';

import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/bloc/task/task_bloc.dart';
import 'package:codium/features/tasks/widgets/task_hint_button.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchingTaskWidget extends StatefulWidget {
  final MatchingTaskModel task;

  const MatchingTaskWidget({super.key, required this.task});

  @override
  State<MatchingTaskWidget> createState() => _MatchingTaskWidgetState();
}

class _MatchingTaskWidgetState extends State<MatchingTaskWidget> {
  final Map<String, String> _matches = {};
  String? _selectedTerm;
  List<String> _terms = [];
  List<String> _definitions = [];

  @override
  void initState() {
    super.initState();
    _initializeMatchingData();
  }

  void _initializeMatchingData() {
    _terms = List.from(widget.task.leftItems);
    _definitions = List.from(widget.task.rightItems);
    _definitions.shuffle();
  }

  void _onTermTap(String term) {
    setState(() {
      if (_selectedTerm == term) {
        _selectedTerm = null;
      } else {
        _selectedTerm = term;
      }
    });
  }

  void _onDefinitionTap(String definition) {
    if (_selectedTerm != null) {
      setState(() {
        _matches[_selectedTerm!] = definition;
        _selectedTerm = null;
      });
    }
  }

  void _removeMatch(String term) {
    setState(() {
      _matches.remove(term);
    });
  }

  bool get _allMatched => _matches.length == _terms.length;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.task.questionText,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            s.taskMatchItems,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _terms.map((term) {
                    final isSelected = _selectedTerm == term;
                    final isMatched = _matches.containsKey(term);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: isMatched ? null : () => _onTermTap(term),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isMatched
                                ? theme.colorScheme.tertiaryContainer
                                : isSelected
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isMatched
                                  ? theme.colorScheme.tertiary
                                  : isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline.withValues(
                                      alpha: 0.3,
                                    ),
                              width: isSelected || isMatched ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  term,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isMatched
                                        ? theme.colorScheme.onTertiaryContainer
                                        : isSelected
                                        ? theme.colorScheme.onPrimaryContainer
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (isMatched)
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color:
                                        theme.colorScheme.onTertiaryContainer,
                                  ),
                                  onPressed: () => _removeMatch(term),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _definitions.map((definition) {
                    final isMatched = _matches.containsValue(definition);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: isMatched
                            ? null
                            : () => _onDefinitionTap(definition),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isMatched
                                ? theme.colorScheme.tertiaryContainer
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isMatched
                                  ? theme.colorScheme.tertiary
                                  : theme.colorScheme.outline.withValues(
                                      alpha: 0.3,
                                    ),
                              width: isMatched ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            definition,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isMatched
                                  ? theme.colorScheme.onTertiaryContainer
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TaskHintButton(taskId: widget.task.id),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _allMatched
                ? () {
                    final matchesJson = jsonEncode(_matches);
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(matchesJson),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              disabledBackgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              s.taskSubmitButton,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _allMatched
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
