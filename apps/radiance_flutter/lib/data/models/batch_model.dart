class BatchSchedule {
  final String dayOfWeek;
  final String startTime; // "09:00"
  final String endTime;   // "10:30"
  final String room;

  BatchSchedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.room = 'Room 101',
  });

  factory BatchSchedule.fromJson(Map<String, dynamic> json) {
    return BatchSchedule(
      dayOfWeek: json['dayOfWeek'] ?? 'Monday',
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '10:30',
      room: json['room'] ?? 'Room 101',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
    };
  }
}

class BatchModel {
  final String batchId;
  final String name;
  final String classLevel; // "6" to "12"
  final String academicYear;
  final String subject; // "Physics", "Chemistry", "Mathematics", "General Tuition"
  final List<String> teacherUids;
  final List<BatchSchedule> schedule;
  final int enrolledStudentCount;
  final String status;

  BatchModel({
    required this.batchId,
    required this.name,
    required this.classLevel,
    required this.academicYear,
    required this.subject,
    required this.teacherUids,
    required this.schedule,
    this.enrolledStudentCount = 0,
    this.status = 'active',
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      batchId: json['batchId'] ?? '',
      name: json['name'] ?? '',
      classLevel: json['classLevel'] ?? '11',
      academicYear: json['academicYear'] ?? '2026-2027',
      subject: json['subject'] ?? 'General',
      teacherUids: List<String>.from(json['teacherUids'] ?? []),
      schedule: (json['schedule'] as List<dynamic>? ?? [])
          .map((e) => BatchSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      enrolledStudentCount: json['enrolledStudentCount'] ?? 0,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'name': name,
      'classLevel': classLevel,
      'academicYear': academicYear,
      'subject': subject,
      'teacherUids': teacherUids,
      'schedule': schedule.map((e) => e.toJson()).toList(),
      'enrolledStudentCount': enrolledStudentCount,
      'status': status,
    };
  }
}
