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
    final batch = controller.selectedBatch.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: RadianceAppBar(
        title: 'Mark Attendance',
        subtitle: batch?.name ?? 'Class Attendance Session',
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.done_all, color: AppColors.pureWhite, size: 18),
            label: Text('All Present', style: GoogleFonts.inter(color: AppColors.pureWhite, fontWeight: FontWeight.w600, fontSize: 12)),
            onPressed: controller.markAllPresent,
          ),
        ],
      ),
      body: Obx(() {
        final students = controller.batchStudents;
        final selectedDate = controller.selectedAttendanceDate.value;
        final presentCount = controller.attendanceStatuses.values.where((s) => s == 'PRESENT').length;
        final absentCount = controller.attendanceStatuses.values.where((s) => s == 'ABSENT').length;
        final lateCount = controller.attendanceStatuses.values.where((s) => s == 'LATE').length;

        return Column(
          children: [
            // Date Picker & Session Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.pureWhite,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session Date',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          selectedDate,
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(80, 36),
                    ),
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text('Change Date'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2027),
                      );
                      if (picked != null) {
                        controller.selectedAttendanceDate.value = DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                  ),
                ],
              ),
            ),

            // Live Attendance Stats Counter Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.lightBlueBackground.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatSummary('Total', '${students.length}', AppColors.deepNavy),
                  _buildStatSummary('Present', '$presentCount', AppColors.success),
                  _buildStatSummary('Absent', '$absentCount', AppColors.error),
                  _buildStatSummary('Late', '$lateCount', AppColors.warning),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),

            // Student Roster
            Expanded(
              child: students.isEmpty
                  ? Center(
                      child: Text(
                        'No students enrolled in this batch.',
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      itemCount: students.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final s = students[index];
                        final currentStatus = controller.attendanceStatuses[s.studentId] ?? 'PRESENT';

                        return RadianceCard(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    s.fullName.isNotEmpty ? s.fullName[0] : 'S',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryRoyalBlue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.fullName,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.deepNavy,
                                      ),
                                    ),
                                    Text(
                                      'Roll: ${s.rollNumber} • Class ${s.classLevel}',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Present / Absent / Late Choice Buttons
                              _buildStatusButton(s.studentId, 'PRESENT', 'P', currentStatus, AppColors.success),
                              const SizedBox(width: 6),
                              _buildStatusButton(s.studentId, 'ABSENT', 'A', currentStatus, AppColors.error),
                              const SizedBox(width: 6),
                              _buildStatusButton(s.studentId, 'LATE', 'L', currentStatus, AppColors.warning),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Submit Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.pureWhite,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: RadianceButton(
                label: 'Save & Finalize Attendance ($selectedDate)',
                icon: Icons.check_circle_outline,
                isLoading: controller.isLoading.value,
                onPressed: () => controller.submitBatchAttendance(selectedDate),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatSummary(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: color),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String studentId, String status, String label, String current, Color color) {
    final isSelected = current == status;

    return InkWell(
      onTap: () => controller.toggleAttendance(studentId, status),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isSelected ? AppColors.pureWhite : color,
            ),
          ),
        ),
      ),
    );
  }
}
