import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class SplashHighlight {
  final IconData icon;
  final String title;
  final String subtitle;

  const SplashHighlight({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final IAuthRepository authRepo;

  SplashController({required this.authRepo});

  // Dynamic progress value from 0.0 to 1.0
  final RxDouble progress = 0.0.obs;

  // Real-time dynamic stage message
  final RxString statusMessage = 'Initializing Secure Core...'.obs;

  // Active institutional highlight
  final RxInt activeHighlightIndex = 0.obs;

  // Flag to guard against multiple navigations
  bool _hasNavigated = false;

  Timer? _progressTimer;
  Timer? _highlightTimer;

  // Dynamic highlights showcasing Radiance Institute strengths
  final List<SplashHighlight> highlights = const [
    SplashHighlight(
      icon: Icons.history_edu_rounded,
      title: 'Legacy Since 1998',
      subtitle: 'Unit of Bedi College of Physics, Amritsar',
    ),
    SplashHighlight(
      icon: Icons.biotech_rounded,
      title: 'Er. Bedi Sir’s Physics',
      subtitle: 'Conceptual Clarity for CBSE, NEET & JEE',
    ),
    SplashHighlight(
      icon: Icons.school_rounded,
      title: 'Classes 6th to 12th',
      subtitle: 'Comprehensive Science & Mathematics Foundation',
    ),
    SplashHighlight(
      icon: Icons.verified_user_rounded,
      title: 'Smart Digital Campus',
      subtitle: 'Real-time Attendance, Tests, Notes & Fees',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _startDynamicCycle();
  }

  void _startDynamicCycle() {
    // Cycle highlights every 1400 milliseconds for dynamic vibrancy
    _highlightTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (activeHighlightIndex.value < highlights.length - 1) {
        activeHighlightIndex.value++;
      } else {
        activeHighlightIndex.value = 0;
      }
    });

    // Dynamic staged progress simulation
    const int totalSteps = 100;
    const Duration stepDuration = Duration(milliseconds: 28); // ~2.8 seconds total
    int currentStep = 0;

    _progressTimer = Timer.periodic(stepDuration, (timer) {
      currentStep++;
      final double normalized = (currentStep / totalSteps).clamp(0.0, 1.0);
      progress.value = normalized;

      // Dynamically update status message based on progress stages
      if (normalized < 0.25) {
        statusMessage.value = 'Connecting to Radiance Cloud...';
      } else if (normalized < 0.50) {
        statusMessage.value = 'Synchronizing Academic Curricula...';
      } else if (normalized < 0.75) {
        statusMessage.value = 'Loading Faculty & Student Gateways...';
      } else if (normalized < 0.95) {
        statusMessage.value = 'Applying 256-Bit SSL Security...';
      } else {
        statusMessage.value = 'Welcome to Radiance Institute!';
      }

      if (currentStep >= totalSteps) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 350), () {
          navigateNext();
        });
      }
    });
  }

  /// Allows user to bypass splash screen immediately
  void skip() {
    _cleanupTimers();
    navigateNext();
  }

  /// Determines destination based on active authentication state
  void navigateNext() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    _cleanupTimers();

    final currentUser = authRepo.currentUser;

    if (currentUser != null) {
      _routeForRole(currentUser.role);
    } else {
      Get.offAllNamed(AppRoutes.intro);
    }
  }

  void _routeForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        Get.offAllNamed(AppRoutes.adminDashboard);
        break;
      case UserRole.student:
        Get.offAllNamed(AppRoutes.studentDashboard);
        break;
      case UserRole.parent:
        Get.offAllNamed(AppRoutes.parentDashboard);
        break;
      case UserRole.teacher:
        Get.offAllNamed(AppRoutes.teacherDashboard);
        break;
    }
  }

  void _cleanupTimers() {
    _progressTimer?.cancel();
    _highlightTimer?.cancel();
  }

  @override
  void onClose() {
    _cleanupTimers();
    super.onClose();
  }
}
