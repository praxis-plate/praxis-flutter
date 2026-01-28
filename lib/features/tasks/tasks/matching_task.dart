import 'dart:convert';

import 'package:codium/core/widgets/widgets.dart';
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
  List<String> _terms = [];
  List<String> _definitions = [];
  static const double _itemHeight = 88;

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
                  children: _terms.map((term) {
                    final isSelected = _selectedTerm == term;
                    final isMatched = _matches.containsKey(term);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: isMatched ? null : () => _onTermTap(term),
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: _itemHeight,
                          child: GlassCard(
                            padding: const EdgeInsets.all(12),
                            borderRadius: BorderRadius.circular(12),
                            backgroundColor: isMatched
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.18,
                                  )
                                : isSelected
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  )
                                : null,
                            borderColor: isMatched || isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withValues(
                                    alpha: 0.3,
                                  ),
                            borderWidth: isSelected || isMatched ? 2 : 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    term,
                                    maxLines: 3,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                if (isMatched)
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    onPressed: () => _removeMatch(term),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
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
                  children: _definitions.map((definition) {
                    final isMatched = _matches.containsValue(definition);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: isMatched
                            ? null
                            : () => _onDefinitionTap(definition),
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: _itemHeight,
                          child: GlassCard(
                            padding: const EdgeInsets.all(12),
                            borderRadius: BorderRadius.circular(12),
                            backgroundColor: isMatched
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.18,
                                  )
                                : null,
                            borderColor: isMatched
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withValues(
                                    alpha: 0.3,
                                  ),
                            borderWidth: isMatched ? 2 : 1,
                            child: Text(
                              definition,
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
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
