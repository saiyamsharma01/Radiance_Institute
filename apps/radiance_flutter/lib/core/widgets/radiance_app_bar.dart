import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../../data/models/user_model.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/common/controllers/notification_controller.dart';

class RadianceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showNotification;
  final bool showRoleSwitcher;
  final VoidCallback? onLogout;

  const RadianceAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showNotification = true,
    this.showRoleSwitcher = true,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
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
              if (Navigator.canPop(context))
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.pureWhite, size: 20),
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              else
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
                          color: AppColors.lightBlueBackground.withOpacity(0.9),
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
                      color: AppColors.pureWhite.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.pureWhite.withOpacity(0.25), width: 1),
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
                                  fontWeight: FontWeight.w800,
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
