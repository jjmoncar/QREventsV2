import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String role; // 'admin' or 'staff'
  final bool isVerified;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.role = 'admin',
    this.isVerified = false,
    this.avatarUrl,
    this.createdAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isStaff => role == 'staff';

  @override
  List<Object?> get props =>
      [id, email, name, role, isVerified, avatarUrl, createdAt];
}
