import 'package:equatable/equatable.dart';

class UpdateLessonProgressModel extends Equatable {
  final int id;
  final bool? isCompleted;
  final DateTime? completedAt;
  final int? timeSpentSeconds;

  const UpdateLessonProgressModel({
    required this.id,
    this.isCompleted,
    this.completedAt,
    this.timeSpentSeconds,
  });

  @override
  List<Object?> get props => [id, isCompleted, completedAt, timeSpentSeconds];

  @override
  bool get stringify => true;
}
