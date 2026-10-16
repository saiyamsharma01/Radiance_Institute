import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../controllers/parent_controller.dart';

class ParentChildLinkingView extends GetView<ParentController> {
  const ParentChildLinkingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const RadianceAppBar(
        title: 'Link Student Account',
        subtitle: 'Cryptographic Student Association Challenge',
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
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
                      Icons.family_restroom,
                      color: AppColors.primaryRoyalBlue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Link Your Child',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'To protect student privacy, parent verification requires matching the institute-assigned Roll Number and official Date of Birth.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Roll number field
                  TextField(
                    controller: controller.rollNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Student Roll Number',
                      hintText: 'e.g. RAD12-019',
                      prefixIcon: Icon(Icons.badge_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // DOB field
                  TextField(
                    controller: controller.dobController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth (YYYY-MM-DD)',
                      hintText: 'e.g. 2008-09-22',
                      prefixIcon: Icon(Icons.cake_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Demo hints box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Test Hint: Try Roll "RAD12-019" with DOB "2008-09-22" (Simran Kaur, Class 12).',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.primaryRoyalBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Obx(() {
                    if (controller.linkingMessage.isEmpty) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        controller.linkingMessage.value,
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
                      ),
                    );
                  }),

                  Obx(() => RadianceButton(
                        label: 'Verify & Link Child',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.linkStudent,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
