import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../controllers/student_controller.dart';

class StudentHomeworkView extends GetView<StudentController> {
  const StudentHomeworkView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxString selectedFilter = 'ALL'.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const RadianceAppBar(
        title: 'Homework & Tasks',
        subtitle: 'Classroom Assignments & Deadlines',
      ),
      body: Obx(() {
        final homeworkList = controller.homeworkList;
        final sId = controller.activeStudentId.value;

        final filtered = selectedFilter.value == 'ALL'
            ? homeworkList
            : homeworkList.where((hw) {
                final isSubmitted = hw.submissions.any((s) => s.studentId == sId);
                if (selectedFilter.value == 'PENDING') return !isSubmitted;
                if (selectedFilter.value == 'SUBMITTED') return isSubmitted;
                return true;
              }).toList();

        return Column(
          children: [
            // Filter Pills
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.pureWhite,
              child: Row(
                children: [
                  _buildFilterChip('ALL', 'All Tasks (${homeworkList.length})', selectedFilter),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'PENDING',
                    'Pending (${homeworkList.where((h) => !h.submissions.any((s) => s.studentId == sId)).length})',
                    selectedFilter,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'SUBMITTED',
                    'Submitted (${homeworkList.where((h) => h.submissions.any((s) => s.studentId == sId)).length})',
                    selectedFilter,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),

            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, size: 54, color: AppColors.textMuted.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No homework assignments found',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Great job! All assigned tasks are accounted for.',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final hw = filtered[index];
                        final submission = hw.submissions.firstWhereOrNull(
                          (s) => s.studentId == sId,
                        );
                        final isSubmitted = submission != null;

                        return RadianceCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightBlueBackground,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      hw.subject,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryRoyalBlue,
                                      ),
                                    ),
                                  ),
                                  StatusBadge(status: submission?.status ?? 'PENDING'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                hw.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                hw.description,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.schedule, size: 16, color: AppColors.warning),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Due: ${hw.deadline.day}/${hw.deadline.month}/${hw.deadline.year}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              if (submission != null && submission.feedback != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.verified, size: 16, color: AppColors.success),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Teacher Evaluation: Score ${submission.score ?? '10'}/10',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.deepNavy,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        submission.feedback!,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (!isSubmitted) ...[
                                const SizedBox(height: 14),
                                RadianceButton(
                                  label: 'Submit Assignment Solution',
                                  icon: Icons.upload_file,
                                  onPressed: () => _showSubmissionDialog(context, hw.homeworkId, hw.title),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChip(String key, String label, RxString selectedFilter) {
    return Obx(() {
      final isSelected = selectedFilter.value == key;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryRoyalBlue,
        backgroundColor: AppColors.backgroundLight,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
        ),
        onSelected: (_) => selectedFilter.value = key,
      );
    });
  }

  void _showSubmissionDialog(BuildContext context, String homeworkId, String title) {
    final notesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Text(
          'Submit Homework',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.deepNavy),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderSubtle),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.softBlueSurface,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: AppColors.primaryRoyalBlue, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'solution_worksheet.pdf',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                          ),
                          Text(
                            'Ready to upload (1.4 MB)',
                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes to Teacher (Optional)',
                  hintText: 'e.g., Solved with step-by-step vector method',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.submitHomeworkSolution(homeworkId, notesController.text.trim());
            },
            child: const Text('Confirm Upload'),
          ),
        ],
      ),
    );
  }
}
