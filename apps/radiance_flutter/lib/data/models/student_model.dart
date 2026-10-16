class StudentModel {
  final String studentId;
  final String userUid;
  final String fullName;
  final String classLevel; // "6" to "12"
  final String academicYear;
  final String rollNumber;
  final String dateOfBirth; // YYYY-MM-DD
  final List<String> parentUids;
  final List<String> enrolledBatchIds;
  final String emergencyContact;
  final String status;

  StudentModel({
    required this.studentId,
    required this.userUid,
    required this.fullName,
    required this.classLevel,
    required this.academicYear,
    required this.rollNumber,
    required this.dateOfBirth,
    required this.parentUids,
    this.enrolledBatchIds = const [],
    required this.emergencyContact,
    this.status = 'active',
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['studentId'] ?? '',
      userUid: json['userUid'] ?? '',
      fullName: json['fullName'] ?? '',
      classLevel: json['classLevel'] ?? '11',
      academicYear: json['academicYear'] ?? '2026-2027',
      rollNumber: json['rollNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      parentUids: List<String>.from(json['parentUids'] ?? []),
      enrolledBatchIds: List<String>.from(json['enrolledBatchIds'] ?? []),
      emergencyContact: json['emergencyContact'] ?? '',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'userUid': userUid,
      'fullName': fullName,
      'classLevel': classLevel,
      'academicYear': academicYear,
      'rollNumber': rollNumber,
      'dateOfBirth': dateOfBirth,
      'parentUids': parentUids,
      'enrolledBatchIds': enrolledBatchIds,
      'emergencyContact': emergencyContact,
      'status': status,
    };
  }
}

class ParentModel {
  final String uid;
  final String displayName;
  final String verifiedPhone;
  final List<String> linkedStudentIds;
  final String accountStatus;

  ParentModel({
    required this.uid,
    required this.displayName,
    required this.verifiedPhone,
    required this.linkedStudentIds,
    this.accountStatus = 'active',
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      uid: json['uid'] ?? '',
      displayName: json['displayName'] ?? '',
      verifiedPhone: json['verifiedPhone'] ?? '',
      linkedStudentIds: List<String>.from(json['linkedStudentIds'] ?? []),
      accountStatus: json['accountStatus'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'verifiedPhone': verifiedPhone,
      'linkedStudentIds': linkedStudentIds,
      'accountStatus': accountStatus,
    };
  }
}
