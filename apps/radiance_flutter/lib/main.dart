import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/institute_repository.dart';
import 'modules/admin/controllers/admin_controller.dart';
import 'modules/admin/views/admin_dashboard_view.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/auth/views/login_view.dart';
import 'modules/auth/views/parent_otp_view.dart';
import 'modules/common/controllers/notification_controller.dart';
import 'modules/common/views/notifications_view.dart';
import 'modules/parent/controllers/parent_controller.dart';
import 'modules/parent/views/parent_child_linking_view.dart';
import 'modules/parent/views/parent_dashboard_view.dart';
import 'modules/splash/controllers/splash_controller.dart';
import 'modules/splash/views/splash_view.dart';
import 'modules/student/controllers/student_controller.dart';
import 'modules/student/views/student_attendance_view.dart';
import 'modules/student/views/student_dashboard_view.dart';
import 'modules/student/views/student_fees_view.dart';
import 'modules/student/views/student_homework_view.dart';
import 'modules/student/views/student_tests_view.dart';
import 'modules/teacher/controllers/teacher_controller.dart';
import 'modules/teacher/views/create_homework_view.dart';
import 'modules/teacher/views/mark_attendance_view.dart';
import 'modules/teacher/views/teacher_dashboard_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Load bundled Google Fonts from assets without attempting runtime network calls
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialize Global Singletons & Repositories
  final IAuthRepository authRepo = AuthRepository();
  final IInstituteRepository instituteRepo = InstituteRepository();

  Get.put<IAuthRepository>(authRepo, permanent: true);
  Get.put<IInstituteRepository>(instituteRepo, permanent: true);

  // Initialize Core Controllers
  Get.put<SplashController>(SplashController(authRepo: authRepo), permanent: true);
  Get.put<AuthController>(AuthController(authRepo: authRepo), permanent: true);
  Get.put<NotificationController>(NotificationController(repository: instituteRepo), permanent: true);
  Get.put<StudentController>(StudentController(repository: instituteRepo), permanent: true);
  Get.put<ParentController>(ParentController(repository: instituteRepo), permanent: true);
  Get.put<TeacherController>(TeacherController(repository: instituteRepo), permanent: true);
  Get.put<AdminController>(AdminController(repository: instituteRepo), permanent: true);

  runApp(const RadianceApp());
}

class RadianceApp extends StatelessWidget {
  const RadianceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(
          name: AppRoutes.splash,
          page: () => const SplashView(),
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginView(),
        ),
        GetPage(
          name: AppRoutes.parentOtp,
          page: () => const ParentOtpView(),
        ),
        GetPage(
          name: AppRoutes.studentDashboard,
          page: () => const StudentDashboardView(),
        ),
        GetPage(
          name: AppRoutes.studentAttendance,
          page: () => const StudentAttendanceView(),
        ),
        GetPage(
          name: AppRoutes.studentHomework,
          page: () => const StudentHomeworkView(),
        ),
        GetPage(
          name: AppRoutes.studentTests,
          page: () => const StudentTestsView(),
        ),
        GetPage(
          name: AppRoutes.studentFees,
          page: () => const StudentFeesView(),
        ),
        GetPage(
          name: AppRoutes.parentDashboard,
          page: () => const ParentDashboardView(),
        ),
        GetPage(
          name: AppRoutes.parentChildLinking,
          page: () => const ParentChildLinkingView(),
        ),
        GetPage(
          name: AppRoutes.teacherDashboard,
          page: () => const TeacherDashboardView(),
        ),
        GetPage(
          name: AppRoutes.markAttendance,
          page: () => const MarkAttendanceView(),
        ),
        GetPage(
          name: AppRoutes.createHomework,
          page: () => const CreateHomeworkView(),
        ),
        GetPage(
          name: AppRoutes.adminDashboard,
          page: () => const AdminDashboardView(),
        ),
        GetPage(
          name: AppRoutes.notifications,
          page: () => const NotificationsView(),
        ),
      ],
    );
  }
}
