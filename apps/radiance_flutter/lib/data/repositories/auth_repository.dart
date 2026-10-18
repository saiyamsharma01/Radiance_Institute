import 'dart:async';
import '../models/user_model.dart';
import 'mock_data_source.dart';

abstract class IAuthRepository {
  Future<UserModel?> login(String emailOrPhone, String password);
  Future<UserModel?> loginWithPhoneOtp(String phoneNumber, String otp);
  Future<UserModel?> switchRole(UserRole role);
  UserModel? get currentUser;
  Future<void> logout();
}

class AuthRepository implements IAuthRepository {
  UserModel? _currentUser = MockDataSource.users.firstWhere((u) => u.role == UserRole.admin);

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel?> login(String emailOrPhone, String password) async {
    final cleanInput = emailOrPhone.trim().toLowerCase();

    // Look for matching user in registered accounts
    final user = MockDataSource.users.firstWhere(
      (u) =>
          u.email?.toLowerCase() == cleanInput ||
          u.phoneNumber.contains(cleanInput.replaceAll(RegExp(r'\D'), '')),
      orElse: () => MockDataSource.users.first,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<UserModel?> loginWithPhoneOtp(String phoneNumber, String otp) async {
    // Verify 6-digit OTP (in sandbox demo, any 6-digit number or 123456 verifies)
    if (otp.trim().length != 6) {
      throw Exception('Please enter a valid 6-digit OTP.');
    }
    final parent = MockDataSource.users.firstWhere(
      (u) => u.role == UserRole.parent,
      orElse: () => UserModel(
        uid: 'usr_parent_verified',
        displayName: 'Verified Parent',
        role: UserRole.parent,
        phoneNumber: phoneNumber,
      ),
    );
    _currentUser = parent;
    return parent;
  }

  @override
  Future<UserModel?> switchRole(UserRole role) async {
    final user = MockDataSource.users.firstWhere(
      (u) => u.role == role,
      orElse: () => MockDataSource.users.first,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
