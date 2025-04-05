// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? imagePath;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.imagePath,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? imagePath,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'imagePath': imagePath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map.containsKey('name') ? map['name'] as String : null,
      imagePath:
          map.containsKey('imagePath') ? map['imagePath'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, imagePath: $imagePath)';
  }

  @override
  List<Object?> get props => [id, email, name, imagePath];
}
