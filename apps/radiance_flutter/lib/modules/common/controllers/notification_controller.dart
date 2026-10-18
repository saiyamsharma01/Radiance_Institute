import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/institute_repository.dart';

class NotificationController extends GetxController {
  final IInstituteRepository repository;

  NotificationController({required this.repository});

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxString selectedCategory = 'ALL'.obs;
  final RxBool isLoading = false.obs;

  // New broadcast announcement form
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final selectedBroadcastCategory = 'ANNOUNCEMENT'.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      if (notifications.isEmpty) isLoading.value = true;
      notifications.value = await repository.getNotifications();
    } finally {
      isLoading.value = false;
    }
  }

  int get unreadCount => notifications.where((n) => !n.read).length;

  List<NotificationModel> get filteredNotifications {
    if (selectedCategory.value == 'ALL') return notifications;
    return notifications.where((n) => n.category.toUpperCase() == selectedCategory.value.toUpperCase()).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await repository.markNotificationAsRead(notificationId);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await repository.markAllNotificationsAsRead();
    await loadNotifications();
    Get.snackbar('All Read', 'Marked all notifications as read.');
  }

  Future<void> deleteNotification(String notificationId) async {
    await repository.deleteNotification(notificationId);
    await loadNotifications();
  }

  Future<void> broadcastAnnouncement() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      Get.snackbar('Error', 'Please enter announcement title and message.');
      return;
    }

    final newNotif = NotificationModel(
      notificationId: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: selectedBroadcastCategory.value,
      createdAt: DateTime.now(),
      read: false,
    );

    await repository.addNotification(newNotif);
    await loadNotifications();
    titleController.clear();
    bodyController.clear();
    Get.back();
    Get.snackbar('Broadcast Sent', 'Announcement sent to students, parents, and faculty.');
  }

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    super.onClose();
  }
}
