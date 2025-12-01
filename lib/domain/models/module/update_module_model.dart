import 'package:equatable/equatable.dart';

class UpdateModuleModel extends Equatable {
  final int id;
  final String? title;
  final String? description;
  final int? orderIndex;

  const UpdateModuleModel({
    required this.id,
    this.title,
    this.description,
    this.orderIndex,
  });

  @override
  List<Object?> get props => [id, title, description, orderIndex];

  @override
  bool get stringify => true;
}
