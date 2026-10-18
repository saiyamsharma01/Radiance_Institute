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
        if (controller.isLoading.value && controller.student.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final student = controller.student.value;
        final attendancePct = controller.attendancePercentage.toStringAsFixed(1);
        final outstandingPaise = controller.totalOutstandingDuePaise;

        return RefreshIndicator(
          onRefresh: controller.loadStudentData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Student Profile Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.deepNavy, AppColors.primaryRoyalBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRoyalBlue.withOpacity(0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            (student?.fullName.isNotEmpty ?? false) ? student!.fullName[0] : 'S',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryRoyalBlue,
                            ),
                          ),
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
                                fontWeight: FontWeight.w500,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.pureWhite.withOpacity(0.3)),
                        ),
                        child: Text(
                          'ACTIVE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 4 Core Academic KPIs (Responsive Grid)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 650;
                    return GridView.count(
                      crossAxisCount: isWide ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 1.45 : 1.25,
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
                          value: '${controller.homeworkList.length} Tasks',
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlueBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${controller.batches.length} Batches',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.primaryRoyalBlue,
                          fontWeight: FontWeight.w700,
                        ),
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
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepNavy,
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
                                      fontWeight: FontWeight.w600,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assignments & Homework',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepNavy,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.studentHomework),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.homeworkList.take(3).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final hw = controller.homeworkList[index];
                    final isSubmitted = hw.submissions.any((s) => s.studentId == controller.activeStudentId.value);

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
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepNavy,
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
                const SizedBox(height: 20),
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
      padding: const EdgeInsets.all(14),
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
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepNavy,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
