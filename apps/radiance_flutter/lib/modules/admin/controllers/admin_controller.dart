import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/admission_enquiry_model.dart';
import '../../../data/models/batch_model.dart';
import '../../../data/models/fee_models.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/teacher_model.dart';
import '../../../data/repositories/institute_repository.dart';

class AdminController extends GetxController {
  final IInstituteRepository repository;

  AdminController({required this.repository});

  final RxList<AdmissionEnquiryModel> enquiries = <AdmissionEnquiryModel>[].obs;
  final RxList<StudentModel> students = <StudentModel>[].obs;
  final RxList<TeacherModel> teachers = <TeacherModel>[].obs;
  final RxList<BatchModel> batches = <BatchModel>[].obs;
  final RxList<FeeInvoiceModel> invoices = <FeeInvoiceModel>[].obs;
  final RxBool isLoading = false.obs;

  // Active navigation index in Admin dashboard
  final RxInt selectedNavIndex = 0.obs;

  // New Student Form
  final studentNameController = TextEditingController();
  final rollNumberController = TextEditingController();
  final dobController = TextEditingController();
  final contactController = TextEditingController();
  final selectedClassLevel = '11'.obs;

  // New Invoice Form
  final invoiceStudentId = ''.obs;
  final invoicePeriodController = TextEditingController();
  final invoiceItemDescController = TextEditingController();
  final invoiceAmountRupeesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAllAdminData();
  }

  Future<void> loadAllAdminData() async {
    try {
      isLoading.value = true;
      enquiries.value = await repository.getAdmissionEnquiries();
      students.value = await repository.getStudents();
      teachers.value = await repository.getTeachers();
      batches.value = await repository.getBatches();
      invoices.value = await repository.getAllInvoices();
      if (students.isNotEmpty && invoiceStudentId.isEmpty) {
        invoiceStudentId.value = students.first.studentId;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Admissions CRM
  Future<void> updateEnquiryStatus(String enquiryId, String newStatus) async {
    await repository.updateEnquiryStatus(enquiryId, newStatus);
    enquiries.value = await repository.getAdmissionEnquiries();
    Get.snackbar('Status Updated', 'Enquiry marked as $newStatus');
  }

  // Student Creation
  Future<void> createStudent() async {
    final name = studentNameController.text.trim();
    final roll = rollNumberController.text.trim();
    final dob = dobController.text.trim();
    final contact = contactController.text.trim();

    if (name.isEmpty || roll.isEmpty || dob.isEmpty || contact.isEmpty) {
      Get.snackbar('Error', 'Please fill all student details.');
      return;
    }

    try {
      isLoading.value = true;
      final newStudent = StudentModel(
        studentId: 'RAD-2026-${(100 + students.length + 1)}',
        userUid: 'usr_${roll.toLowerCase()}',
        fullName: name,
        classLevel: selectedClassLevel.value,
        academicYear: '2026-2027',
        rollNumber: roll,
        dateOfBirth: dob,
        parentUids: [],
        emergencyContact: contact,
      );

      await repository.createStudent(newStudent);
      students.value = await repository.getStudents();
      studentNameController.clear();
      rollNumberController.clear();
      dobController.clear();
      contactController.clear();
      Get.back();
      Get.snackbar('Student Enrolled', '$name registered successfully.');
    } finally {
      isLoading.value = false;
    }
  }

  // Invoicing
  Future<void> createInvoice() async {
    final period = invoicePeriodController.text.trim();
    final desc = invoiceItemDescController.text.trim();
    final rupeesText = invoiceAmountRupeesController.text.trim();

    if (period.isEmpty || desc.isEmpty || rupeesText.isEmpty) {
      Get.snackbar('Error', 'Please fill all invoice fields.');
      return;
    }

    final double rupees = double.tryParse(rupeesText) ?? 0.0;
    final int amountPaise = (rupees * 100).round();

    final targetStudent = students.firstWhereOrNull((s) => s.studentId == invoiceStudentId.value);
    if (targetStudent == null) return;

    try {
      isLoading.value = true;
      final newInv = FeeInvoiceModel(
        invoiceId: 'INV-2026-${(900 + invoices.length + 1)}',
        studentId: targetStudent.studentId,
        studentName: targetStudent.fullName,
        academicYear: '2026-2027',
        period: period,
        lineItems: [
          InvoiceLineItem(description: desc, amountPaise: amountPaise),
        ],
        subtotalPaise: amountPaise,
        discountPaise: 0,
        amountDuePaise: amountPaise,
        amountPaidPaise: 0,
        balanceDuePaise: amountPaise,
        dueDate: '2026-11-10',
        status: 'ISSUED',
        createdAt: DateTime.now(),
      );

      await repository.createInvoice(newInv);
      invoices.value = await repository.getAllInvoices();
      invoicePeriodController.clear();
      invoiceItemDescController.clear();
      invoiceAmountRupeesController.clear();
      Get.back();
      Get.snackbar('Invoice Generated', 'Invoice ${newInv.invoiceId} issued to ${targetStudent.fullName}');
    } finally {
      isLoading.value = false;
    }
  }

  // KPI calculations
  int get totalRevenuePaise => invoices.fold(0, (sum, i) => sum + i.amountPaidPaise);
  int get totalOutstandingPaise => invoices.fold(0, (sum, i) => sum + i.balanceDuePaise);
  int get newEnquiriesCount => enquiries.where((e) => e.status == 'NEW').length;

  @override
  void onClose() {
    studentNameController.dispose();
    rollNumberController.dispose();
    dobController.dispose();
    contactController.dispose();
    invoicePeriodController.dispose();
    invoiceItemDescController.dispose();
    invoiceAmountRupeesController.dispose();
    super.onClose();
  }
}
