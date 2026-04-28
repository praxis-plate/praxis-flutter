import 'dart:convert';

import 'package:equatable/equatable.dart';

enum LessonContentBlockType { heading, paragraph, quote, code, image }

class LessonContentDocument extends Equatable {
  final int schemaVersion;
  final List<LessonContentBlock> blocks;

  const LessonContentDocument({
    required this.schemaVersion,
    required this.blocks,
  });

  factory LessonContentDocument.fromStoredContent(String content) {
    final decoded = _tryDecodeMap(content);
    if (decoded == null || decoded['schemaVersion'] != 1) {
      return LessonContentDocument(
        schemaVersion: 1,
        blocks: [
          LessonContentBlock(
            type: LessonContentBlockType.paragraph,
            text: content,
          ),
        ],
      );
    }

    final blocks = decoded['blocks'];
    if (blocks is! List) {
      return const LessonContentDocument(schemaVersion: 1, blocks: []);
    }

    return LessonContentDocument(
      schemaVersion: 1,
      blocks: blocks
          .whereType<Map>()
          .map((block) => LessonContentBlock.fromJson(block.cast()))
          .toList(),
    );
  }

  String toMarkdown() {
    return blocks.map((block) => block.toMarkdown()).join('\n\n');
  }

  @override
  List<Object?> get props => [schemaVersion, blocks];
}

class LessonContentBlock extends Equatable {
  final LessonContentBlockType type;
  final String? text;
  final int? level;
  final String? language;
  final String? url;
  final String? caption;

  const LessonContentBlock({
    required this.type,
    this.text,
    this.level,
    this.language,
    this.url,
    this.caption,
  });

  factory LessonContentBlock.fromJson(Map<String, dynamic> json) {
    return LessonContentBlock(
      type: LessonContentBlockType.values.byName(json['type'] as String),
      text: json['text'] as String?,
      level: json['level'] as int?,
      language: json['language'] as String?,
      url: json['url'] as String?,
      caption: json['caption'] as String?,
    );
  }

  String toMarkdown() {
    return switch (type) {
      LessonContentBlockType.heading =>
        '${List.filled(level ?? 2, '#').join()} ${text ?? ''}',
      LessonContentBlockType.paragraph => text ?? '',
      LessonContentBlockType.quote => '> ${text ?? ''}',
      LessonContentBlockType.code => '```${language ?? ''}\n${text ?? ''}\n```',
      LessonContentBlockType.image =>
        url == null || url!.isEmpty
            ? caption ?? ''
            : '![${caption ?? ''}]($url)',
    };
  }

  @override
  List<Object?> get props => [type, text, level, language, url, caption];
}

Map<String, dynamic>? _tryDecodeMap(String value) {
  try {
    final decoded = jsonDecode(value);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}
