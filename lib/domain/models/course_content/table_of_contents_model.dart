import 'package:equatable/equatable.dart';

class TableOfContentsModel extends Equatable {
  final String tableOfContents;
  final int totalLessons;

  const TableOfContentsModel({
    required this.tableOfContents,
    required this.totalLessons,
  });

  @override
  List<Object?> get props => [tableOfContents, totalLessons];
}
