import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';

class IntroSlideModel {
  final String title;
  final String tag;
  final String description;
  final IconData primaryIcon;
  final List<String> highlights;
  final Color accentColor;
  final Color secondaryColor;

  const IntroSlideModel({
    required this.title,
    required this.tag,
    required this.description,
    required this.primaryIcon,
    required this.highlights,
    required this.accentColor,
    required this.secondaryColor,
  });
}

class IntroController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<IntroSlideModel> slides = const [
    IntroSlideModel(
      title: 'Er. Bedi Sir’s Renowned Physics Mentorship',
      tag: 'HERITAGE SINCE 1998',
      description:
          'Transforming complex Physics into intuitive concepts. 26+ years of proven pedagogy delivering top ranks in CBSE Boards, NEET, and JEE.',
      primaryIcon: Icons.biotech_rounded,
      highlights: [
        'Direct Classroom Mentorship by Er. Bedi Sir',
        'Conceptual Derivations & Numerical Mastery',
        'Small Focused Batches & Dedicated Doubt Clearing',
      ],
      accentColor: Color(0xFF2563EB),
      secondaryColor: Color(0xFF1E3A8A),
    ),
    IntroSlideModel(
      title: 'Comprehensive Coaching: Classes 6th to 12th',
      tag: 'ACADEMIC FOUNDATION',
      description:
          'Solid groundwork for junior standards (6th–10th all subjects) and specialized Senior Secondary streams in Physics, Chemistry, and Mathematics.',
      primaryIcon: Icons.school_rounded,
      highlights: [
        'Class 6th–10th Science & Math Excellence',
        'Class 11th–12th Medical & Non-Medical Wings',
        'Structured Study Material & Daily Practice Sheets',
      ],
      accentColor: Color(0xFFD97706),
      secondaryColor: Color(0xFFB45309),
    ),
    IntroSlideModel(
      title: 'Smart Digital Institute Management',
      tag: 'CUTTING-EDGE PORTAL',
      description:
          'Experience an integrated digital campus ecosystem with instantaneous RFID/app attendance logging, instant test analytics, and daily homework tracking.',
      primaryIcon: Icons.devices_rounded,
      highlights: [
        'Instant Attendance & Absentee Notifications',
        'Comprehensive Test Performance Analytics',
        'Digital Notes & Homework Submission Hub',
      ],
      accentColor: Color(0xFF0D9488),
      secondaryColor: Color(0xFF0F766E),
    ),
    IntroSlideModel(
      title: 'Transparent Parent Synergy & Fee Ledgers',
      tag: 'TRUST & ENGAGEMENT',
      description:
          'Parents stay informed with one-touch mobile OTP access, automated fee installment notifications, digital receipt generation, and teacher feedback.',
      primaryIcon: Icons.family_restroom_rounded,
      highlights: [
        'Passwordless Mobile Phone OTP Login',
        'Automated Fee Invoices & Downloadable Receipts',
        'Real-time WhatsApp & In-App Security Alerts',
      ],
      accentColor: Color(0xFF4F46E5),
      secondaryColor: Color(0xFF3730A3),
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      navigateToLogin();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void navigateToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
