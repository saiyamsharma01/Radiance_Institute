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
      isLoading.value = true;
      final allStudents = await repository.getStudents();
      // In sandbox, linked to Aarav Sharma by default
      linkedChildren.value = allStudents.where((s) => s.studentId == 'RAD-2026-0042').toList();
      if (linkedChildren.isNotEmpty) {
        selectChild(linkedChildren.first);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectChild(StudentModel child) async {
    activeChild.value = child;
    childAttendance.value = await repository.getAttendanceForStudent(child.studentId);
    childHomework.value = await repository.getHomeworkForStudent(child.studentId);
    childResults.value = await repository.getResultsForStudent(child.studentId);
    childInvoices.value = await repository.getInvoicesForStudent(child.studentId);
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
      // In sandbox/emulator: simulate verified gateway transaction ID
      final paymentId = 'pay_rzp_${DateTime.now().millisecondsSinceEpoch}';
      final receipt = await repository.processPayment(
        invoiceId: invoice.invoiceId,
        studentId: invoice.studentId,
        amountPaise: invoice.balanceDuePaise,
        gatewayPaymentId: paymentId,
      );

      lastReceipt.value = receipt;
      await selectChild(activeChild.value!);
      Get.snackbar('Payment Confirmed', 'Payment of ${invoice.formattedBalanceDue} received!');
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
