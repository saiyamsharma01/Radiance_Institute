class NotificationModel {
  final String notificationId;
  final String title;
  final String body;
  final String category; // 'ATTENDANCE' | 'HOMEWORK' | 'RESULT' | 'FEE' | 'ENQUIRY' | 'ANNOUNCEMENT'
  final bool read;
  final DateTime createdAt;
  final String? route;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.category,
    this.read = false,
    required this.createdAt,
    this.route,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      category: json['category'] ?? 'ANNOUNCEMENT',
      read: json['read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      route: json['route'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'category': category,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      'route': route,
    };
  }
}
