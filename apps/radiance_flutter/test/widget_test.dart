import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:radiance_institute/core/constants/app_strings.dart';
import 'package:radiance_institute/data/repositories/auth_repository.dart';
import 'package:radiance_institute/data/repositories/institute_repository.dart';
import 'package:radiance_institute/main.dart';
import 'package:radiance_institute/modules/admin/controllers/admin_controller.dart';
import 'package:radiance_institute/modules/auth/controllers/auth_controller.dart';
import 'package:radiance_institute/modules/parent/controllers/parent_controller.dart';
import 'package:radiance_institute/modules/student/controllers/student_controller.dart';
import 'package:radiance_institute/modules/teacher/controllers/teacher_controller.dart';

void main() {
  setUp(() {
    Get.reset();
    final authRepo = AuthRepository();
    final instituteRepo = InstituteRepository();

    Get.put<IAuthRepository>(authRepo, permanent: true);
    Get.put<IInstituteRepository>(instituteRepo, permanent: true);
    Get.put<AuthController>(AuthController(authRepo: authRepo), permanent: true);
    Get.put<StudentController>(StudentController(repository: instituteRepo), permanent: true);
    Get.put<ParentController>(ParentController(repository: instituteRepo), permanent: true);
    Get.put<TeacherController>(TeacherController(repository: instituteRepo), permanent: true);
    Get.put<AdminController>(AdminController(repository: instituteRepo), permanent: true);
  });

  testWidgets('RadianceApp launches and renders official branding and login view', (WidgetTester tester) async {
    // Provide a standard test screen size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RadianceApp());
    await tester.pumpAndSettle();

    // Verify official brand name & tagline
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);

    // Verify presence of input fields and actions
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Sign In to Portal'), findsOneWidget);
    expect(find.text('Parent OTP Login'), findsOneWidget);
  });
}
