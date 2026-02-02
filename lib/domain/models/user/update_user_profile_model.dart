import 'package:equatable/equatable.dart';

class UpdateUserProfileModel extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? avatarUrl;

  const UpdateUserProfileModel({
    required this.id,
    this.email,
    this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl];

  @override
  bool get stringify => true;
}
