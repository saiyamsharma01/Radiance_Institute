import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';

class RadianceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showNotification;
  final VoidCallback? onLogout;

  const RadianceAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showNotification = true,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryRoyalBlue,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.pureWhite,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.lightBlueBackground,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
      actions: [
        if (showNotification)
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.pureWhite),
            tooltip: 'Notifications',
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
        if (actions != null) ...actions!,
        if (onLogout != null)
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.pureWhite),
            tooltip: 'Logout',
            onPressed: onLogout,
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
