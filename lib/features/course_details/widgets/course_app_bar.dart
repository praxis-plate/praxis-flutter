import 'package:flutter/material.dart';

class CourseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CourseAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
