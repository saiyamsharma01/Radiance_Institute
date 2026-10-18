import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../controllers/student_controller.dart';

class StudentTestsView extends GetView<StudentController> {
  const StudentTestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxString selectedSubject = 'ALL'.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const RadianceAppBar(
        title: 'Tests & Results',
        subtitle: 'Published Academic Assessments',
      ),
      body: Obx(() {
        final allResults = controller.testResults;

        if (allResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics_outlined, size: 54, color: AppColors.textMuted.withOpacity(0.5)),
                const SizedBox(height: 12),
                Text(
                  'No published test results found',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Test results will appear here once faculty publishes them.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        // Calculate average score
        final double avgScore = allResults.fold(0.0, (sum, r) => sum + r.percentage) / allResults.length;

        final filtered = selectedSubject.value == 'ALL'
            ? allResults
            : allResults.where((r) => (r.subject ?? '').toUpperCase() == selectedSubject.value.toUpperCase()).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Academic Performance Summary Card
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
                          'Average Performance',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.lightBlueBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${avgScore.toStringAsFixed(1)}%',
                          style: GoogleFonts.outfit(
                            fontSize: 32,
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
                        '${allResults.length} Tests Evaluated',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ALL', 'All Subjects', selectedSubject),
                    const SizedBox(width: 8),
                    _buildFilterChip('Physics', 'Physics', selectedSubject),
                    const SizedBox(width: 8),
                    _buildFilterChip('Chemistry', 'Chemistry', selectedSubject),
                    const SizedBox(width: 8),
                    _buildFilterChip('Mathematics', 'Mathematics', selectedSubject),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tests List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final res = filtered[index];
                  final testTitle = res.testTitle ?? 'Curriculum Test Assessment';
                  final subject = res.subject ?? 'Core Subject';
                  final testDate = res.testDate ?? 'October 2026';
                  final grade = _calculateGrade(res.percentage);

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
                                subject,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryRoyalBlue,
                                ),
                              ),
                            ),
                            const StatusBadge(status: 'PUBLISHED'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          testTitle,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Evaluated On: $testDate • Roll: RAD11-042',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _buildScoreChip('Marks Obtained', '${res.marksObtained.toStringAsFixed(0)} / ${res.totalMarks.toStringAsFixed(0)}'),
                            const SizedBox(width: 10),
                            _buildScoreChip('Score', '${res.percentage}%', isHighlight: true),
                            const SizedBox(width: 10),
                            _buildScoreChip('Grade', grade),
                          ],
                        ),
                        if (res.feedback != null && res.feedback!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.softBlueSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.comment_outlined, size: 16, color: AppColors.primaryRoyalBlue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Faculty Remark: ${res.feedback}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildFilterChip(String key, String label, RxString selectedSubject) {
    return Obx(() {
      final isSelected = selectedSubject.value == key;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryRoyalBlue,
        backgroundColor: AppColors.pureWhite,
        side: const BorderSide(color: AppColors.borderSubtle),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
        ),
        onSelected: (_) => selectedSubject.value = key,
      );
    });
  }

  String _calculateGrade(double pct) {
    if (pct >= 90) return 'A+';
    if (pct >= 80) return 'A';
    if (pct >= 70) return 'B+';
    if (pct >= 60) return 'B';
    if (pct >= 50) return 'C';
    return 'D';
  }

  Widget _buildScoreChip(String label, String value, {bool isHighlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isHighlight ? AppColors.lightBlueBackground : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isHighlight ? AppColors.primaryRoyalBlue.withOpacity(0.3) : AppColors.borderSubtle,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isHighlight ? AppColors.primaryRoyalBlue : AppColors.deepNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
