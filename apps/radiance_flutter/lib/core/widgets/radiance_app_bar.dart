import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import 'radiance_logo_badge.dart';
import '../../data/models/user_model.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/common/controllers/notification_controller.dart';

class RadianceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showNotification;
  final bool showRoleSwitcher;
  final bool? showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onLogout;

  const RadianceAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showNotification = true,
    this.showRoleSwitcher = true,
    this.showBackButton,
    this.onBack,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }

    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    // Contextual intelligent fallback if backstack was ever cleared
    final currentRoute = Get.currentRoute;
    if (currentRoute == AppRoutes.studentAttendance ||
        currentRoute == AppRoutes.studentHomework ||
        currentRoute == AppRoutes.studentTests ||
        currentRoute == AppRoutes.studentFees) {
      Get.offNamed(AppRoutes.studentDashboard);
    } else if (currentRoute == AppRoutes.markAttendance ||
               currentRoute == AppRoutes.createHomework) {
      Get.offNamed(AppRoutes.teacherDashboard);
    } else if (currentRoute == AppRoutes.parentChildLinking ||
               currentRoute == AppRoutes.parentFees) {
      Get.offNamed(AppRoutes.parentDashboard);
    } else if (currentRoute == AppRoutes.notifications) {
      final user = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>().currentUser.value
          : null;
      if (user?.role == UserRole.student) {
        Get.offNamed(AppRoutes.studentDashboard);
      } else if (user?.role == UserRole.teacher) {
        Get.offNamed(AppRoutes.teacherDashboard);
      } else if (user?.role == UserRole.parent) {
        Get.offNamed(AppRoutes.parentDashboard);
      } else if (user?.role == UserRole.admin) {
        Get.offNamed(AppRoutes.adminDashboard);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPopNavigator = Navigator.of(context).canPop();
    final canPopGet = Get.key.currentState?.canPop() ?? false;
    final hasPrevious = Get.previousRoute.isNotEmpty && Get.previousRoute != AppRoutes.splash;
    final shouldShowBack = showBackButton ?? (canPopNavigator || canPopGet || hasPrevious);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.deepNavy, AppColors.primaryRoyalBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F172B4D),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (shouldShowBack)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.pureWhite, size: 20),
                  tooltip: 'Back',
                  onPressed: () => _handleBack(context),
                )
              else
                // Official Radiance Institute logo brand mark with signature golden-royal rim
                const Padding(
                  padding: EdgeInsets.only(left: 4, right: 8),
                  child: RadianceLogoBadge(size: 38),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pureWhite,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.lightBlueBackground.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              if (showRoleSwitcher && Get.isRegistered<AuthController>())
                PopupMenuButton<UserRole>(
                  tooltip: 'Switch Portal Role',
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.25), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.swap_horiz, color: AppColors.pureWhite, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Role',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.pureWhite),
                        ),
                      ],
                    ),
                  ),
                  onSelected: (role) {
                    Get.find<AuthController>().switchRole(role);
                  },
                  itemBuilder: (context) => [
                    _buildRoleMenuItem(UserRole.student, 'Student Portal', Icons.school),
                    _buildRoleMenuItem(UserRole.parent, 'Parent Portal', Icons.family_restroom),
                    _buildRoleMenuItem(UserRole.teacher, 'Faculty Portal', Icons.psychology),
                    _buildRoleMenuItem(UserRole.admin, 'Admin Portal', Icons.admin_panel_settings),
                  ],
                ),
              if (showNotification)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: AppColors.pureWhite, size: 22),
                      tooltip: 'Notifications',
                      onPressed: () => Get.toNamed(AppRoutes.notifications),
                    ),
                    if (Get.isRegistered<NotificationController>())
                      Obx(() {
                        final unread = Get.find<NotificationController>().unreadCount;
                        if (unread == 0) return const SizedBox.shrink();
                        return Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Center(
                              child: Text(
                                unread > 9 ? '9+' : unread.toString(),
                                style: GoogleFonts.inter(
                                  color: AppColors.pureWhite,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              if (actions != null) ...actions!,
              if (onLogout != null)
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.pureWhite, size: 20),
                  tooltip: 'Logout',
                  onPressed: onLogout,
                ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<UserRole> _buildRoleMenuItem(UserRole role, String title, IconData icon) {
    return PopupMenuItem(
      value: role,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryRoyalBlue),
          const SizedBox(width: 10),
          Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
        ],
      ),
    );
  }
}
