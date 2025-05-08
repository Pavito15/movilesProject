import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String surname;
  final String phone;
  final String pictureProfile;
  final String provider;
  final String role;
  final bool isActive;
  final String tokenDevice;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
    required this.pictureProfile,
    required this.provider,
    required this.role,
    required this.isActive,
    required this.tokenDevice,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      phone: data['phone'] ?? '',
      pictureProfile: data['pictureProfile'] ?? '',
      provider: data['provider'] ?? '',
      role: data['role'] ?? 'user', // Default value as 'user'
      isActive: data['isActive'] ?? true,
      tokenDevice: data['tokenDevice'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'phone': phone,
      'pictureProfile': pictureProfile,
      'provider': provider,
      'role': role,
      'isActive': isActive,
      'tokenDevice': tokenDevice,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? email,
    String? name,
    String? surname,
    String? phone,
    String? pictureProfile,
    String? provider,
    String? role,
    bool? isActive,
    String? tokenDevice,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      pictureProfile: pictureProfile ?? this.pictureProfile,
      provider: provider ?? this.provider,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      tokenDevice: tokenDevice ?? this.tokenDevice,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
