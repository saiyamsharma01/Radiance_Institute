class AttendanceModel {
  final String attendanceId; // Deterministic: `${batchId}_${date}_${studentId}`
  final String batchId;
  final String studentId;
  final String studentName;
  final String date; // "YYYY-MM-DD"
  final String status; // 'PRESENT' | 'ABSENT' | 'LATE' | 'EXCUSED'
  final String markedBy;
  final DateTime markedAt;
  final String correctionStatus;
  final String? correctionNotes;

  AttendanceModel({
    required this.attendanceId,
    required this.batchId,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.status,
    required this.markedBy,
    required this.markedAt,
    this.correctionStatus = 'NONE',
    this.correctionNotes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: json['attendanceId'] ?? '',
      batchId: json['batchId'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'PRESENT',
      markedBy: json['markedBy'] ?? '',
      markedAt: json['markedAt'] != null
          ? DateTime.parse(json['markedAt'].toString())
          : DateTime.now(),
      correctionStatus: json['correctionStatus'] ?? 'NONE',
      correctionNotes: json['correctionNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'batchId': batchId,
      'studentId': studentId,
      'studentName': studentName,
      'date': date,
      'status': status,
      'markedBy': markedBy,
      'markedAt': markedAt.toIso8601String(),
      'correctionStatus': correctionStatus,
      'correctionNotes': correctionNotes,
    };
  }

  static String generateId(String batchId, String date, String studentId) {
    return '${batchId}_${date}_$studentId';
  }
}
