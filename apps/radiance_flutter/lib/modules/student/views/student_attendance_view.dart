import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../controllers/student_controller.dart';

class StudentAttendanceView extends GetView<StudentController> {
  const StudentAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxString selectedBatchFilter = 'ALL'.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const RadianceAppBar(
        title: 'Attendance History',
        subtitle: 'Class & Session Attendance Records',
      ),
      body: Obx(() {
        final attendance = controller.attendanceHistory;
        final pct = controller.attendancePercentage.toStringAsFixed(1);
        final presentCount = attendance.where((a) => a.status == 'PRESENT').length;
        final absentCount = attendance.where((a) => a.status == 'ABSENT').length;
        final lateCount = attendance.where((a) => a.status == 'LATE').length;

        final filtered = selectedBatchFilter.value == 'ALL'
            ? attendance
            : attendance.where((a) => a.batchId == selectedBatchFilter.value).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Attendance Summary Card
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
                      color: AppColors.primaryRoyalBlue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Attendance',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.lightBlueBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$pct%',
                          style: GoogleFonts.outfit(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.pureWhite.withOpacity(0.25)),
                      ),
                      child: Text(
                        '$presentCount / ${attendance.length} Present',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Breakdown Chips
              Row(
                children: [
                  _buildStatTile('Present', '$presentCount', AppColors.success),
                  const SizedBox(width: 10),
                  _buildStatTile('Absent', '$absentCount', AppColors.error),
                  const SizedBox(width: 10),
                  _buildStatTile('Late', '$lateCount', AppColors.warning),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'Class Sessions',
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
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final record = filtered[index];
                  final isPresent = record.status == 'PRESENT';

                  return RadianceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isPresent ? AppColors.success : AppColors.error).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPresent ? Icons.check_circle : Icons.cancel,
                            color: isPresent ? AppColors.success : AppColors.error,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.batchId.replaceAll('_', ' ').toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Date: ${record.date} • Verified by Faculty',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(status: record.status),
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

  Widget _buildStatTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
