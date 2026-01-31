import 'package:flutter/material.dart';

class TaskViewLayout extends StatelessWidget {
  final Widget content;
  final Widget footer;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry footerPadding;

  const TaskViewLayout({
    super.key,
    required this.content,
    required this.footer,
    this.contentPadding = const EdgeInsets.all(16),
    this.footerPadding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(padding: contentPadding, child: content),
        ),
        Padding(
          padding: footerPadding,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: footer,
          ),
        ),
      ],
    );
  }
}
