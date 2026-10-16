import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../controllers/teacher_controller.dart';

class CreateHomeworkView extends GetView<TeacherController> {
  const CreateHomeworkView({super.key});

  @override
  Widget build(BuildContext context) {
    final batch = controller.selectedBatch.value;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: RadianceAppBar(
        title: 'Assign Homework',
        subtitle: batch?.name ?? 'Classroom Assignment',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: RadianceCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New Assignment Details',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: controller.hwTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Assignment Title',
                    hintText: 'e.g. Chapter 5: Thermodynamics Problem Set',
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: controller.hwDescController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Instructions & Problem Numbers',
                    hintText: 'Specify questions, reference pages, or instructions for submission...',
                  ),
                ),
                const SizedBox(height: 16),

                // Deadline selection
                Text(
                  'Submission Deadline',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Obx(() => Row(
                      children: [
                        _buildDeadlineChip('2 Days', 2),
                        const SizedBox(width: 8),
                        _buildDeadlineChip('3 Days', 3),
                        const SizedBox(width: 8),
                        _buildDeadlineChip('5 Days', 5),
                        const SizedBox(width: 8),
                        _buildDeadlineChip('1 Week', 7),
                      ],
                    )),
                const SizedBox(height: 24),

                Obx(() => RadianceButton(
                      label: 'Publish Assignment to Batch',
                      icon: Icons.send,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.createHomework,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlineChip(String label, int days) {
    final isSelected = controller.hwDeadlineDays.value == days;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryRoyalBlue,
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
      ),
      onSelected: (_) => controller.hwDeadlineDays.value = days,
    );
  }
}
