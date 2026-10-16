class AdmissionEnquiryModel {
  final String enquiryId;
  final String studentName;
  final String guardianName;
  final String contactNumber;
  final String classLevel;
  final String academicYear;
  final List<String> subjectIds;
  final String preferredCallbackTime;
  final String message;
  final String status; // 'NEW' | 'CONTACTED' | 'VISIT_SCHEDULED' | 'ADMITTED' | 'CLOSED'
  final DateTime createdAt;

  AdmissionEnquiryModel({
    required this.enquiryId,
    required this.studentName,
    required this.guardianName,
    required this.contactNumber,
    required this.classLevel,
    required this.academicYear,
    this.subjectIds = const [],
    this.preferredCallbackTime = 'Anytime',
    this.message = '',
    this.status = 'NEW',
    required this.createdAt,
  });

  factory AdmissionEnquiryModel.fromJson(Map<String, dynamic> json) {
    return AdmissionEnquiryModel(
      enquiryId: json['enquiryId'] ?? '',
      studentName: json['studentName'] ?? '',
      guardianName: json['guardianName'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      classLevel: json['classLevel'] ?? '11',
      academicYear: json['academicYear'] ?? '2026-2027',
      subjectIds: List<String>.from(json['subjectIds'] ?? []),
      preferredCallbackTime: json['preferredCallbackTime'] ?? 'Anytime',
      message: json['message'] ?? '',
      status: json['status'] ?? 'NEW',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enquiryId': enquiryId,
      'studentName': studentName,
      'guardianName': guardianName,
      'contactNumber': contactNumber,
      'classLevel': classLevel,
      'academicYear': academicYear,
      'subjectIds': subjectIds,
      'preferredCallbackTime': preferredCallbackTime,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
