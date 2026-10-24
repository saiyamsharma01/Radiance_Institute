import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/radiance_logo_badge.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isPasswordVisible = false.obs;
    final selectedTab = 0.obs; // 0: Super Admin, 1: Academic (Student/Faculty), 2: Parent OTP
    final rememberMe = true.obs;

    void handleBack() {
      if (Get.key.currentState?.canPop() ?? false) {
        Get.back();
      } else if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Get.offAllNamed(AppRoutes.intro);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        handleBack();
      },
      child: Scaffold(
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
                      AppColors.primaryRoyalBlue.withValues(alpha: 0.12),
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
                      AppColors.accentGold.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Top Back Navigation Button
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextButton.icon(
                    onPressed: handleBack,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.pureWhite,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                      elevation: 1,
                      shadowColor: Colors.black.withValues(alpha: 0.08),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.deepNavy),
                    label: Text(
                      'Intro',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepNavy,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main Scrollable Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isDesktop ? 460 : 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Branded Crest Header
                        const Center(
                          child: RadianceLogoBadge(size: 82, borderWidth: 3.5),
                        ),
                        const SizedBox(height: 12),

                        // Institution Title & Accents
                        Text(
                          AppStrings.appName,
                          style: GoogleFonts.outfit(
                            fontSize: 25,
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
                                color: AppColors.accentGold.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 12, color: AppColors.accentGold),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppStrings.tagline,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
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
                        const SizedBox(height: 4),

                        Text(
                          'Amritsar Campus • CBSE & Competitive Prep',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),

                        // 1. Interactive Role Segment Selector (Mobile-Optimized)
                        Obx(() => Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.pureWhite,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.borderSubtle),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  _buildRoleTab(
                                    label: 'Admin',
                                    icon: Icons.admin_panel_settings_rounded,
                                    isSelected: selectedTab.value == 0,
                                    onTap: () {
                                      selectedTab.value = 0;
                                      controller.errorMessage.value = '';
                                    },
                                  ),
                                  _buildRoleTab(
                                    label: 'Academic',
                                    icon: Icons.school_rounded,
                                    isSelected: selectedTab.value == 1,
                                    onTap: () {
                                      selectedTab.value = 1;
                                      controller.errorMessage.value = '';
                                    },
                                  ),
                                  _buildRoleTab(
                                    label: 'Parent OTP',
                                    icon: Icons.phone_iphone_rounded,
                                    isSelected: selectedTab.value == 2,
                                    onTap: () {
                                      selectedTab.value = 2;
                                      controller.errorMessage.value = '';
                                    },
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 14),

                        // 2. Main Login Card
                        RadianceCard(
                          padding: const EdgeInsets.all(20),
                          child: Obx(() {
                            final currentTab = selectedTab.value;

                            if (currentTab == 2) {
                              // Parent OTP Mode
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.accentGold.withValues(alpha: 0.14),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.family_restroom, color: AppColors.accentGold, size: 22),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Parent OTP Access',
                                              style: GoogleFonts.outfit(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.deepNavy,
                                              ),
                                            ),
                                            Text(
                                              'Enter registered mobile for instant OTP',
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
                                  const Divider(height: 22),
                                  TextField(
                                    controller: controller.phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number',
                                      hintText: '9876543210',
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        child: Text(
                                          '+91',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.deepNavy,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                      filled: true,
                                      fillColor: AppColors.lightBlueBackground.withValues(alpha: 0.35),
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
                                  RadianceButton(
                                    label: 'Proceed to OTP Verification',
                                    icon: Icons.arrow_forward_rounded,
                                    onPressed: () => Get.toNamed(AppRoutes.parentOtp),
                                  ),
                                ],
                              );
                            }

                            // Admin or Student/Faculty Mode
                            final isAdmin = currentTab == 0;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Card Header Banner
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isAdmin
                                              ? [AppColors.deepNavy, AppColors.primaryRoyalBlue]
                                              : [AppColors.primaryRoyalBlue, AppColors.info],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (isAdmin ? AppColors.deepNavy : AppColors.primaryRoyalBlue).withValues(alpha: 0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isAdmin ? Icons.admin_panel_settings_rounded : Icons.school_rounded,
                                        color: AppColors.pureWhite,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                isAdmin ? 'Super Admin Portal' : 'Academic Portal',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.deepNavy,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              if (isAdmin)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.accentGold.withValues(alpha: 0.15),
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5)),
                                                  ),
                                                  child: Text(
                                                    'EXECUTIVE',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w800,
                                                      color: AppColors.accentGold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            isAdmin
                                                ? 'Institutional Governance & Command Console'
                                                : 'Students & Faculty Member Authentication',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 22),

                                const SizedBox(height: 4),

                                // Username / Email input
                                TextField(
                                  controller: controller.emailOrPhoneController,
                                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                                  decoration: InputDecoration(
                                    labelText: 'Email or Username',
                                    hintText: isAdmin ? 'admin@radiance.edu.in' : 'student@radiance.edu.in',
                                    prefixIcon: const Icon(Icons.alternate_email, size: 20, color: AppColors.textMuted),
                                    filled: true,
                                    fillColor: AppColors.lightBlueBackground.withValues(alpha: 0.35),
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
                                        fillColor: AppColors.lightBlueBackground.withValues(alpha: 0.35),
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

                                const SizedBox(height: 8),

                                // Remember Me & Forgot Password Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => InkWell(
                                          onTap: () => rememberMe.value = !rememberMe.value,
                                          borderRadius: BorderRadius.circular(6),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child: Checkbox(
                                                    value: rememberMe.value,
                                                    onChanged: (v) => rememberMe.value = v ?? false,
                                                    activeColor: AppColors.primaryRoyalBlue,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Remember me',
                                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    TextButton(
                                      onPressed: () {
                                        Get.dialog(
                                          Dialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(22),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: AppColors.lightBlueBackground,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: const Icon(Icons.help_outline, color: AppColors.primaryRoyalBlue, size: 22),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          'Credential Helpdesk',
                                                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 14),
                                                  Text(
                                                    'For security and student record safety, login passwords are administered by the Radiance Campus IT / Admin Desk.',
                                                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary, height: 1.45),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.lightBlueBackground.withValues(alpha: 0.5),
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: AppColors.borderSubtle),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('📞 Campus Helpline: ${AppStrings.phone}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
                                                        const SizedBox(height: 4),
                                                        Text('📧 IT Helpdesk: admin@radiance.edu.in', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
                                                        const SizedBox(height: 4),
                                                        Text('📍 Rani Ka Bagh, Amritsar', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 18),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      onPressed: () => Get.back(),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppColors.deepNavy,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                                      ),
                                                      child: Text('Understood', style: GoogleFonts.inter(color: AppColors.pureWhite, fontWeight: FontWeight.w600)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Forgot password?',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryRoyalBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
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
                                      label: isAdmin ? 'Authenticate Administrator' : 'Sign In to Academic Portal',
                                      icon: isAdmin ? Icons.security_rounded : Icons.login_rounded,
                                      onPressed: controller.login,
                                      isLoading: controller.isLoading.value,
                                    )),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 18),

                        // Enterprise Security & Campus Contact Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderSubtle),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock_outline_rounded, size: 15, color: AppColors.primaryRoyalBlue),
                                  const SizedBox(width: 6),
                                  Text(
                                    '256-Bit SSL Enterprise Protected',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepNavy,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'VERIFIED',
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${AppStrings.address}\nSupport Desk: ${AppStrings.phone} • Email: ${AppStrings.email}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.deepNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.deepNavy.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.accentGold : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppColors.pureWhite : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
