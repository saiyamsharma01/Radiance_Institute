import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/fee_models.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/test_model.dart';
import '../../../data/repositories/institute_repository.dart';

class ParentController extends GetxController {
  final IInstituteRepository repository;

  ParentController({required this.repository});

  final RxList<StudentModel> linkedChildren = <StudentModel>[].obs;
  final Rx<StudentModel?> activeChild = Rx<StudentModel?>(null);
  final RxList<AttendanceModel> childAttendance = <AttendanceModel>[].obs;
  final RxList<HomeworkModel> childHomework = <HomeworkModel>[].obs;
  final RxList<ResultModel> childResults = <ResultModel>[].obs;
  final RxList<FeeInvoiceModel> childInvoices = <FeeInvoiceModel>[].obs;
  final Rx<PaymentReceiptModel?> lastReceipt = Rx<PaymentReceiptModel?>(null);
  final RxBool isLoading = false.obs;

  // Linking form controllers
  final rollNumberController = TextEditingController();
  final dobController = TextEditingController();
  final RxString linkingMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadParentData();
  }

  Future<void> loadParentData() async {
    try {
      if (linkedChildren.isEmpty) {
        isLoading.value = true;
      }
      final allStudents = await repository.getStudents();
      // Linked to student 1 & student 2 by default in sandbox, or those containing parent
      linkedChildren.value = allStudents.where((s) => s.studentId == 'RAD-2026-0042' || s.parentUids.contains('usr_parent_1')).toList();
      if (linkedChildren.isEmpty && allStudents.isNotEmpty) {
        linkedChildren.value = [allStudents.first];
      }
      if (linkedChildren.isNotEmpty && activeChild.value == null) {
        selectChild(linkedChildren.first);
      } else if (activeChild.value != null) {
        selectChild(activeChild.value!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectChild(StudentModel child) async {
    activeChild.value = child;
    final results = await Future.wait([
      repository.getAttendanceForStudent(child.studentId),
      repository.getHomeworkForStudent(child.studentId),
      repository.getResultsForStudent(child.studentId),
      repository.getInvoicesForStudent(child.studentId),
    ]);

    childAttendance.value = results[0] as List<AttendanceModel>;
    childHomework.value = results[1] as List<HomeworkModel>;
    childResults.value = results[2] as List<ResultModel>;
    childInvoices.value = results[3] as List<FeeInvoiceModel>;
  }

  double get childAttendancePercentage {
    if (childAttendance.isEmpty) return 100.0;
    final presentCount = childAttendance.where((a) => a.status == 'PRESENT').length;
    return (presentCount / childAttendance.length) * 100.0;
  }

  Future<void> linkStudent() async {
    final roll = rollNumberController.text.trim();
    final dob = dobController.text.trim();

    if (roll.isEmpty || dob.isEmpty) {
      linkingMessage.value = 'Please provide both Student Roll Number and Date of Birth (YYYY-MM-DD).';
      return;
    }

    try {
      isLoading.value = true;
      linkingMessage.value = '';
      final res = await repository.requestParentChildLink(
        parentUid: 'usr_parent_1',
        rollNumber: roll,
        dob: dob,
        parentPhone: '+919814012345',
      );

      final studentId = res['studentId'];
      final newlyLinked = await repository.getStudentById(studentId);
      if (newlyLinked != null && !linkedChildren.any((c) => c.studentId == studentId)) {
        linkedChildren.add(newlyLinked);
        selectChild(newlyLinked);
      }
      Get.back();
      Get.snackbar('Verification Success', 'Student ${res['studentName']} linked successfully!');
      rollNumberController.clear();
      dobController.clear();
    } catch (e) {
      linkingMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payInvoice(FeeInvoiceModel invoice) async {
    try {
      isLoading.value = true;
      final paymentId = 'pay_rzp_${DateTime.now().millisecondsSinceEpoch}';
      final receipt = await repository.processPayment(
        invoiceId: invoice.invoiceId,
        studentId: invoice.studentId,
        amountPaise: invoice.balanceDuePaise,
        gatewayPaymentId: paymentId,
      );

      lastReceipt.value = receipt;
      await selectChild(activeChild.value!);
      Get.snackbar(
        'Payment Confirmed',
        'Payment of ${invoice.formattedBalanceDue} received! Receipt ${receipt.receiptId} issued.',
        backgroundColor: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Payment Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    rollNumberController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
