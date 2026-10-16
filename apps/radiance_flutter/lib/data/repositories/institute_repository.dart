import 'dart:async';
import '../models/admission_enquiry_model.dart';
import '../models/attendance_model.dart';
import '../models/batch_model.dart';
import '../models/fee_models.dart';
import '../models/homework_model.dart';
import '../models/notification_model.dart';
import '../models/student_model.dart';
import '../models/test_model.dart';
import '../models/teacher_model.dart';
import 'mock_data_source.dart';

abstract class IInstituteRepository {
  // Batches & Subjects
  Future<List<BatchModel>> getBatches({String? classLevel, String? teacherUid});
  Future<void> createBatch(BatchModel batch);

  // Students & Teachers
  Future<List<StudentModel>> getStudents();
  Future<StudentModel?> getStudentById(String studentId);
  Future<void> createStudent(StudentModel student);
  Future<List<TeacherModel>> getTeachers();

  // Attendance
  Future<List<AttendanceModel>> getAttendanceForBatch(String batchId, String date);
  Future<List<AttendanceModel>> getAttendanceForStudent(String studentId);
  Future<void> markAttendance(AttendanceModel attendance);

  // Homework
  Future<List<HomeworkModel>> getHomeworkForBatch(String batchId);
  Future<List<HomeworkModel>> getHomeworkForStudent(String studentId);
  Future<void> createHomework(HomeworkModel homework);
  Future<void> submitHomework(SubmissionModel submission);

  // Tests & Results
  Future<List<TestModel>> getTestsForBatch(String batchId);
  Future<List<ResultModel>> getResultsForStudent(String studentId);
  Future<void> enterMarks(String testId, ResultModel result);
  Future<void> publishTestResults(String testId);

  // Fees & Invoices
  Future<List<FeeInvoiceModel>> getAllInvoices();
  Future<List<FeeInvoiceModel>> getInvoicesForStudent(String studentId);
  Future<void> createInvoice(FeeInvoiceModel invoice);
  Future<PaymentReceiptModel> processPayment({
    required String invoiceId,
    required String studentId,
    required int amountPaise,
    required String gatewayPaymentId,
  });

  // Parent Linking
  Future<Map<String, dynamic>> requestParentChildLink({
    required String parentUid,
    required String rollNumber,
    required String dob,
    required String parentPhone,
  });

  // Admissions CRM
  Future<List<AdmissionEnquiryModel>> getAdmissionEnquiries();
  Future<void> updateEnquiryStatus(String enquiryId, String newStatus);
  Future<void> submitAdmissionEnquiry(AdmissionEnquiryModel enquiry);

  // Notifications
  Future<List<NotificationModel>> getNotifications();
}

class InstituteRepository implements IInstituteRepository {
  final List<BatchModel> _batches = List.from(MockDataSource.batches);
  final List<StudentModel> _students = List.from(MockDataSource.students);
  final List<TeacherModel> _teachers = List.from(MockDataSource.teachers);
  final List<AttendanceModel> _attendance = List.from(MockDataSource.attendance);
  final List<HomeworkModel> _homework = List.from(MockDataSource.homeworkList);
  final List<TestModel> _tests = List.from(MockDataSource.testList);
  final List<FeeInvoiceModel> _invoices = List.from(MockDataSource.invoices);
  final List<PaymentReceiptModel> _receipts = List.from(MockDataSource.receipts);
  final List<AdmissionEnquiryModel> _enquiries = List.from(MockDataSource.enquiries);
  final List<NotificationModel> _notifications = List.from(MockDataSource.notifications);

  // ================= BATCHES =================
  @override
  Future<List<BatchModel>> getBatches({String? classLevel, String? teacherUid}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _batches.where((b) {
      if (classLevel != null && b.classLevel != classLevel) return false;
      if (teacherUid != null && !b.teacherUids.contains(teacherUid)) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> createBatch(BatchModel batch) async {
    _batches.add(batch);
  }

  // ================= STUDENTS & TEACHERS =================
  @override
  Future<List<StudentModel>> getStudents() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_students);
  }

  @override
  Future<StudentModel?> getStudentById(String studentId) async {
    try {
      return _students.firstWhere((s) => s.studentId == studentId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createStudent(StudentModel student) async {
    _students.add(student);
  }

  @override
  Future<List<TeacherModel>> getTeachers() async {
    return List.unmodifiable(_teachers);
  }

  // ================= ATTENDANCE =================
  @override
  Future<List<AttendanceModel>> getAttendanceForBatch(String batchId, String date) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _attendance.where((a) => a.batchId == batchId && a.date == date).toList();
  }

  @override
  Future<List<AttendanceModel>> getAttendanceForStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _attendance.where((a) => a.studentId == studentId).toList();
  }

  @override
  Future<void> markAttendance(AttendanceModel attendance) async {
    final index = _attendance.indexWhere((a) => a.attendanceId == attendance.attendanceId);
    if (index >= 0) {
      _attendance[index] = attendance;
    } else {
      _attendance.add(attendance);
    }
  }

  // ================= HOMEWORK =================
  @override
  Future<List<HomeworkModel>> getHomeworkForBatch(String batchId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _homework.where((h) => h.batchId == batchId).toList();
  }

  @override
  Future<List<HomeworkModel>> getHomeworkForStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Return all homeworks assigned to batches the student is enrolled in
    final student = await getStudentById(studentId);
    if (student == null) return [];
    return _homework.where((h) => student.enrolledBatchIds.contains(h.batchId)).toList();
  }

  @override
  Future<void> createHomework(HomeworkModel homework) async {
    _homework.add(homework);
  }

  @override
  Future<void> submitHomework(SubmissionModel submission) async {
    final hwIndex = _homework.indexWhere((h) => h.homeworkId == submission.homeworkId);
    if (hwIndex >= 0) {
      final hw = _homework[hwIndex];
      final currentSubmissions = List<SubmissionModel>.from(hw.submissions);
      final subIndex = currentSubmissions.indexWhere((s) => s.studentId == submission.studentId);
      if (subIndex >= 0) {
        currentSubmissions[subIndex] = submission;
      } else {
        currentSubmissions.add(submission);
      }
      _homework[hwIndex] = HomeworkModel(
        homeworkId: hw.homeworkId,
        batchId: hw.batchId,
        batchName: hw.batchName,
        subject: hw.subject,
        title: hw.title,
        description: hw.description,
        resourcePaths: hw.resourcePaths,
        deadline: hw.deadline,
        createdBy: hw.createdBy,
        createdAt: hw.createdAt,
        submissions: currentSubmissions,
      );
    }
  }

  // ================= TESTS & RESULTS =================
  @override
  Future<List<TestModel>> getTestsForBatch(String batchId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _tests.where((t) => t.batchId == batchId).toList();
  }

  @override
  Future<List<ResultModel>> getResultsForStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final List<ResultModel> results = [];
    for (final test in _tests) {
      for (final res in test.results) {
        if (res.studentId == studentId && res.publishedAt != null) {
          results.add(res);
        }
      }
    }
    return results;
  }

  @override
  Future<void> enterMarks(String testId, ResultModel result) async {
    final index = _tests.indexWhere((t) => t.testId == testId);
    if (index >= 0) {
      final test = _tests[index];
      final results = List<ResultModel>.from(test.results);
      final rIndex = results.indexWhere((r) => r.studentId == result.studentId);
      if (rIndex >= 0) {
        results[rIndex] = result;
      } else {
        results.add(result);
      }
      _tests[index] = TestModel(
        testId: test.testId,
        batchId: test.batchId,
        batchName: test.batchName,
        subject: test.subject,
        title: test.title,
        testDate: test.testDate,
        totalMarks: test.totalMarks,
        status: 'MARKS_ENTERED',
        results: results,
      );
    }
  }

  @override
  Future<void> publishTestResults(String testId) async {
    final index = _tests.indexWhere((t) => t.testId == testId);
    if (index >= 0) {
      final test = _tests[index];
      final publishedResults = test.results.map((r) {
        return ResultModel(
          resultId: r.resultId,
          testId: r.testId,
          studentId: r.studentId,
          studentName: r.studentName,
          marksObtained: r.marksObtained,
          totalMarks: r.totalMarks,
          percentage: r.percentage,
          feedback: r.feedback,
          publishedAt: DateTime.now(),
        );
      }).toList();

      _tests[index] = TestModel(
        testId: test.testId,
        batchId: test.batchId,
        batchName: test.batchName,
        subject: test.subject,
        title: test.title,
        testDate: test.testDate,
        totalMarks: test.totalMarks,
        status: 'PUBLISHED',
        results: publishedResults,
      );
    }
  }

  // ================= FEES & PAYMENTS =================
  @override
  Future<List<FeeInvoiceModel>> getAllInvoices() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_invoices);
  }

  @override
  Future<List<FeeInvoiceModel>> getInvoicesForStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _invoices.where((i) => i.studentId == studentId).toList();
  }

  @override
  Future<void> createInvoice(FeeInvoiceModel invoice) async {
    _invoices.add(invoice);
  }

  @override
  Future<PaymentReceiptModel> processPayment({
    required String invoiceId,
    required String studentId,
    required int amountPaise,
    required String gatewayPaymentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _invoices.indexWhere((i) => i.invoiceId == invoiceId);
    if (index < 0) throw Exception('Invoice $invoiceId not found');

    final invoice = _invoices[index];
    final newAmountPaid = invoice.amountPaidPaise + amountPaise;
    final newBalanceDue = (invoice.amountDuePaise - newAmountPaid).clamp(0, invoice.amountDuePaise);
    final newStatus = newBalanceDue == 0 ? 'PAID' : 'PARTIALLY_PAID';

    _invoices[index] = FeeInvoiceModel(
      invoiceId: invoice.invoiceId,
      studentId: invoice.studentId,
      studentName: invoice.studentName,
      academicYear: invoice.academicYear,
      period: invoice.period,
      lineItems: invoice.lineItems,
      subtotalPaise: invoice.subtotalPaise,
      discountPaise: invoice.discountPaise,
      amountDuePaise: invoice.amountDuePaise,
      amountPaidPaise: newAmountPaid,
      balanceDuePaise: newBalanceDue,
      dueDate: invoice.dueDate,
      status: newStatus,
      createdAt: invoice.createdAt,
    );

    // Create official receipt
    final receiptId = 'RAD-REC-2026-${(1000 + _receipts.length + 1)}';
    final receipt = PaymentReceiptModel(
      receiptId: receiptId,
      invoiceId: invoiceId,
      studentId: studentId,
      studentName: invoice.studentName,
      gatewayPaymentId: gatewayPaymentId,
      amountPaise: amountPaise,
      period: invoice.period,
      issuedAt: DateTime.now(),
    );
    _receipts.add(receipt);

    // Also push notification
    _notifications.insert(
      0,
      NotificationModel(
        notificationId: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Fee Payment Received',
        body: 'Payment of ₹${(amountPaise / 100).toStringAsFixed(2)} confirmed. Receipt $receiptId issued.',
        category: 'FEE',
        createdAt: DateTime.now(),
      ),
    );

    return receipt;
  }

  // ================= PARENT LINKING =================
  @override
  Future<Map<String, dynamic>> requestParentChildLink({
    required String parentUid,
    required String rollNumber,
    required String dob,
    required String parentPhone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final studentIndex = _students.indexWhere(
      (s) => s.rollNumber.toUpperCase() == rollNumber.trim().toUpperCase(),
    );

    if (studentIndex < 0) {
      throw Exception('No student found with roll number: $rollNumber');
    }

    final student = _students[studentIndex];
    if (student.dateOfBirth != dob.trim()) {
      throw Exception('Verification failed: Date of birth does not match student record.');
    }

    // Auto-link
    final updatedParents = List<String>.from(student.parentUids);
    if (!updatedParents.contains(parentUid)) {
      updatedParents.add(parentUid);
      _students[studentIndex] = StudentModel(
        studentId: student.studentId,
        userUid: student.userUid,
        fullName: student.fullName,
        classLevel: student.classLevel,
        academicYear: student.academicYear,
        rollNumber: student.rollNumber,
        dateOfBirth: student.dateOfBirth,
        parentUids: updatedParents,
        enrolledBatchIds: student.enrolledBatchIds,
        emergencyContact: student.emergencyContact,
        status: student.status,
      );
    }

    return {
      'success': true,
      'studentId': student.studentId,
      'studentName': student.fullName,
      'status': 'LINKED',
    };
  }

  // ================= ADMISSIONS CRM =================
  @override
  Future<List<AdmissionEnquiryModel>> getAdmissionEnquiries() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_enquiries);
  }

  @override
  Future<void> updateEnquiryStatus(String enquiryId, String newStatus) async {
    final index = _enquiries.indexWhere((e) => e.enquiryId == enquiryId);
    if (index >= 0) {
      final e = _enquiries[index];
      _enquiries[index] = AdmissionEnquiryModel(
        enquiryId: e.enquiryId,
        studentName: e.studentName,
        guardianName: e.guardianName,
        contactNumber: e.contactNumber,
        classLevel: e.classLevel,
        academicYear: e.academicYear,
        subjectIds: e.subjectIds,
        preferredCallbackTime: e.preferredCallbackTime,
        message: e.message,
        status: newStatus,
        createdAt: e.createdAt,
      );
    }
  }

  @override
  Future<void> submitAdmissionEnquiry(AdmissionEnquiryModel enquiry) async {
    _enquiries.insert(0, enquiry);
  }

  // ================= NOTIFICATIONS =================
  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_notifications);
  }
}
