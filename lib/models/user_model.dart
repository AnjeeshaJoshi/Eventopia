import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_app/models.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? organization;
  final String? profileImage;
  final bool mustChangePassword;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.organization,
    this.profileImage,
    this.mustChangePassword = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: UserRole.values.firstWhere((e) => e.name == json['role'], orElse: () => UserRole.attendee),
      organization: json['organization'] as String?,
      profileImage: json['profileImage'] as String?,
      mustChangePassword: json['mustChangePassword'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'organization': organization,
      'profileImage': profileImage,
      'mustChangePassword': mustChangePassword,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? organization,
    String? profileImage,
    bool? mustChangePassword,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      organization: organization ?? this.organization,
      profileImage: profileImage ?? this.profileImage,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
