// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:codium/domain/models/user/money.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final Money balance;
  final List<String> purchasedCourseIds;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.purchasedCourseIds,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    Money? balance,
    List<String>? purchasedCourseIds,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      purchasedCourseIds: purchasedCourseIds ?? this.purchasedCourseIds,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, balance, purchasedCourseIds];
}
