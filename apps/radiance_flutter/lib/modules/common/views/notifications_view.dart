import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';

class NotificationsView extends GetView<NotificationController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    final userRole = authController?.currentUser.value?.role.name.toUpperCase() ?? '';
    final canBroadcast = userRole == 'ADMIN' || userRole == 'TEACHER';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: RadianceAppBar(
        title: 'Notifications & Alerts',
        subtitle: 'Institute Announcements & Deadlines',
        showNotification: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: AppColors.pureWhite),
            tooltip: 'Mark All as Read',
            onPressed: controller.markAllAsRead,
          ),
        ],
      ),
      floatingActionButton: canBroadcast
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryRoyalBlue,
              foregroundColor: AppColors.pureWhite,
              icon: const Icon(Icons.campaign_outlined),
              label: Text(
                'Broadcast Notice',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              onPressed: () => _showBroadcastDialog(context),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filtered = controller.filteredNotifications;

        return Column(
          children: [
            // Category Filter Pills
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.pureWhite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ALL', 'All Updates'),
                    const SizedBox(width: 8),
                    _buildFilterChip('ANNOUNCEMENT', 'Announcements'),
                    const SizedBox(width: 8),
                    _buildFilterChip('FEE', 'Fee Alerts'),
                    const SizedBox(width: 8),
                    _buildFilterChip('RESULT', 'Exam Results'),
                    const SizedBox(width: 8),
                    _buildFilterChip('HOMEWORK', 'Homework'),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),

            // Notification List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none, size: 54, color: AppColors.textMuted.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No notifications found',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You are completely caught up!',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final notif = filtered[index];
                        final isUnread = !notif.read;

                        return RadianceCard(
                          onTap: () => controller.markAsRead(notif.notificationId),
                          backgroundColor: isUnread ? AppColors.lightBlueBackground.withOpacity(0.35) : AppColors.pureWhite,
                          border: isUnread
                              ? Border.all(color: AppColors.primaryRoyalBlue.withOpacity(0.4), width: 1.2)
                              : Border.all(color: AppColors.borderSubtle, width: 1),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _categoryColor(notif.category).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _categoryIcon(notif.category),
                                  color: _categoryColor(notif.category),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notif.title,
                                            style: GoogleFonts.outfit(
                                              fontSize: 15,
                                              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                                              color: AppColors.deepNavy,
                                            ),
                                          ),
                                        ),
                                        if (isUnread)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primaryRoyalBlue,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notif.body,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _categoryColor(notif.category).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            notif.category,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: _categoryColor(notif.category),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                                          tooltip: 'Dismiss',
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          onPressed: () => controller.deleteNotification(notif.notificationId),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == key;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryRoyalBlue,
        backgroundColor: AppColors.backgroundLight,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
        ),
        onSelected: (_) => controller.selectedCategory.value = key,
      );
    });
  }

  Color _categoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'FEE':
        return AppColors.warning;
      case 'RESULT':
        return AppColors.accentGold;
      case 'HOMEWORK':
        return AppColors.info;
      case 'ATTENDANCE':
        return AppColors.success;
      case 'ANNOUNCEMENT':
      default:
        return AppColors.primaryRoyalBlue;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'FEE':
        return Icons.account_balance_wallet_outlined;
      case 'RESULT':
        return Icons.analytics_outlined;
      case 'HOMEWORK':
        return Icons.assignment_outlined;
      case 'ATTENDANCE':
        return Icons.calendar_today_outlined;
      case 'ANNOUNCEMENT':
      default:
        return Icons.campaign_outlined;
    }
  }

  void _showBroadcastDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Text(
          'Broadcast Notice',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.deepNavy),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Notice Title',
                  hintText: 'e.g. Diwal Holiday Schedule & Revision Classes',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.bodyController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Message Body',
                  hintText: 'Enter complete announcement message...',
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedBroadcastCategory.value,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(value: 'ANNOUNCEMENT', child: Text('General Announcement')),
                      DropdownMenuItem(value: 'ACADEMIC', child: Text('Academic Schedule')),
                      DropdownMenuItem(value: 'FEE', child: Text('Fee Reminder')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.selectedBroadcastCategory.value = val;
                    },
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: controller.broadcastAnnouncement,
            child: const Text('Send Broadcast'),
          ),
        ],
      ),
    );
  }
}
