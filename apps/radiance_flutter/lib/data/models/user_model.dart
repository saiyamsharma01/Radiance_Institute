enum UserRole {
  admin,
  teacher,
  parent,
  student,
}

class UserModel {
  final String uid;
  final String displayName;
  final UserRole role;
  final String phoneNumber;
  final String? email;
  final String accountStatus;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.role,
    required this.phoneNumber,
    this.email,
    this.accountStatus = 'active',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      displayName: json['displayName'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['role'] ?? 'student').toString().toLowerCase(),
        orElse: () => UserRole.student,
      ),
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      accountStatus: json['accountStatus'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'role': role.name,
      'phoneNumber': phoneNumber,
      'email': email,
      'accountStatus': accountStatus,
    };
  }
}
