import 'package:equatable/equatable.dart';

class TrustedContact extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;
  final String? email;
  final bool isEmergencyContact;
  final DateTime addedAt;

  const TrustedContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.isEmergencyContact = false,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'isEmergencyContact': isEmergencyContact,
    'addedAt': addedAt.toIso8601String(),
  };

  factory TrustedContact.fromJson(Map<String, dynamic> json) => TrustedContact(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    phoneNumber: json['phoneNumber'] as String,
    email: json['email'] as String?,
    isEmergencyContact: json['isEmergencyContact'] as bool? ?? false,
    addedAt: DateTime.parse(json['addedAt'] as String),
  );

  TrustedContact copyWith({
    String? id,
    String? userId,
    String? name,
    String? phoneNumber,
    String? email,
    bool? isEmergencyContact,
    DateTime? addedAt,
  }) => TrustedContact(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
    isEmergencyContact: isEmergencyContact ?? this.isEmergencyContact,
    addedAt: addedAt ?? this.addedAt,
  );

  @override
  List<Object?> get props => [id, userId, name, phoneNumber, email, isEmergencyContact, addedAt];
}
