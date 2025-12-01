import 'package:equatable/equatable.dart';

class CreateUserStatisticModel extends Equatable {
  final int userId;

  const CreateUserStatisticModel({required this.userId});

  @override
  List<Object?> get props => [userId];

  @override
  bool get stringify => true;
}
