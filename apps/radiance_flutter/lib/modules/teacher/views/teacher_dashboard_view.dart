import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/teacher_controller.dart';

class TeacherDashboardView extends GetView<TeacherController> {
  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: RadianceAppBar(
        title: 'Faculty Portal',
        subtitle: 'Radiance Institute — Amritsar',
        onLogout: () => Get.find<AuthController>().logout(),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.selectedBatch.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final batch = controller.selectedBatch.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Teacher Batch Selector
              Text(
                'Assigned Batches',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.assignedBatches.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final b = controller.assignedBatches[index];
                    final isSelected = b.batchId == batch?.batchId;

                    return ChoiceChip(
                      selectedColor: AppColors.primaryRoyalBlue,
                      backgroundColor: AppColors.pureWhite,
                      label: Text(
                        b.name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => controller.selectBatch(b),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Active Batch Quick Action Toolbar
              if (batch != null)
                RadianceCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                batch.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Subject: ${batch.subject} • ${batch.enrolledStudentCount} Students',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const StatusBadge(status: 'ACTIVE'),
                        ],
                      ),
                      const Divider(height: 24),

                      // Quick Action Buttons
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          RadianceButton(
                            label: 'Mark Attendance',
                            icon: Icons.checklist,
                            onPressed: () => Get.toNamed(AppRoutes.markAttendance),
                          ),
                          RadianceButton(
                            label: 'Assign Homework',
                            icon: Icons.post_add,
                            isOutlined: true,
                            onPressed: () => Get.toNamed(AppRoutes.createHomework),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Batch Homework & Assessments
              Text(
                'Assignments in this Batch',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.batchHomework.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final hw = controller.batchHomework[index];
                  return RadianceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hw.title,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Due: ${hw.deadline.day}/${hw.deadline.month}/${hw.deadline.year} • ${hw.submissions.length} Submissions',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const StatusBadge(status: 'ASSIGNED'),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Tests & Result Publication
              Text(
                'Class Assessments & Tests',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.batchTests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final test = controller.batchTests[index];
                  final isPublished = test.status == 'PUBLISHED';

                  return RadianceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                test.title,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Date: ${test.testDate} • Total Marks: ${test.totalMarks}',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (!isPublished)
                          ElevatedButton(
                            onPressed: () => controller.publishTest(test.testId),
                            child: const Text('Publish Results'),
                          )
                        else
                          const StatusBadge(status: 'PUBLISHED'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
