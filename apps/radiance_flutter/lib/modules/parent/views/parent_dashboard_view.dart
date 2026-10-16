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
import '../controllers/parent_controller.dart';

class ParentDashboardView extends GetView<ParentController> {
  const ParentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: RadianceAppBar(
        title: 'Parent Portal',
        subtitle: 'Student Progress & Institute Services',
        onLogout: () => Get.find<AuthController>().logout(),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.activeChild.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final child = controller.activeChild.value;
        final invoices = controller.childInvoices;
        final unpaidInvoice = invoices.firstWhereOrNull((i) => i.status != 'PAID');

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Children Switcher Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Linked Students (${controller.linkedChildren.length})',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Link Another Child'),
                    onPressed: () => Get.toNamed(AppRoutes.parentChildLinking),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Horizontal list of linked children
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.linkedChildren.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = controller.linkedChildren[index];
                    final isSelected = item.studentId == child?.studentId;

                    return ChoiceChip(
                      selectedColor: AppColors.primaryRoyalBlue,
                      backgroundColor: AppColors.pureWhite,
                      label: Text(
                        '${item.fullName} (Class ${item.classLevel})',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => controller.selectChild(item),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Active Child Academic Card
              if (child != null)
                RadianceCard(
                  backgroundColor: AppColors.pureWhite,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: AppColors.primaryRoyalBlue,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child.fullName,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepNavy,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Roll No: ${child.rollNumber} • Class ${child.classLevel}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'DOB: ${child.dateOfBirth}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const StatusBadge(status: 'ACTIVE'),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Outstanding Tuition Alert Card
              if (unpaidInvoice != null) ...[
                RadianceCard(
                  backgroundColor: AppColors.warningLight.withOpacity(0.4),
                  border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payment, color: AppColors.warning, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                'Tuition Fee Due',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepNavy,
                                ),
                              ),
                            ],
                          ),
                          StatusBadge(status: unpaidInvoice.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Invoice #${unpaidInvoice.invoiceId} for ${unpaidInvoice.period} is due on ${unpaidInvoice.dueDate}.',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Balance Due',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                              ),
                              Text(
                                unpaidInvoice.formattedBalanceDue,
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryRoyalBlue,
                                ),
                              ),
                            ],
                          ),
                          RadianceButton(
                            label: 'Pay Now (Sandbox)',
                            icon: Icons.lock_outline,
                            isLoading: controller.isLoading.value,
                            onPressed: () => controller.payInvoice(unpaidInvoice),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Academic Highlights (Attendance & Test Results)
              Text(
                'Academic Performance',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return GridView.count(
                  crossAxisCount: isWide ? 2 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: isWide ? 2.5 : 2.2,
                  children: [
                    // Attendance Summary
                    RadianceCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.fact_check, color: AppColors.success, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Attendance Record',
                                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${controller.childAttendance.where((a) => a.status == 'PRESENT').length} / ${controller.childAttendance.length} Sessions Present',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepNavy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Test Results Summary
                    RadianceCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.grade, color: AppColors.primaryRoyalBlue, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Latest Published Assessment',
                                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  controller.childResults.isNotEmpty
                                      ? '${controller.childResults.first.marksObtained} / ${controller.childResults.first.totalMarks} (${controller.childResults.first.percentage}%)'
                                      : 'No tests published',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepNavy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),

              // Fee Invoices and Verified Receipts History
              Text(
                'Invoices & Payment Receipts',
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
                itemCount: invoices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final inv = invoices[index];
                  final isPaid = inv.status == 'PAID';

                  return RadianceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inv.invoiceId,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepNavy,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${inv.period} • Due: ${inv.dueDate}',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              inv.formattedAmountDue,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isPaid ? AppColors.success : AppColors.primaryRoyalBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            StatusBadge(status: inv.status),
                          ],
                        ),
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
