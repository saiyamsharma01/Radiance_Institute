import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../controllers/teacher_controller.dart';

class MarkAttendanceView extends GetView<TeacherController> {
  const MarkAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final batch = controller.selectedBatch.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: RadianceAppBar(
        title: 'Mark Attendance',
        subtitle: '${batch?.name ?? ''} • $today',
      ),
      body: Obx(() {
        final students = controller.batchStudents;

        return Column(
          children: [
            // Deterministic Session Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.lightBlueBackground,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: AppColors.primaryRoyalBlue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Session Key: ${batch?.batchId}_$today (Unique & Deterministic)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final s = students[index];
                  final currentStatus = controller.attendanceStatuses[s.studentId] ?? 'PRESENT';

                  return RadianceCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.fullName,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deepNavy,
                                ),
                              ),
                              Text(
                                'Roll: ${s.rollNumber}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Present / Absent / Late chips
                        _buildStatusChoice(s.studentId, 'PRESENT', currentStatus, AppColors.success),
                        const SizedBox(width: 6),
                        _buildStatusChoice(s.studentId, 'ABSENT', currentStatus, AppColors.error),
                        const SizedBox(width: 6),
                        _buildStatusChoice(s.studentId, 'LATE', currentStatus, AppColors.warning),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Submit Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: RadianceButton(
                label: 'Save & Finalize Attendance',
                icon: Icons.check,
                isLoading: controller.isLoading.value,
                onPressed: () => controller.submitBatchAttendance(today),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatusChoice(String studentId, String status, String current, Color color) {
    final isSelected = current == status;

    return InkWell(
      onTap: () => controller.toggleAttendance(studentId, status),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status[0], // 'P', 'A', 'L'
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.pureWhite : color,
          ),
        ),
      ),
    );
  }
}
