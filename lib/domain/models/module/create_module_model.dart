import 'package:equatable/equatable.dart';

class CreateModuleModel extends Equatable {
  final int courseId;
  final String title;
  final String description;
  final int orderIndex;

  const CreateModuleModel({
    required this.courseId,
    required this.title,
    required this.description,
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [courseId, title, description, orderIndex];

  @override
  bool get stringify => true;
}
