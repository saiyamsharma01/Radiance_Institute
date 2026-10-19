import '../models/admission_enquiry_model.dart';
import '../models/attendance_model.dart';
import '../models/audit_log_model.dart';
import '../models/batch_model.dart';
import '../models/fee_models.dart';
import '../models/homework_model.dart';
import '../models/notification_model.dart';
import '../models/student_model.dart';
import '../models/teacher_model.dart';
import '../models/test_model.dart';
import '../models/user_model.dart';

/// Authentic local institute data source providing realistic records for testing,
/// offline mode, and UI validation without inventing arbitrary claims.
class MockDataSource {
  static final List<UserModel> users = [
    UserModel(
      uid: 'usr_admin_1',
      displayName: 'Institute Administration',
      role: UserRole.admin,
      phoneNumber: '+911835080005',
      email: 'admin@radianceinstitute.net',
    ),
    UserModel(
      uid: 'usr_teacher_phys',
      displayName: 'Faculty - Physics Dept',
      role: UserRole.teacher,
      phoneNumber: '+919876543210',
      email: 'physics@radianceinstitute.net',
    ),
    UserModel(
      uid: 'usr_teacher_chem',
      displayName: 'Faculty - Chemistry Dept',
      role: UserRole.teacher,
      phoneNumber: '+919876543211',
      email: 'chemistry@radianceinstitute.net',
    ),
    UserModel(
      uid: 'usr_parent_1',
      displayName: 'Gurpreet Singh',
      role: UserRole.parent,
      phoneNumber: '+919814012345',
    ),
    UserModel(
      uid: 'usr_student_1',
      displayName: 'Aarav Sharma',
      role: UserRole.student,
      phoneNumber: '+919814012345',
    ),
  ];

  static final List<StudentModel> students = [
    StudentModel(
      studentId: 'RAD-2026-0042',
      userUid: 'usr_student_1',
      fullName: 'Aarav Sharma',
      classLevel: '11',
      academicYear: '2026-2027',
      rollNumber: 'RAD11-042',
      dateOfBirth: '2009-05-14',
      parentUids: ['usr_parent_1'],
      enrolledBatchIds: ['batch_c11_phys_a', 'batch_c11_chem_a', 'batch_c11_math_a'],
      emergencyContact: '+919814012345',
    ),
    StudentModel(
      studentId: 'RAD-2026-0089',
      userUid: 'usr_student_2',
      fullName: 'Simran Kaur',
      classLevel: '12',
      academicYear: '2026-2027',
      rollNumber: 'RAD12-019',
      dateOfBirth: '2008-09-22',
      parentUids: ['usr_parent_2'],
      enrolledBatchIds: ['batch_c12_phys_b', 'batch_c12_math_b'],
      emergencyContact: '+919872054321',
    ),
    StudentModel(
      studentId: 'RAD-2026-0105',
      userUid: 'usr_student_3',
      fullName: 'Rohan Mehra',
      classLevel: '10',
      academicYear: '2026-2027',
      rollNumber: 'RAD10-008',
      dateOfBirth: '2010-11-03',
      parentUids: [],
      enrolledBatchIds: ['batch_c10_general'],
      emergencyContact: '+919855011223',
    ),
  ];

  static final List<TeacherModel> teachers = [
    TeacherModel(
      uid: 'usr_teacher_phys',
      displayName: 'Er. Bedi Sir (Senior Physics Master)',
      email: 'bedisir@radianceinstitute.net',
      phoneNumber: '+919914122256',
      subjects: ['Physics (JEE & NEET Specialist)'],
      assignedBatchIds: ['batch_c11_phys_a', 'batch_c12_phys_b'],
    ),
    TeacherModel(
      uid: 'usr_teacher_chem',
      displayName: 'Faculty - Chemistry Dept',
      email: 'chemistry@radianceinstitute.net',
      phoneNumber: '+919815622256',
      subjects: ['Chemistry'],
      assignedBatchIds: ['batch_c11_chem_a'],
    ),
  ];

  static final List<BatchModel> batches = [
    BatchModel(
      batchId: 'batch_c11_phys_a',
      name: 'Class 11 Physics Mastery (Er. Bedi Sir)',
      classLevel: '11',
      academicYear: '2026-2027',
      subject: 'Physics',
      teacherUids: ['usr_teacher_phys'],
      schedule: [
        BatchSchedule(dayOfWeek: 'Monday', startTime: '16:30', endTime: '18:00', room: 'Hall A (Physics Lab)'),
        BatchSchedule(dayOfWeek: 'Wednesday', startTime: '16:30', endTime: '18:00', room: 'Hall A (Physics Lab)'),
        BatchSchedule(dayOfWeek: 'Friday', startTime: '16:30', endTime: '18:00', room: 'Hall A (Physics Lab)'),
      ],
      enrolledStudentCount: 28,
    ),
    BatchModel(
      batchId: 'batch_c11_chem_a',
      name: 'Class 11 Chemistry (Organic & Physical)',
      classLevel: '11',
      academicYear: '2026-2027',
      subject: 'Chemistry',
      teacherUids: ['usr_teacher_chem'],
      schedule: [
        BatchSchedule(dayOfWeek: 'Tuesday', startTime: '15:30', endTime: '17:00', room: 'Hall B'),
        BatchSchedule(dayOfWeek: 'Thursday', startTime: '15:30', endTime: '17:00', room: 'Hall B'),
        BatchSchedule(dayOfWeek: 'Saturday', startTime: '15:30', endTime: '17:00', room: 'Hall B'),
      ],
      enrolledStudentCount: 26,
    ),
    BatchModel(
      batchId: 'batch_c11_math_a',
      name: 'Class 11 Mathematics (Calculus & Vectors)',
      classLevel: '11',
      academicYear: '2026-2027',
      subject: 'Mathematics',
      teacherUids: ['usr_teacher_phys'],
      schedule: [
        BatchSchedule(dayOfWeek: 'Monday', startTime: '18:00', endTime: '19:30', room: 'Hall C'),
        BatchSchedule(dayOfWeek: 'Wednesday', startTime: '18:00', endTime: '19:30', room: 'Hall C'),
      ],
      enrolledStudentCount: 25,
    ),
    BatchModel(
      batchId: 'batch_c10_general',
      name: 'Class 10 Foundation Genius & NTSE',
      classLevel: '10',
      academicYear: '2026-2027',
      subject: 'Science & Mathematics',
      teacherUids: ['usr_teacher_phys', 'usr_teacher_chem'],
      schedule: [
        BatchSchedule(dayOfWeek: 'Monday', startTime: '15:30', endTime: '17:30', room: 'Hall D'),
        BatchSchedule(dayOfWeek: 'Wednesday', startTime: '15:30', endTime: '17:30', room: 'Hall D'),
      ],
      enrolledStudentCount: 32,
    ),
  ];

  static final List<AttendanceModel> attendance = [
    AttendanceModel(
      attendanceId: AttendanceModel.generateId('batch_c11_phys_a', '2026-10-15', 'RAD-2026-0042'),
      batchId: 'batch_c11_phys_a',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      date: '2026-10-15',
      status: 'PRESENT',
      markedBy: 'usr_teacher_phys',
      markedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AttendanceModel(
      attendanceId: AttendanceModel.generateId('batch_c11_chem_a', '2026-10-14', 'RAD-2026-0042'),
      batchId: 'batch_c11_chem_a',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      date: '2026-10-14',
      status: 'PRESENT',
      markedBy: 'usr_teacher_chem',
      markedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AttendanceModel(
      attendanceId: AttendanceModel.generateId('batch_c11_math_a', '2026-10-13', 'RAD-2026-0042'),
      batchId: 'batch_c11_math_a',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      date: '2026-10-13',
      status: 'ABSENT',
      markedBy: 'usr_teacher_phys',
      markedAt: DateTime.now().subtract(const Duration(days: 3)),
      correctionStatus: 'NONE',
    ),
  ];

  static final List<HomeworkModel> homeworkList = [
    HomeworkModel(
      homeworkId: 'hw_phys_101',
      batchId: 'batch_c11_phys_a',
      batchName: 'Class 11 Physics',
      subject: 'Physics',
      title: 'Newtonian Laws & Friction Problem Set',
      description: 'Complete questions 1 through 15 from Chapter 4 worksheet. Show step-by-step vector derivations.',
      deadline: DateTime.now().add(const Duration(days: 2)),
      createdBy: 'usr_teacher_phys',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      submissions: [
        SubmissionModel(
          submissionId: 'sub_aarav_hw101',
          homeworkId: 'hw_phys_101',
          studentId: 'RAD-2026-0042',
          studentName: 'Aarav Sharma',
          resourcePaths: ['submissions/hw_phys_101/aarav_solutions.pdf'],
          submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
          status: 'GRADED',
          score: 9.5,
          feedback: 'Excellent free-body diagram derivations. Keep up the thorough work.',
        ),
      ],
    ),
    HomeworkModel(
      homeworkId: 'hw_chem_102',
      batchId: 'batch_c11_chem_a',
      batchName: 'Class 11 Chemistry',
      subject: 'Chemistry',
      title: 'Thermodynamics State Functions & Hess Law',
      description: 'Solve enthalpy of formation problems from module 3. Focus on standard heat of combustion calculations.',
      deadline: DateTime.now().add(const Duration(days: 4)),
      createdBy: 'usr_teacher_chem',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  static final List<TestModel> testList = [
    TestModel(
      testId: 'test_phys_oct',
      batchId: 'batch_c11_phys_a',
      batchName: 'Class 11 Physics',
      subject: 'Physics',
      title: 'Monthly Assessment: Kinematics & Laws of Motion',
      testDate: '2026-10-10',
      totalMarks: 50.0,
      status: 'PUBLISHED',
      results: [
        ResultModel(
          resultId: 'res_aarav_test1',
          testId: 'test_phys_oct',
          studentId: 'RAD-2026-0042',
          studentName: 'Aarav Sharma',
          marksObtained: 46.5,
          totalMarks: 50.0,
          percentage: 93.0,
          feedback: 'Top score in rotational concepts. Well reasoned solutions.',
          publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ],
    ),
  ];

  static final List<FeeInvoiceModel> invoices = [
    FeeInvoiceModel(
      invoiceId: 'INV-2026-00891',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      academicYear: '2026-2027',
      period: 'October 2026',
      lineItems: [
        InvoiceLineItem(description: 'Class 11 Physics Monthly Tuition', subject: 'Physics', amountPaise: 150000),
        InvoiceLineItem(description: 'Class 11 Chemistry Monthly Tuition', subject: 'Chemistry', amountPaise: 150000),
        InvoiceLineItem(description: 'Class 11 Mathematics Monthly Tuition', subject: 'Mathematics', amountPaise: 150000),
      ],
      subtotalPaise: 450000, // ₹4,500.00
      discountPaise: 50000,  // ₹500.00 Merit Discount
      amountDuePaise: 400000,// ₹4,000.00
      amountPaidPaise: 0,
      balanceDuePaise: 400000,
      dueDate: '2026-10-25',
      status: 'ISSUED',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    FeeInvoiceModel(
      invoiceId: 'INV-2026-00742',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      academicYear: '2026-2027',
      period: 'September 2026',
      lineItems: [
        InvoiceLineItem(description: 'Class 11 PCM Monthly Tuition', subject: 'PCM', amountPaise: 400000),
      ],
      subtotalPaise: 400000,
      discountPaise: 0,
      amountDuePaise: 400000,
      amountPaidPaise: 400000,
      balanceDuePaise: 0,
      dueDate: '2026-09-25',
      status: 'PAID',
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
    ),
  ];

  static final List<PaymentReceiptModel> receipts = [
    PaymentReceiptModel(
      receiptId: 'RAD-REC-2026-0742',
      invoiceId: 'INV-2026-00742',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      gatewayPaymentId: 'pay_rzp_mock_98246194',
      amountPaise: 400000, // ₹4,000.00
      period: 'September 2026',
      issuedAt: DateTime.now().subtract(const Duration(days: 34)),
    ),
  ];

  static final List<AdmissionEnquiryModel> enquiries = [
    AdmissionEnquiryModel(
      enquiryId: 'ENQ-2026-1042',
      studentName: 'Harmanjot Singh',
      guardianName: 'Jaswinder Singh',
      contactNumber: '9815044321',
      classLevel: '11',
      academicYear: '2026-2027',
      subjectIds: ['Physics', 'Chemistry', 'Mathematics'],
      preferredCallbackTime: 'Evening (5 PM - 8 PM)',
      message: 'Looking for senior secondary PCM coaching with focus on board foundations.',
      status: 'NEW',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AdmissionEnquiryModel(
      enquiryId: 'ENQ-2026-1039',
      studentName: 'Navya Verma',
      guardianName: 'Sunil Verma',
      contactNumber: '9872088765',
      classLevel: '9',
      academicYear: '2026-2027',
      subjectIds: ['General Science', 'Mathematics'],
      preferredCallbackTime: 'Morning (10 AM - 1 PM)',
      message: 'Interested in demo class for Class 9 foundation batch.',
      status: 'CONTACTED',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<NotificationModel> notifications = [
    NotificationModel(
      notificationId: 'notif_0',
      title: 'Instagram Live with Er. Bedi Sir this Sunday',
      body: 'Catch @radiance_institute live on Instagram: "Mastering Rotational Dynamics & Shortcuts for JEE Advanced".',
      category: 'EVENT',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    NotificationModel(
      notificationId: 'notif_1',
      title: 'October Tuition Invoice Generated',
      body: 'Invoice INV-2026-00891 for ₹4,000.00 is due by 25 Oct 2026.',
      category: 'FEE',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      notificationId: 'notif_2',
      title: 'Physics Test Result Released',
      body: 'Kinematics & Laws of Motion marks published by Er. Bedi Sir. Score: 93.0%.',
      category: 'RESULT',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<AuditLogModel> auditLogs = [
    AuditLogModel(
      logId: 'log_1',
      actorUid: 'usr_admin_1',
      actorRole: 'ADMIN',
      action: 'FEE_INVOICE_GENERATED',
      resource: 'fee_invoices/INV-2026-00891',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      details: 'Issued to Aarav Sharma for October 2026',
    ),
    AuditLogModel(
      logId: 'log_2',
      actorUid: 'usr_teacher_phys',
      actorRole: 'TEACHER',
      action: 'ATTENDANCE_MARKED',
      resource: 'attendance/batch_c11_phys_a',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      details: 'Deterministic session finalized for Class 11 Physics',
    ),
    AuditLogModel(
      logId: 'log_3',
      actorUid: 'usr_parent_1',
      actorRole: 'PARENT',
      action: 'PARENT_CHILD_AUTO_LINKED',
      resource: 'students/RAD-2026-0042',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      details: 'Verified with DOB & Roll RAD11-042',
    ),
    AuditLogModel(
      logId: 'log_4',
      actorUid: 'usr_admin_1',
      actorRole: 'ADMIN',
      action: 'RESULT_PUBLISHED',
      resource: 'tests/test_phys_oct',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      details: 'Kinematics Monthly Test published for 28 students',
    ),
  ];
}
