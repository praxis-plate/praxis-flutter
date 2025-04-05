import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class CourseSearchBar extends StatelessWidget {
  const CourseSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SearchAnchor(
      viewHintText: S.of(context).searchCourse,
      viewBackgroundColor: theme.cardColor,
      dividerColor: theme.colorScheme.onSurfaceVariant,
      isFullScreen: false,
      viewElevation: 0,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          shape: WidgetStateProperty.resolveWith(
            (states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              );
            },
          ),
          elevation: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) {
              return 0;
            },
          ),
          backgroundColor:
              WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            return theme.cardColor;
          }),
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: S.of(context).searchCourse,
          hintStyle: WidgetStateProperty.resolveWith(
            (Set<WidgetState> states) => theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<Widget>.generate(
          5,
          (index) => const CourseSearchElement(),
        );
      },
    );
  }
}

class CourseSearchElement extends StatelessWidget {
  const CourseSearchElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Rust Programming Language Likes Moto Moto Gangsters Zip',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
