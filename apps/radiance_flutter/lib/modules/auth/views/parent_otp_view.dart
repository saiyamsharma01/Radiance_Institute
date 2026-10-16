import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../controllers/auth_controller.dart';

class ParentOtpView extends GetView<AuthController> {
  const ParentOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool otpSent = false.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Parent Mobile Verification',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: RadianceCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primaryRoyalBlue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Secure Parent Sign-In',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter your registered phone number. A 6-digit one-time password (OTP) will be verified.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Phone number input
                  TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Registered Mobile Number',
                      hintText: '+91 98140 12345',
                      prefixIcon: Icon(Icons.phone_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // OTP field (revealed once OTP is requested)
                  Obx(() {
                    if (!otpSent.value) {
                      return RadianceButton(
                        label: 'Send Verification Code',
                        onPressed: () {
                          if (controller.phoneController.text.trim().isNotEmpty) {
                            otpSent.value = true;
                            controller.otpController.text = '123456'; // Pre-filled sandbox OTP
                          }
                        },
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: controller.otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: const InputDecoration(
                            labelText: 'Enter 6-Digit OTP',
                            hintText: '123456',
                            prefixIcon: Icon(Icons.lock_clock_outlined, size: 20),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sandbox Note: Demo OTP "123456" is pre-filled for testing.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        RadianceButton(
                          label: 'Verify OTP & Enter',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.verifyParentOtp,
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => otpSent.value = false,
                          child: Text(
                            'Change Mobile Number',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.primaryRoyalBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.errorMessage.isEmpty) return const SizedBox.shrink();
                    return Text(
                      controller.errorMessage.value,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
