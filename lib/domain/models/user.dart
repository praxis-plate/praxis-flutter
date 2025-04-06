// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final double balance;
  final String? avatarUrl; 

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    double? balance,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name, 
      email: email ?? this.email,
      balance: balance ?? this.balance,
    );
  }
  
  @override
  List<Object?> get props => [id, name, email, avatarUrl, balance];
}