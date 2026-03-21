import 'dart:convert';

import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/bloc/task/task_bloc.dart';
import 'package:codium/features/tasks/widgets/task_view_layout.dart';
import 'package:codium/features/tasks/widgets/task_hint_button.dart';
import 'package:codium/features/tasks/widgets/submit_task_button.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchingTask extends StatefulWidget {
  final MatchingTaskModel task;

  const MatchingTask({super.key, required this.task});

  @override
  State<MatchingTask> createState() => _MatchingTaskState();
}

class _MatchingTaskState extends State<MatchingTask> {
  final Map<String, String> _matches = {};
  String? _selectedTerm;
  String? _selectedDefinition;
  List<String> _terms = [];
  List<String> _definitions = [];
  static const double _itemMinHeight = 72;

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
      if (_matches.containsKey(term)) {
        _matches.remove(term);
        _selectedTerm = null;
      } else if (_selectedTerm == term) {
        _selectedTerm = null;
      } else {
        _selectedTerm = term;
      }
    });
  }

  void _onDefinitionTap(String definition) {
    final matchedTerm = _findTermForDefinition(definition);
    if (matchedTerm != null && _selectedTerm == null) {
      setState(() {
        _matches.remove(matchedTerm);
        _selectedDefinition = null;
      });
      return;
    }

    setState(() {
      if (_selectedDefinition == definition) {
        _selectedDefinition = null;
      } else {
        _selectedDefinition = definition;
      }
    });
  }

  void _applySelectionMatch() {
    final term = _selectedTerm;
    final definition = _selectedDefinition;
    if (term == null || definition == null) {
      return;
    }

    setState(() {
      final previousTerm = _findTermForDefinition(definition);
      if (previousTerm == term) {
        _matches.remove(term);
        _selectedTerm = null;
        _selectedDefinition = null;
        return;
      }
      if (previousTerm != null) {
        _matches.remove(previousTerm);
      }
      _matches[term] = definition;
      _selectedTerm = null;
      _selectedDefinition = null;
    });
  }

  bool get _allMatched => _matches.length == _terms.length;

  Map<String, String> _buildOrderedMatches() {
    final ordered = <String, String>{};
    for (final term in _terms) {
      final match = _matches[term];
      if (match != null) {
        ordered[term] = match;
      }
    }
    return ordered;
  }

  String? _findTermForDefinition(String definition) {
    for (final entry in _matches.entries) {
      if (entry.value == definition) {
        return entry.key;
      }
    }
    return null;
  }

  String _leftLabel(int index) => '${index + 1}';

  String _rightLabel(int index) => String.fromCharCode(65 + index);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return TaskViewLayout(
      content: Column(
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
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _terms.asMap().entries.map((entry) {
                    final index = entry.key;
                    final term = entry.value;
                    final isSelected = _selectedTerm == term;
                    final matchedDefinition = _matches[term];
                    final isMatched = matchedDefinition != null;
                    final isHighlighted = isMatched || isSelected;
                    final leftLabel = _leftLabel(index);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          _onTermTap(term);
                          _applySelectionMatch();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: _itemMinHeight,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? theme.colorScheme.primary
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isHighlighted
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor.withValues(
                                        alpha: 0.6,
                                      ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    _MatchBadge(
                                      label: leftLabel,
                                      isHighlighted: isHighlighted,
                                    ),
                                    if (isMatched) ...[
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.link,
                                        size: 14,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      _MatchBadge(
                                        label: _rightLabel(
                                          _definitions.indexOf(
                                            matchedDefinition,
                                          ),
                                        ),
                                        isHighlighted: true,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  term,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isHighlighted
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
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
                  children: _definitions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final definition = entry.value;
                    final matchedTerm = _findTermForDefinition(definition);
                    final isMatched = matchedTerm != null;
                    final isSelected = _selectedDefinition == definition;
                    final isHighlighted = isMatched || isSelected;
                    final rightLabel = _rightLabel(index);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          _onDefinitionTap(definition);
                          _applySelectionMatch();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: _itemMinHeight,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? theme.colorScheme.primary
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isHighlighted
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor.withValues(
                                        alpha: 0.6,
                                      ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    _MatchBadge(
                                      label: rightLabel,
                                      isHighlighted: isHighlighted,
                                    ),
                                    if (isMatched) ...[
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.link,
                                        size: 14,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      _MatchBadge(
                                        label: _leftLabel(
                                          _terms.indexOf(matchedTerm),
                                        ),
                                        isHighlighted: true,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  definition,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isHighlighted
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
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
        ],
      ),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TaskHintButton(taskId: widget.task.id),
          const SizedBox(height: 12),
          SubmitTaskButton(
            label: s.taskSubmitButton,
            onPressed: _allMatched
                ? () {
                    final matchesJson = jsonEncode(_buildOrderedMatches());
                    context.read<TaskBloc>().add(
                      SubmitAnswerEvent(matchesJson),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  final String label;
  final bool isHighlighted;

  const _MatchBadge({
    required this.label,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = isHighlighted
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.2)
        : theme.colorScheme.surfaceContainerHighest;
    final foreground = isHighlighted
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
