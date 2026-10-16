class SubmissionModel {
  final String submissionId;
  final String homeworkId;
  final String studentId;
  final String studentName;
  final List<String> resourcePaths;
  final DateTime submittedAt;
  final String status; // 'SUBMITTED' | 'LATE' | 'GRADED'
  final String? feedback;
  final double? score;

  SubmissionModel({
    required this.submissionId,
    required this.homeworkId,
    required this.studentId,
    required this.studentName,
    this.resourcePaths = const [],
    required this.submittedAt,
    this.status = 'SUBMITTED',
    this.feedback,
    this.score,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      submissionId: json['submissionId'] ?? '',
      homeworkId: json['homeworkId'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      resourcePaths: List<String>.from(json['resourcePaths'] ?? []),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'].toString())
          : DateTime.now(),
      status: json['status'] ?? 'SUBMITTED',
      feedback: json['feedback'],
      score: (json['score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submissionId': submissionId,
      'homeworkId': homeworkId,
      'studentId': studentId,
      'studentName': studentName,
      'resourcePaths': resourcePaths,
      'submittedAt': submittedAt.toIso8601String(),
      'status': status,
      'feedback': feedback,
      'score': score,
    };
  }
}

class HomeworkModel {
  final String homeworkId;
  final String batchId;
  final String batchName;
  final String subject;
  final String title;
  final String description;
  final List<String> resourcePaths;
  final DateTime deadline;
  final String createdBy;
  final DateTime createdAt;
  final List<SubmissionModel> submissions;

  HomeworkModel({
    required this.homeworkId,
    required this.batchId,
    required this.batchName,
    required this.subject,
    required this.title,
    required this.description,
    this.resourcePaths = const [],
    required this.deadline,
    required this.createdBy,
    required this.createdAt,
    this.submissions = const [],
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      homeworkId: json['homeworkId'] ?? '',
      batchId: json['batchId'] ?? '',
      batchName: json['batchName'] ?? '',
      subject: json['subject'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      resourcePaths: List<String>.from(json['resourcePaths'] ?? []),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'].toString())
          : DateTime.now().add(const Duration(days: 2)),
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      submissions: (json['submissions'] as List<dynamic>? ?? [])
          .map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'homeworkId': homeworkId,
      'batchId': batchId,
      'batchName': batchName,
      'subject': subject,
      'title': title,
      'description': description,
      'resourcePaths': resourcePaths,
      'deadline': deadline.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'submissions': submissions.map((e) => e.toJson()).toList(),
    };
  }
}
