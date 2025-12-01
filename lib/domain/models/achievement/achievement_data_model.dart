// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AchievementModel extends Equatable {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.unlockedAt,
  });

  final int id;
  final String title;
  final String description;
  final String? iconUrl;
  final DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;

  AchievementModel copyWith({
    int? id,
    String? title,
    String? description,
    String? iconUrl,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'unlockedAt': unlockedAt?.millisecondsSinceEpoch,
    };
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      iconUrl: map['iconUrl'] != null ? map['iconUrl'] as String : null,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['unlockedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AchievementModel.fromJson(String source) =>
      AchievementModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, description, iconUrl, unlockedAt];
}
