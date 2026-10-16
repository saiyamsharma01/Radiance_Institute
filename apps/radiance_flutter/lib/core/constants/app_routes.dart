/// Navigation route constants for Radiance Institute.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String parentOtp = '/parent-otp';

  // Role Gateways
  static const String studentDashboard = '/student/dashboard';
  static const String studentAttendance = '/student/attendance';
  static const String studentHomework = '/student/homework';
  static const String studentTests = '/student/tests';
  static const String studentFees = '/student/fees';

  static const String parentDashboard = '/parent/dashboard';
  static const String parentChildLinking = '/parent/link-child';
  static const String parentFees = '/parent/fees';
  static const String parentReceipt = '/parent/receipt';

  static const String teacherDashboard = '/teacher/dashboard';
  static const String markAttendance = '/teacher/attendance';
  static const String createHomework = '/teacher/homework';
  static const String enterMarks = '/teacher/marks';

  static const String adminDashboard = '/admin/dashboard';
  static const String admissionCrm = '/admin/admissions';
  static const String studentManagement = '/admin/students';
  static const String teacherManagement = '/admin/teachers';
  static const String batchManagement = '/admin/batches';
  static const String feeInvoicing = '/admin/fees';
  static const String auditLogs = '/admin/audit-logs';

  static const String notifications = '/notifications';
}
