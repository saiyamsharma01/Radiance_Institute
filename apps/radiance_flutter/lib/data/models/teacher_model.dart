class TeacherModel {
  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final List<String> subjects;
  final List<String> assignedBatchIds;

  TeacherModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.subjects,
    required this.assignedBatchIds,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      uid: json['uid'] ?? '',
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []),
      assignedBatchIds: List<String>.from(json['assignedBatchIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'subjects': subjects,
      'assignedBatchIds': assignedBatchIds,
    };
  }
}
