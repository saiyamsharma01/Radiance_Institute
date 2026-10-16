import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/student_controller.dart';

class StudentDashboardView extends GetView<StudentController> {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: RadianceAppBar(
        title: 'Student Portal',
        subtitle: 'Radiance Institute — Amritsar',
        onLogout: () => Get.find<AuthController>().logout(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final student = controller.student.value;
        final attendancePct = controller.attendancePercentage.toStringAsFixed(1);
        final outstandingPaise = controller.totalOutstandingDuePaise;

        return RefreshIndicator(
          onRefresh: controller.loadStudentData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Student Profile Card
                RadianceCard(
                  backgroundColor: AppColors.primaryRoyalBlue,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 32,
                          color: AppColors.primaryRoyalBlue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student?.fullName ?? 'Student',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pureWhite,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Class ${student?.classLevel ?? '11'} | Roll No: ${student?.rollNumber ?? ''}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.lightBlueBackground,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Academic Year: ${student?.academicYear ?? '2026-2027'}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.pureWhite.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 4 Core Academic KPIs
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return GridView.count(
                      crossAxisCount: isWide ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 1.4 : 1.3,
                      children: [
                        _buildMetricTile(
                          icon: Icons.calendar_today_outlined,
                          label: 'Attendance',
                          value: '$attendancePct%',
                          color: AppColors.success,
                          onTap: () => Get.toNamed(AppRoutes.studentAttendance),
                        ),
                        _buildMetricTile(
                          icon: Icons.assignment_outlined,
                          label: 'Homework',
                          value: '${controller.homeworkList.length} Active',
                          color: AppColors.info,
                          onTap: () => Get.toNamed(AppRoutes.studentHomework),
                        ),
                        _buildMetricTile(
                          icon: Icons.analytics_outlined,
                          label: 'Latest Score',
                          value: controller.testResults.isNotEmpty
                              ? '${controller.testResults.first.percentage}%'
                              : 'N/A',
                          color: AppColors.accentGold,
                          onTap: () => Get.toNamed(AppRoutes.studentTests),
                        ),
                        _buildMetricTile(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Fee Balance',
                          value: CurrencyFormatter.formatPaise(outstandingPaise),
                          color: outstandingPaise > 0 ? AppColors.error : AppColors.success,
                          onTap: () => Get.toNamed(AppRoutes.studentFees),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Enrolled Batches Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enrolled Batches',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepNavy,
                      ),
                    ),
                    Text(
                      '${controller.batches.length} Batches',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.batches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final batch = controller.batches[index];
                    return RadianceCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.menu_book,
                              color: AppColors.primaryRoyalBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batch.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Subject: ${batch.subject} • Class ${batch.classLevel}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (batch.schedule.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${batch.schedule.first.dayOfWeek} at ${batch.schedule.first.startTime} (${batch.schedule.first.room})',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.primaryRoyalBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const StatusBadge(status: 'ACTIVE'),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Upcoming Homework Assignments
                Text(
                  'Assignments & Homework',
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
                  itemCount: controller.homeworkList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final hw = controller.homeworkList[index];
                    final isSubmitted = hw.submissions.any((s) => s.studentId == controller.activeStudentId);

                    return RadianceCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlueBackground,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  hw.subject,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryRoyalBlue,
                                  ),
                                ),
                              ),
                              StatusBadge(status: isSubmitted ? 'SUBMITTED' : 'PENDING'),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                            hw.description,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 16, color: AppColors.warning),
                              const SizedBox(width: 6),
                              Text(
                                'Deadline: ${hw.deadline.day}/${hw.deadline.month}/${hw.deadline.year}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return RadianceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
