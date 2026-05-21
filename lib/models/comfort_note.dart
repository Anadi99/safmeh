import 'package:equatable/equatable.dart';

class ComfortNote extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final DateTime createdAt;

  const ComfortNote({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ComfortNote.fromJson(Map<String, dynamic> json) => ComfortNote(
    id: json['id'] as String,
    userId: json['userId'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  @override
  List<Object?> get props => [id, userId, title, body, createdAt];
}
