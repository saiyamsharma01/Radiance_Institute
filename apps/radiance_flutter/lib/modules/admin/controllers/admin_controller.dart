import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/admission_enquiry_model.dart';
import '../../../data/models/audit_log_model.dart';
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
  final RxList<AuditLogModel> auditLogs = <AuditLogModel>[].obs;
  final RxBool isLoading = false.obs;

  // Active navigation index in Admin dashboard
  final RxInt selectedNavIndex = 0.obs;

  // Search and Filter States
  final RxString crmSearchQuery = ''.obs;
  final RxString crmStatusFilter = 'ALL'.obs;

  final RxString studentSearchQuery = ''.obs;
  final RxString studentClassFilter = 'ALL'.obs;

  final RxString batchSearchQuery = ''.obs;
  final RxString batchClassFilter = 'ALL'.obs;

  final RxString invoiceSearchQuery = ''.obs;
  final RxString invoiceStatusFilter = 'ALL'.obs;

  final RxString auditSearchQuery = ''.obs;

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

  // New Batch Form
  final batchNameController = TextEditingController();
  final batchSubjectController = TextEditingController(text: 'Physics');
  final batchClassController = '11'.obs;
  final batchRoomController = TextEditingController(text: 'Hall A');
  final batchTimeController = TextEditingController(text: '16:00 - 17:30');

  // New Enquiry Form
  final enquiryNameController = TextEditingController();
  final enquiryGuardianController = TextEditingController();
  final enquiryPhoneController = TextEditingController();
  final enquiryClassController = '11'.obs;
  final enquiryMessageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAllAdminData();
  }

  Future<void> loadAllAdminData() async {
    try {
      if (students.isEmpty) isLoading.value = true;
      final results = await Future.wait([
        repository.getAdmissionEnquiries(),
        repository.getStudents(),
        repository.getTeachers(),
        repository.getBatches(),
        repository.getAllInvoices(),
        repository.getAuditLogs(),
      ]);

      enquiries.value = results[0] as List<AdmissionEnquiryModel>;
      students.value = results[1] as List<StudentModel>;
      teachers.value = results[2] as List<TeacherModel>;
      batches.value = results[3] as List<BatchModel>;
      invoices.value = results[4] as List<FeeInvoiceModel>;
      auditLogs.value = results[5] as List<AuditLogModel>;

      if (students.isNotEmpty && invoiceStudentId.isEmpty) {
        invoiceStudentId.value = students.first.studentId;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Admissions CRM
  List<AdmissionEnquiryModel> get filteredEnquiries {
    return enquiries.where((e) {
      if (crmStatusFilter.value != 'ALL' && e.status != crmStatusFilter.value) return false;
      if (crmSearchQuery.value.isNotEmpty) {
        final q = crmSearchQuery.value.toLowerCase();
        final match = e.studentName.toLowerCase().contains(q) ||
            e.guardianName.toLowerCase().contains(q) ||
            e.contactNumber.contains(q) ||
            e.enquiryId.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<void> updateEnquiryStatus(String enquiryId, String newStatus) async {
    await repository.updateEnquiryStatus(enquiryId, newStatus);
    enquiries.value = await repository.getAdmissionEnquiries();
    auditLogs.value = await repository.getAuditLogs();
    Get.snackbar('Status Updated', 'Enquiry marked as $newStatus');
  }

  Future<void> createEnquiry() async {
    final name = enquiryNameController.text.trim();
    final guardian = enquiryGuardianController.text.trim();
    final phone = enquiryPhoneController.text.trim();
    final msg = enquiryMessageController.text.trim();

    if (name.isEmpty || guardian.isEmpty || phone.isEmpty) {
      Get.snackbar('Error', 'Please fill name, guardian and contact phone.');
      return;
    }

    final newEnq = AdmissionEnquiryModel(
      enquiryId: 'ENQ-2026-${(1050 + enquiries.length + 1)}',
      studentName: name,
      guardianName: guardian,
      contactNumber: phone,
      classLevel: enquiryClassController.value,
      academicYear: '2026-2027',
      subjectIds: ['Senior Secondary PCM'],
      preferredCallbackTime: 'Afternoon (2 PM - 5 PM)',
      message: msg.isNotEmpty ? msg : 'Direct inquiry logged at institute desk.',
      status: 'NEW',
      createdAt: DateTime.now(),
    );

    await repository.submitAdmissionEnquiry(newEnq);
    enquiries.value = await repository.getAdmissionEnquiries();
    auditLogs.value = await repository.getAuditLogs();
    enquiryNameController.clear();
    enquiryGuardianController.clear();
    enquiryPhoneController.clear();
    enquiryMessageController.clear();
    Get.back();
    Get.snackbar('Enquiry Added', 'Recorded entry for $name in admissions pipeline.');
  }

  // Student Management
  List<StudentModel> get filteredStudents {
    return students.where((s) {
      if (studentClassFilter.value != 'ALL' && s.classLevel != studentClassFilter.value) return false;
      if (studentSearchQuery.value.isNotEmpty) {
        final q = studentSearchQuery.value.toLowerCase();
        final match = s.fullName.toLowerCase().contains(q) ||
            s.rollNumber.toLowerCase().contains(q) ||
            s.studentId.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

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
        userUid: 'usr_${roll.toLowerCase().replaceAll(RegExp(r'\W'), '')}',
        fullName: name,
        classLevel: selectedClassLevel.value,
        academicYear: '2026-2027',
        rollNumber: roll,
        dateOfBirth: dob,
        parentUids: [],
        emergencyContact: contact,
        enrolledBatchIds: ['batch_c${selectedClassLevel.value}_general'],
      );

      await repository.createStudent(newStudent);
      students.value = await repository.getStudents();
      auditLogs.value = await repository.getAuditLogs();
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

  // Batches Management
  List<BatchModel> get filteredBatches {
    return batches.where((b) {
      if (batchClassFilter.value != 'ALL' && b.classLevel != batchClassFilter.value) return false;
      if (batchSearchQuery.value.isNotEmpty) {
        final q = batchSearchQuery.value.toLowerCase();
        final match = b.name.toLowerCase().contains(q) ||
            b.subject.toLowerCase().contains(q) ||
            b.batchId.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Future<void> createBatch() async {
    final name = batchNameController.text.trim();
    final subject = batchSubjectController.text.trim();
    final room = batchRoomController.text.trim();
    final time = batchTimeController.text.trim();

    if (name.isEmpty || subject.isEmpty) {
      Get.snackbar('Error', 'Please provide batch name and subject.');
      return;
    }

    try {
      isLoading.value = true;
      final newBatch = BatchModel(
        batchId: 'batch_${name.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}',
        name: name,
        classLevel: batchClassController.value,
        subject: subject,
        academicYear: '2026-2027',
        teacherUids: ['usr_teacher_phys'],
        enrolledStudentCount: 0,
        schedule: [
          BatchSchedule(dayOfWeek: 'Mon, Wed, Fri', startTime: time.split('-').first.trim(), endTime: time.contains('-') ? time.split('-').last.trim() : '17:30', room: room),
        ],
      );

      await repository.createBatch(newBatch);
      batches.value = await repository.getBatches();
      auditLogs.value = await repository.getAuditLogs();
      batchNameController.clear();
      Get.back();
      Get.snackbar('Batch Created', 'Batch $name created successfully.');
    } finally {
      isLoading.value = false;
    }
  }

  // Invoicing
  List<FeeInvoiceModel> get filteredInvoices {
    return invoices.where((i) {
      if (invoiceStatusFilter.value != 'ALL' && i.status != invoiceStatusFilter.value) return false;
      if (invoiceSearchQuery.value.isNotEmpty) {
        final q = invoiceSearchQuery.value.toLowerCase();
        final match = i.invoiceId.toLowerCase().contains(q) ||
            i.studentName.toLowerCase().contains(q) ||
            i.period.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

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
      auditLogs.value = await repository.getAuditLogs();
      invoicePeriodController.clear();
      invoiceItemDescController.clear();
      invoiceAmountRupeesController.clear();
      Get.back();
      Get.snackbar('Invoice Generated', 'Invoice ${newInv.invoiceId} issued to ${targetStudent.fullName}');
    } finally {
      isLoading.value = false;
    }
  }

  // Audit Logs
  List<AuditLogModel> get filteredAuditLogs {
    if (auditSearchQuery.value.isEmpty) return auditLogs;
    final q = auditSearchQuery.value.toLowerCase();
    return auditLogs.where((l) {
      return l.action.toLowerCase().contains(q) ||
          l.actorUid.toLowerCase().contains(q) ||
          l.resource.toLowerCase().contains(q) ||
          (l.details?.toLowerCase().contains(q) ?? false);
    }).toList();
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
    batchNameController.dispose();
    batchSubjectController.dispose();
    batchRoomController.dispose();
    batchTimeController.dispose();
    enquiryNameController.dispose();
    enquiryGuardianController.dispose();
    enquiryPhoneController.dispose();
    enquiryMessageController.dispose();
    super.onClose();
  }
}
