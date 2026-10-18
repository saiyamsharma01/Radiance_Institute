import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/batch_model.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/test_model.dart';
import '../../../data/repositories/institute_repository.dart';
import '../../auth/controllers/auth_controller.dart';

class TeacherController extends GetxController {
  final IInstituteRepository repository;

  TeacherController({required this.repository});

  final RxList<BatchModel> assignedBatches = <BatchModel>[].obs;
  final Rx<BatchModel?> selectedBatch = Rx<BatchModel?>(null);
  final RxList<StudentModel> batchStudents = <StudentModel>[].obs;
  final RxList<HomeworkModel> batchHomework = <HomeworkModel>[].obs;
  final RxList<TestModel> batchTests = <TestModel>[].obs;
  final RxBool isLoading = false.obs;

  // Selected date for attendance
  final RxString selectedAttendanceDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  // Mark Attendance State (studentId -> status)
  final RxMap<String, String> attendanceStatuses = <String, String>{}.obs;

  // New Homework Form
  final hwTitleController = TextEditingController();
  final hwDescController = TextEditingController();
  final hwDeadlineDays = 2.obs;

  // New Test Form
  final testTitleController = TextEditingController();
  final testMarksController = TextEditingController(text: '100');
  final testSubjectController = TextEditingController();

  String get teacherUid {
    if (Get.isRegistered<AuthController>()) {
      final user = Get.find<AuthController>().currentUser.value;
      if (user != null && user.uid.isNotEmpty) {
        return user.uid;
      }
    }
    return 'usr_teacher_phys';
  }

  @override
  void onInit() {
    super.onInit();
    loadTeacherData();
  }

  Future<void> loadTeacherData() async {
    try {
      if (assignedBatches.isEmpty) isLoading.value = true;
      final batches = await repository.getBatches();
      // Filter by teacher or show all if current user is admin/teacher
      final teacherBatches = batches.where((b) => b.teacherUids.contains(teacherUid)).toList();
      assignedBatches.value = teacherBatches.isNotEmpty ? teacherBatches : batches;
      if (assignedBatches.isNotEmpty) {
        if (selectedBatch.value == null || !assignedBatches.any((b) => b.batchId == selectedBatch.value!.batchId)) {
          selectBatch(assignedBatches.first);
        } else {
          selectBatch(selectedBatch.value!);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectBatch(BatchModel batch) async {
    selectedBatch.value = batch;
    final results = await Future.wait([
      repository.getStudents(),
      repository.getHomeworkForBatch(batch.batchId),
      repository.getTestsForBatch(batch.batchId),
    ]);

    final allStudents = results[0] as List<StudentModel>;
    batchStudents.value = allStudents
        .where((s) => s.enrolledBatchIds.contains(batch.batchId))
        .toList();

    // Default attendance status to PRESENT for all batch students
    final map = <String, String>{};
    for (final s in batchStudents) {
      map[s.studentId] = attendanceStatuses[s.studentId] ?? 'PRESENT';
    }
    attendanceStatuses.value = map;

    batchHomework.value = results[1] as List<HomeworkModel>;
    batchTests.value = results[2] as List<TestModel>;
  }

  void toggleAttendance(String studentId, String status) {
    attendanceStatuses[studentId] = status;
  }

  void markAllPresent() {
    final map = <String, String>{};
    for (final s in batchStudents) {
      map[s.studentId] = 'PRESENT';
    }
    attendanceStatuses.value = map;
  }

  Future<void> submitBatchAttendance(String date) async {
    if (selectedBatch.value == null) return;
    try {
      isLoading.value = true;
      for (final entry in attendanceStatuses.entries) {
        final student = batchStudents.firstWhere((s) => s.studentId == entry.key);
        final attendance = AttendanceModel(
          attendanceId: AttendanceModel.generateId(selectedBatch.value!.batchId, date, entry.key),
          batchId: selectedBatch.value!.batchId,
          studentId: entry.key,
          studentName: student.fullName,
          date: date,
          status: entry.value,
          markedBy: teacherUid,
          markedAt: DateTime.now(),
        );
        await repository.markAttendance(attendance);
      }
      Get.back();
      Get.snackbar('Attendance Saved', 'Session successfully verified and marked for $date.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createHomework() async {
    final title = hwTitleController.text.trim();
    final desc = hwDescController.text.trim();
    if (title.isEmpty || selectedBatch.value == null) {
      Get.snackbar('Error', 'Please enter assignment title.');
      return;
    }

    try {
      isLoading.value = true;
      final hw = HomeworkModel(
        homeworkId: 'hw_${DateTime.now().millisecondsSinceEpoch}',
        batchId: selectedBatch.value!.batchId,
        batchName: selectedBatch.value!.name,
        subject: selectedBatch.value!.subject,
        title: title,
        description: desc.isNotEmpty ? desc : 'Complete assigned problem worksheet.',
        deadline: DateTime.now().add(Duration(days: hwDeadlineDays.value)),
        createdBy: teacherUid,
        createdAt: DateTime.now(),
      );
      await repository.createHomework(hw);
      hwTitleController.clear();
      hwDescController.clear();
      await selectBatch(selectedBatch.value!);
      Get.back();
      Get.snackbar('Homework Created', 'Assigned to ${selectedBatch.value!.name}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTestAndPublish({
    required String title,
    required double totalMarks,
    required String testDate,
    required Map<String, double> marksMap,
  }) async {
    if (selectedBatch.value == null) return;
    try {
      isLoading.value = true;
      final testId = 'test_${DateTime.now().millisecondsSinceEpoch}';
      final results = <ResultModel>[];

      for (final s in batchStudents) {
        final obtained = marksMap[s.studentId] ?? (totalMarks * 0.85);
        final pct = (obtained / totalMarks) * 100.0;
        results.add(ResultModel(
          resultId: 'res_${testId}_${s.studentId}',
          testId: testId,
          studentId: s.studentId,
          studentName: s.fullName,
          marksObtained: obtained,
          totalMarks: totalMarks,
          percentage: double.parse(pct.toStringAsFixed(1)),
          feedback: 'Evaluated by Faculty',
          publishedAt: DateTime.now(),
          testTitle: title,
          subject: selectedBatch.value!.subject,
          testDate: testDate,
        ));
      }

      final newTest = TestModel(
        testId: testId,
        batchId: selectedBatch.value!.batchId,
        batchName: selectedBatch.value!.name,
        subject: selectedBatch.value!.subject,
        title: title,
        testDate: testDate,
        totalMarks: totalMarks,
        status: 'PUBLISHED',
        results: results,
      );

      await repository.createTest(newTest);
      await selectBatch(selectedBatch.value!);
      Get.back();
      Get.snackbar('Test Published', '$title scores published for ${results.length} students.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> publishTest(String testId) async {
    try {
      isLoading.value = true;
      await repository.publishTestResults(testId);
      await selectBatch(selectedBatch.value!);
      Get.snackbar('Results Published', 'Scores are now visible to students and parents.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    hwTitleController.dispose();
    hwDescController.dispose();
    testTitleController.dispose();
    testMarksController.dispose();
    testSubjectController.dispose();
    super.onClose();
  }
}
