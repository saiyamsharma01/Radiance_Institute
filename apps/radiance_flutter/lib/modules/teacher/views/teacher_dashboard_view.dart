import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/radiance_app_bar.dart';
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

        return RefreshIndicator(
          onRefresh: controller.loadTeacherData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Assigned Batches Header
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
                  height: 44,
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
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryRoyalBlue : AppColors.borderSubtle,
                        ),
                        label: Text(
                          b.name,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => controller.selectBatch(b),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Active Batch Overview Card
                if (batch != null)
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    batch.name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.pureWhite,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Class ${batch.classLevel} • Subject: ${batch.subject} • ${controller.batchStudents.length} Students',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.lightBlueBackground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: Colors.white24),

                        // Action Buttons Row
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.pureWhite,
                                foregroundColor: AppColors.primaryRoyalBlue,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.checklist, size: 18),
                              label: Text('Mark Attendance', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13)),
                              onPressed: () => Get.toNamed(AppRoutes.markAttendance),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.pureWhite.withOpacity(0.15),
                                foregroundColor: AppColors.pureWhite,
                                elevation: 0,
                                side: const BorderSide(color: Colors.white30),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.post_add, size: 18),
                              label: Text('Assign Homework', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                              onPressed: () => Get.toNamed(AppRoutes.createHomework),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.pureWhite.withOpacity(0.15),
                                foregroundColor: AppColors.pureWhite,
                                elevation: 0,
                                side: const BorderSide(color: Colors.white30),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.add_chart, size: 18),
                              label: Text('Create Test', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                              onPressed: () => _showCreateTestDialog(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Batch Homework & Assignments
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Assignments in this Batch',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.batchHomework.length} Active',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (controller.batchHomework.isEmpty)
                  RadianceCard(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No homework assignments created yet for this batch.',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Due: ${hw.deadline.day}/${hw.deadline.month} • ${hw.submissions.length} Submissions Received',
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(
                              status: hw.submissions.length >= controller.batchStudents.length
                                  ? 'COMPLETED'
                                  : 'IN_PROGRESS',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Batch Tests & Published Results
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Tests & Assessments',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.batchTests.length} Tests',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (controller.batchTests.isEmpty)
                  RadianceCard(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No tests recorded yet. Tap "Create Test" to evaluate students.',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.batchTests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final t = controller.batchTests[index];
                      final isPublished = t.status == 'PUBLISHED';

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
                                    t.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Date: ${t.testDate} • Total Marks: ${t.totalMarks.toStringAsFixed(0)} • ${t.results.length} Scored',
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            if (!isPublished)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryRoyalBlue,
                                  foregroundColor: AppColors.pureWhite,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: const Size(60, 32),
                                ),
                                onPressed: () => controller.publishTest(t.testId),
                                child: const Text('Publish'),
                              )
                            else
                              const StatusBadge(status: 'PUBLISHED'),
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

  void _showCreateTestDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final totalMarksCtrl = TextEditingController(text: '100');
    final dateCtrl = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final marksMap = <String, double>{};

    for (final s in controller.batchStudents) {
      marksMap[s.studentId] = 85.0; // default initial score
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Text(
          'Create & Publish Test',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.deepNavy),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Test Title',
                  hintText: 'e.g. Kinematics Chapter Test',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: totalMarksCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Marks'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(labelText: 'Test Date (YYYY-MM-DD)'),
              ),
              const SizedBox(height: 14),
              Text(
                'Student Marks Entry (${controller.batchStudents.length} Students):',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 8),
              ...controller.batchStudents.map((s) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.fullName,
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          initialValue: (marksMap[s.studentId] ?? 85.0).toStringAsFixed(0),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onChanged: (val) {
                            final numVal = double.tryParse(val);
                            if (numVal != null) marksMap[s.studentId] = numVal;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final totalMarks = double.tryParse(totalMarksCtrl.text.trim()) ?? 100.0;
              final testDate = dateCtrl.text.trim();
              if (title.isEmpty) {
                Get.snackbar('Error', 'Please enter test title.');
                return;
              }
              controller.createTestAndPublish(
                title: title,
                totalMarks: totalMarks,
                testDate: testDate,
                marksMap: marksMap,
              );
            },
            child: const Text('Publish Results'),
          ),
        ],
      ),
    );
  }
}
