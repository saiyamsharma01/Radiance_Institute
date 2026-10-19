import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../data/models/user_model.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isPasswordVisible = false.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Ambient decorative background gradients
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryRoyalBlue.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentGold.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 460 : 410),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Branded Crest Header
                      Center(
                        child: Container(
                          width: 88,
                          height: 88,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.accentGold, AppColors.primaryRoyalBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryRoyalBlue.withOpacity(0.2),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.pureWhite,
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/radiance_logo.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.school,
                                size: 44,
                                color: AppColors.primaryRoyalBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Institution Title & Accents
                      Text(
                        AppStrings.appName,
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.deepNavy,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.accentGold.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 12, color: AppColors.accentGold),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.tagline,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentGold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Text(
                        'Amritsar Campus • CBSE & Competitive Prep',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Main Login Card
                      RadianceCard(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card Header Banner
                            Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlueBackground,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.lock_person_outlined, color: AppColors.primaryRoyalBlue, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Institute Portal Sign In',
                                        style: GoogleFonts.outfit(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.deepNavy,
                                        ),
                                      ),
                                      Text(
                                        'Enter your institute credentials to continue',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),

                            // Username / Email input
                            TextField(
                              controller: controller.emailOrPhoneController,
                              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Email or Mobile Number',
                                hintText: 'e.g. admin@radiance.edu.in',
                                prefixIcon: const Icon(Icons.alternate_email, size: 20, color: AppColors.textMuted),
                                filled: true,
                                fillColor: AppColors.lightBlueBackground.withOpacity(0.35),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primaryRoyalBlue, width: 1.8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Password input with visibility toggle
                            Obx(() => TextField(
                                  controller: controller.passwordController,
                                  obscureText: !isPasswordVisible.value,
                                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: '••••••••',
                                    prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textMuted),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                        size: 20,
                                        color: AppColors.textMuted,
                                      ),
                                      onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.lightBlueBackground.withOpacity(0.35),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.borderSubtle),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.borderSubtle),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.primaryRoyalBlue, width: 1.8),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 12),

                            // Error message display
                            Obx(() {
                              if (controller.errorMessage.isEmpty) return const SizedBox.shrink();
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.errorLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, size: 18, color: AppColors.error),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        controller.errorMessage.value,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.error,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            // Sign In Button
                            Obx(() => RadianceButton(
                                  label: 'Sign In to Portal',
                                  icon: Icons.login,
                                  onPressed: controller.login,
                                  isLoading: controller.isLoading.value,
                                )),
                            const SizedBox(height: 16),

                            // Divider
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'OR QUICK ACCESS',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Parent Phone OTP Button
                            RadianceButton(
                              label: 'Parent OTP Login',
                              icon: Icons.phone_android,
                              isOutlined: true,
                              onPressed: () => Get.toNamed(AppRoutes.parentOtp),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Demo Role Switcher (Executive Tile Layout)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderSubtle),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryRoyalBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.bolt, size: 16, color: AppColors.primaryRoyalBlue),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'DEMO QUICK ROLE SWITCHER',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: AppColors.deepNavy,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // 4 Grid Action Tiles
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 2.2,
                              children: [
                                _buildRoleCard('Admin', 'Governance', Icons.admin_panel_settings_outlined, AppColors.deepNavy, UserRole.admin),
                                _buildRoleCard('Student', 'Academics', Icons.school_outlined, AppColors.primaryRoyalBlue, UserRole.student),
                                _buildRoleCard('Parent', 'Fees & Growth', Icons.family_restroom_outlined, AppColors.accentGold, UserRole.parent),
                                _buildRoleCard('Teacher', 'Attendance & Tests', Icons.psychology_outlined, AppColors.info, UserRole.teacher),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Contact footer
                      Text(
                        '🔒 256-Bit SSL Encrypted Enterprise Portal\n${AppStrings.address} • Phone: ${AppStrings.phone}',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, height: 1.45),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(String title, String subtitle, IconData icon, Color color, UserRole role) {
    return InkWell(
      onTap: () => controller.switchRole(role),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

