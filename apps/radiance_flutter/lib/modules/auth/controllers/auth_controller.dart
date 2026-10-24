import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final IAuthRepository authRepo;

  AuthController({required this.authRepo});

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final emailOrPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    currentUser.value = authRepo.currentUser;
  }

  Future<void> login() async {
    final input = emailOrPhoneController.text.trim();
    final pwd = passwordController.text.trim();

    if (input.isEmpty || pwd.isEmpty) {
      errorMessage.value = 'Please enter your username/email and password.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await authRepo.login(input, pwd);
      currentUser.value = user;
      _routeForRole(user?.role);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyParentOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (phone.isEmpty || otp.isEmpty) {
      errorMessage.value = 'Please enter phone number and 6-digit OTP.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await authRepo.loginWithPhoneOtp(phone, otp);
      currentUser.value = user;
      Get.toNamed(AppRoutes.parentDashboard);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> switchRole(UserRole role) async {
    try {
      isLoading.value = true;
      final user = await authRepo.switchRole(role);
      currentUser.value = user;
      _routeForRole(role);
    } finally {
      isLoading.value = false;
    }
  }

  void _routeForRole(UserRole? role) {
    if (role == null) return;
    switch (role) {
      case UserRole.admin:
        Get.toNamed(AppRoutes.adminDashboard);
        break;
      case UserRole.student:
        Get.toNamed(AppRoutes.studentDashboard);
        break;
      case UserRole.parent:
        Get.toNamed(AppRoutes.parentDashboard);
        break;
      case UserRole.teacher:
        Get.toNamed(AppRoutes.teacherDashboard);
        break;
    }
  }

  Future<void> logout() async {
    await authRepo.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
