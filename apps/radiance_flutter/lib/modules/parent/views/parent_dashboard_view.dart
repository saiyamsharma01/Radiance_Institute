import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/radiance_app_bar.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/fee_models.dart';
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
        final attendancePct = controller.childAttendancePercentage.toStringAsFixed(1);

        return RefreshIndicator(
          onRefresh: controller.loadParentData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Linked Children Switcher Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Linked Students (${controller.linkedChildren.length})',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add_link, size: 18),
                      label: const Text('Link Child'),
                      onPressed: () => Get.toNamed(AppRoutes.parentChildLinking),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Horizontal list of linked children
                SizedBox(
                  height: 44,
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
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryRoyalBlue : AppColors.borderSubtle,
                        ),
                        label: Text(
                          '${item.fullName} (Class ${item.classLevel})',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => controller.selectChild(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Active Child Academic Card
                if (child != null)
                  Container(
                    padding: const EdgeInsets.all(18),
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
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              child.fullName.isNotEmpty ? child.fullName[0] : 'S',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryRoyalBlue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                child.fullName,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Roll No: ${child.rollNumber} • Class ${child.classLevel}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.lightBlueBackground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'DOB: ${child.dateOfBirth} • Emergency: ${child.emergencyContact}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
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
                            'ENROLLED',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.pureWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Outstanding Tuition Alert Card
                if (unpaidInvoice != null) ...[
                  RadianceCard(
                    backgroundColor: AppColors.warningLight.withOpacity(0.35),
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
                        const SizedBox(height: 14),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 10,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Balance Due',
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
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
                    childAspectRatio: isWide ? 2.5 : 2.4,
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
                              child: const Icon(Icons.fact_check_outlined, color: AppColors.success, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Attendance ($attendancePct%)',
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${controller.childAttendance.where((a) => a.status == 'PRESENT').length} / ${controller.childAttendance.length} Sessions Present',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
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
                              child: const Icon(Icons.grade_outlined, color: AppColors.primaryRoyalBlue, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Latest Test Result',
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    controller.childResults.isNotEmpty
                                        ? '${controller.childResults.first.marksObtained.toStringAsFixed(0)} / ${controller.childResults.first.totalMarks.toStringAsFixed(0)} (${controller.childResults.first.percentage}%)'
                                        : 'No tests published',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
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

                // Invoices & Payment Receipts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Invoices & Statements',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepNavy,
                        ),
                      ),
                    ),
                    Text(
                      '${invoices.length} Invoices',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ],
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
                      onTap: isPaid ? () => _showReceiptDetails(context, inv) : null,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  inv.invoiceId,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showReceiptDetails(BuildContext context, FeeInvoiceModel invoice) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Row(
          children: [
            const Icon(Icons.verified, color: AppColors.success, size: 24),
            const SizedBox(width: 8),
            Text('Official Payment Receipt', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Radiance Institute — Amritsar', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
            const Divider(height: 20),
            _buildReceiptRow('Invoice Ref', invoice.invoiceId),
            _buildReceiptRow('Student Name', invoice.studentName),
            _buildReceiptRow('Billing Period', invoice.period),
            _buildReceiptRow('Amount Paid', invoice.formattedAmountDue),
            _buildReceiptRow('Payment Status', 'SUCCESSFUL (PAID)'),
            _buildReceiptRow('Gateway Ref', 'pay_rzp_mock_gateway'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.successLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'This digitally signed receipt is official verification of tuition fee settlement.',
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Close Receipt'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
        ],
      ),
    );
  }
}
