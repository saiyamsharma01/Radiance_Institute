import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/batch_model.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/test_model.dart';
import '../../../data/repositories/institute_repository.dart';

class TeacherController extends GetxController {
  final IInstituteRepository repository;

  TeacherController({required this.repository});

  final RxList<BatchModel> assignedBatches = <BatchModel>[].obs;
  final Rx<BatchModel?> selectedBatch = Rx<BatchModel?>(null);
  final RxList<StudentModel> batchStudents = <StudentModel>[].obs;
  final RxList<HomeworkModel> batchHomework = <HomeworkModel>[].obs;
  final RxList<TestModel> batchTests = <TestModel>[].obs;
  final RxBool isLoading = false.obs;

  // Mark Attendance State (studentId -> status)
  final RxMap<String, String> attendanceStatuses = <String, String>{}.obs;

  // New Homework Form
  final hwTitleController = TextEditingController();
  final hwDescController = TextEditingController();
  final hwDeadlineDays = 2.obs;

  // New Test Form
  final testTitleController = TextEditingController();
  final testMarksController = TextEditingController();

  final String teacherUid = 'usr_teacher_phys';

  @override
  void onInit() {
    super.onInit();
    loadTeacherData();
  }

  Future<void> loadTeacherData() async {
    try {
      isLoading.value = true;
      assignedBatches.value = await repository.getBatches(teacherUid: teacherUid);
      if (assignedBatches.isNotEmpty) {
        selectBatch(assignedBatches.first);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectBatch(BatchModel batch) async {
    selectedBatch.value = batch;
    final allStudents = await repository.getStudents();
    batchStudents.value = allStudents
        .where((s) => s.enrolledBatchIds.contains(batch.batchId))
        .toList();

    // Default attendance status to PRESENT for all batch students
    final map = <String, String>{};
    for (final s in batchStudents) {
      map[s.studentId] = 'PRESENT';
    }
    attendanceStatuses.value = map;

    batchHomework.value = await repository.getHomeworkForBatch(batch.batchId);
    batchTests.value = await repository.getTestsForBatch(batch.batchId);
  }

  void toggleAttendance(String studentId, String status) {
    attendanceStatuses[studentId] = status;
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
      Get.snackbar('Attendance Saved', 'Deterministic session marked successfully for $date.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createHomework() async {
    final title = hwTitleController.text.trim();
    final desc = hwDescController.text.trim();
    if (title.isEmpty || selectedBatch.value == null) return;

    try {
      isLoading.value = true;
      final hw = HomeworkModel(
        homeworkId: 'hw_${DateTime.now().millisecondsSinceEpoch}',
        batchId: selectedBatch.value!.batchId,
        batchName: selectedBatch.value!.name,
        subject: selectedBatch.value!.subject,
        title: title,
        description: desc,
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
    super.onClose();
  }
}
