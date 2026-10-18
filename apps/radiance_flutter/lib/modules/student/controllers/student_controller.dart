import 'package:get/get.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/batch_model.dart';
import '../../../data/models/fee_models.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/test_model.dart';
import '../../../data/repositories/institute_repository.dart';

class StudentController extends GetxController {
  final IInstituteRepository repository;

  StudentController({required this.repository});

  final Rx<StudentModel?> student = Rx<StudentModel?>(null);
  final RxList<BatchModel> batches = <BatchModel>[].obs;
  final RxList<AttendanceModel> attendanceHistory = <AttendanceModel>[].obs;
  final RxList<HomeworkModel> homeworkList = <HomeworkModel>[].obs;
  final RxList<ResultModel> testResults = <ResultModel>[].obs;
  final RxList<FeeInvoiceModel> invoices = <FeeInvoiceModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString activeStudentId = 'RAD-2026-0042'.obs;

  @override
  void onInit() {
    super.onInit();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    try {
      if (student.value == null) {
        isLoading.value = true;
      }
      final sId = activeStudentId.value;

      final results = await Future.wait([
        repository.getStudentById(sId),
        repository.getBatches(),
        repository.getAttendanceForStudent(sId),
        repository.getHomeworkForStudent(sId),
        repository.getResultsForStudent(sId),
        repository.getInvoicesForStudent(sId),
      ]);

      student.value = results[0] as StudentModel?;
      batches.value = results[1] as List<BatchModel>;
      attendanceHistory.value = results[2] as List<AttendanceModel>;
      homeworkList.value = results[3] as List<HomeworkModel>;
      testResults.value = results[4] as List<ResultModel>;
      invoices.value = results[5] as List<FeeInvoiceModel>;
    } finally {
      isLoading.value = false;
    }
  }

  double get attendancePercentage {
    if (attendanceHistory.isEmpty) return 100.0;
    final presentCount = attendanceHistory.where((a) => a.status == 'PRESENT').length;
    return (presentCount / attendanceHistory.length) * 100.0;
  }

  int get totalOutstandingDuePaise {
    return invoices
        .where((i) => i.status != 'PAID')
        .fold(0, (sum, i) => sum + i.balanceDuePaise);
  }

  Future<void> submitHomeworkSolution(String homeworkId, String solutionNotes) async {
    final submission = SubmissionModel(
      submissionId: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      homeworkId: homeworkId,
      studentId: activeStudentId.value,
      studentName: student.value?.fullName ?? 'Aarav Sharma',
      resourcePaths: ['submissions/$homeworkId/solution_upload.pdf'],
      submittedAt: DateTime.now(),
      status: 'SUBMITTED',
      feedback: solutionNotes.isNotEmpty ? 'Student notes: $solutionNotes' : null,
    );

    await repository.submitHomework(submission);
    await loadStudentData();
    Get.snackbar('Success', 'Homework submitted successfully!');
  }
}
