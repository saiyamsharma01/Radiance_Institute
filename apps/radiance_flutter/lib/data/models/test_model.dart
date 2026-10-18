class ResultModel {
  final String resultId;
  final String testId;
  final String studentId;
  final String studentName;
  final double marksObtained;
  final double totalMarks;
  final double percentage;
  final String? feedback;
  final DateTime? publishedAt;
  final String? testTitle;
  final String? subject;
  final String? testDate;

  ResultModel({
    required this.resultId,
    required this.testId,
    required this.studentId,
    required this.studentName,
    required this.marksObtained,
    required this.totalMarks,
    required this.percentage,
    this.feedback,
    this.publishedAt,
    this.testTitle,
    this.subject,
    this.testDate,
  });

  ResultModel copyWith({
    String? resultId,
    String? testId,
    String? studentId,
    String? studentName,
    double? marksObtained,
    double? totalMarks,
    double? percentage,
    String? feedback,
    DateTime? publishedAt,
    String? testTitle,
    String? subject,
    String? testDate,
  }) {
    return ResultModel(
      resultId: resultId ?? this.resultId,
      testId: testId ?? this.testId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      marksObtained: marksObtained ?? this.marksObtained,
      totalMarks: totalMarks ?? this.totalMarks,
      percentage: percentage ?? this.percentage,
      feedback: feedback ?? this.feedback,
      publishedAt: publishedAt ?? this.publishedAt,
      testTitle: testTitle ?? this.testTitle,
      subject: subject ?? this.subject,
      testDate: testDate ?? this.testDate,
    );
  }

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    final obtained = (json['marksObtained'] as num?)?.toDouble() ?? 0.0;
    final total = (json['totalMarks'] as num?)?.toDouble() ?? 100.0;
    final pct = total > 0 ? (obtained / total) * 100.0 : 0.0;

    return ResultModel(
      resultId: json['resultId'] ?? '',
      testId: json['testId'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      marksObtained: obtained,
      totalMarks: total,
      percentage: double.parse(pct.toStringAsFixed(1)),
      feedback: json['feedback'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'].toString())
          : null,
      testTitle: json['testTitle'],
      subject: json['subject'],
      testDate: json['testDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': resultId,
      'testId': testId,
      'studentId': studentId,
      'studentName': studentName,
      'marksObtained': marksObtained,
      'totalMarks': totalMarks,
      'percentage': percentage,
      'feedback': feedback,
      'publishedAt': publishedAt?.toIso8601String(),
      'testTitle': testTitle,
      'subject': subject,
      'testDate': testDate,
    };
  }
}

class TestModel {
  final String testId;
  final String batchId;
  final String batchName;
  final String subject;
  final String title;
  final String testDate; // "YYYY-MM-DD"
  final double totalMarks;
  final String status; // 'SCHEDULED' | 'MARKS_ENTERED' | 'PUBLISHED'
  final List<ResultModel> results;

  TestModel({
    required this.testId,
    required this.batchId,
    required this.batchName,
    required this.subject,
    required this.title,
    required this.testDate,
    required this.totalMarks,
    this.status = 'SCHEDULED',
    this.results = const [],
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      testId: json['testId'] ?? '',
      batchId: json['batchId'] ?? '',
      batchName: json['batchName'] ?? '',
      subject: json['subject'] ?? '',
      title: json['title'] ?? '',
      testDate: json['testDate'] ?? '',
      totalMarks: (json['totalMarks'] as num?)?.toDouble() ?? 100.0,
      status: json['status'] ?? 'SCHEDULED',
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => ResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testId': testId,
      'batchId': batchId,
      'batchName': batchName,
      'subject': subject,
      'title': title,
      'testDate': testDate,
      'totalMarks': totalMarks,
      'status': status,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}
