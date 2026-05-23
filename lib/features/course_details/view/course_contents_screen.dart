import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/features/course_details/widgets/table_of_contents_content.dart';
import 'package:praxis/s.dart';

class CourseContentsScreen extends StatelessWidget {
  const CourseContentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: context.pop,
        ),
        title: Text(
          s.courseDetailsContentsTab,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 24),
        child: TableOfContentsContent(),
      ),
    );
  }
}
