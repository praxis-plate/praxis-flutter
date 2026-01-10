sealed class TableOfContentsItem {
  const TableOfContentsItem();
}

final class TableOfContentsModuleTitle extends TableOfContentsItem {
  final String text;
  const TableOfContentsModuleTitle(this.text);
}

final class TableOfContentsTaskItem extends TableOfContentsItem {
  final String text;
  const TableOfContentsTaskItem(this.text);
}

class TableOfContentsParser {
  const TableOfContentsParser();

  List<TableOfContentsItem> parse(String content) {
    final lines = content.split('\n');
    final List<TableOfContentsItem> items = [];

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      if (trimmedLine.startsWith('#')) {
        items.add(TableOfContentsModuleTitle(trimmedLine.substring(1).trim()));
        continue;
      }

      if (trimmedLine.startsWith('*')) {
        items.add(TableOfContentsTaskItem(trimmedLine.substring(1).trim()));
        continue;
      }
    }

    return items;
  }
}
