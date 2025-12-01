import 'package:equatable/equatable.dart';

class ModuleModel extends Equatable {
  final int id;
  final int courseId;
  final String title;
  final String description;
  final int orderIndex;
  final DateTime createdAt;

  const ModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.createdAt,
  });

  ModuleModel copyWith({
    int? id,
    int? courseId,
    String? title,
    String? description,
    int? orderIndex,
    DateTime? createdAt,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    courseId,
    title,
    description,
    orderIndex,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
