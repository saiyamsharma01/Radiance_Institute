class AuditLogModel {
  final String logId;
  final String actorUid;
  final String actorRole; // 'ADMIN' | 'TEACHER' | 'PARENT' | 'STUDENT'
  final String action;
  final String resource;
  final DateTime timestamp;
  final String? details;

  AuditLogModel({
    required this.logId,
    required this.actorUid,
    required this.actorRole,
    required this.action,
    required this.resource,
    required this.timestamp,
    this.details,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      logId: json['logId'] ?? '',
      actorUid: json['actorUid'] ?? '',
      actorRole: json['actorRole'] ?? 'ADMIN',
      action: json['action'] ?? '',
      resource: json['resource'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'actorUid': actorUid,
      'actorRole': actorRole,
      'action': action,
      'resource': resource,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
    };
  }
}
