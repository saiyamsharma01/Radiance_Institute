import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/admin_controller.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          // Desktop Navigation Sidebar
          if (isDesktop) _buildSidebar(),

          // Main Dashboard Content
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(isDesktop),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.students.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    switch (controller.selectedNavIndex.value) {
                      case 1:
                        return _buildAdmissionsCrmView();
                      case 2:
                        return _buildStudentManagementView();
                      case 3:
                        return _buildBatchManagementView();
                      case 4:
                        return _buildFeeManagementView();
                      case 5:
                        return _buildAuditLogsView();
                      case 0:
                      default:
                        return _buildOverviewView();
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : Obx(() => BottomNavigationBar(
                currentIndex: controller.selectedNavIndex.value.clamp(0, 4),
                onTap: (index) => controller.selectedNavIndex.value = index,
                selectedItemColor: AppColors.primaryRoyalBlue,
                unselectedItemColor: AppColors.textMuted,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Overview'),
                  BottomNavigationBarItem(icon: Icon(Icons.contact_mail_outlined), label: 'CRM'),
                  BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Students'),
                  BottomNavigationBarItem(icon: Icon(Icons.layers_outlined), label: 'Batches'),
                  BottomNavigationBarItem(icon: Icon(Icons.account_balance_outlined), label: 'Fees'),
                ],
              )),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: AppColors.deepNavy,
      child: Column(
        children: [
          // Institute Logo & Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.pureWhite,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset('assets/images/radiance_logo.jpg', fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Radiance Institute',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.pureWhite,
                        ),
                      ),
                      Text(
                        'Admin Dashboard',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),

          // Sidebar Navigation Items
          _buildSidebarNavItem(0, 'Overview', Icons.dashboard_outlined),
          _buildSidebarNavItem(1, 'Admissions CRM', Icons.contact_mail_outlined, badgeCount: controller.newEnquiriesCount),
          _buildSidebarNavItem(2, 'Student Accounts', Icons.people_outline),
          _buildSidebarNavItem(3, 'Batches & Subjects', Icons.layers_outlined),
          _buildSidebarNavItem(4, 'Fees & Invoicing', Icons.account_balance_wallet_outlined),
          _buildSidebarNavItem(5, 'Audit Logs', Icons.security_outlined),

          const Spacer(),
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70, size: 20),
            title: Text(
              'Sign Out',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
            ),
            onTap: () => Get.find<AuthController>().logout(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem(int index, String title, IconData icon, {int badgeCount = 0}) {
    return Obx(() {
      final isSelected = controller.selectedNavIndex.value == index;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRoyalBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(icon, color: isSelected ? AppColors.pureWhite : Colors.white70, size: 20),
          title: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.pureWhite : Colors.white70,
            ),
          ),
          trailing: badgeCount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.pureWhite),
                  ),
                )
              : null,
          onTap: () => controller.selectedNavIndex.value = index,
        ),
      );
    });
  }

  Widget _buildTopHeader(bool isDesktop) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          Text(
            'Institute Governance & Operations',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.deepNavy,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, size: 16, color: AppColors.primaryRoyalBlue),
                const SizedBox(width: 6),
                Text(
                  'Super Admin: Active',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryRoyalBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            tooltip: 'Reload Data',
            onPressed: controller.loadAllAdminData,
          ),
        ],
      ),
    );
  }

  // 1. Overview Screen
  Widget _buildOverviewView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 4 Core High-Level Metric Tiles
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            return GridView.count(
              crossAxisCount: isWide ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isWide ? 1.6 : 1.3,
              children: [
                _buildKpiCard(
                  icon: Icons.people_alt_outlined,
                  label: 'Enrolled Students',
                  value: controller.students.length.toString(),
                  color: AppColors.primaryRoyalBlue,
                ),
                _buildKpiCard(
                  icon: Icons.layers_outlined,
                  label: 'Active Batches',
                  value: controller.batches.length.toString(),
                  color: AppColors.info,
                ),
                _buildKpiCard(
                  icon: Icons.mark_email_unread_outlined,
                  label: 'New Enquiries',
                  value: controller.newEnquiriesCount.toString(),
                  color: AppColors.accentGold,
                ),
                _buildKpiCard(
                  icon: Icons.currency_rupee,
                  label: 'Collected Fees',
                  value: CurrencyFormatter.formatPaise(controller.totalRevenuePaise),
                  color: AppColors.success,
                ),
              ],
            );
          }),
          const SizedBox(height: 28),

          // Recent Admission Enquiries & Outstanding Invoices
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Recent Enquiries
              Expanded(
                flex: 3,
                child: RadianceCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Admission Inquiries',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          TextButton(
                            onPressed: () => controller.selectedNavIndex.value = 1,
                            child: const Text('View All CRM'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.enquiries.take(3).length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final enq = controller.enquiries[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppColors.lightBlueBackground,
                              child: Text(
                                enq.studentName[0],
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primaryRoyalBlue),
                              ),
                            ),
                            title: Text(
                              '${enq.studentName} (Class ${enq.classLevel})',
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'Guardian: ${enq.guardianName} • Phone: ${enq.contactNumber}',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            trailing: StatusBadge(status: enq.status),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Right: Fee Summary
              Expanded(
                flex: 2,
                child: RadianceCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fee Reconciliation',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepNavy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLedgerRow('Verified Revenue', CurrencyFormatter.formatPaise(controller.totalRevenuePaise), AppColors.success),
                      const SizedBox(height: 10),
                      _buildLedgerRow('Pending Dues', CurrencyFormatter.formatPaise(controller.totalOutstandingPaise), AppColors.error),
                      const Divider(height: 24),
                      RadianceButton(
                        label: 'Issue Custom Invoice',
                        icon: Icons.add_card,
                        onPressed: () => _showInvoiceCreationDialog(Get.context!),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Admissions CRM Screen
  Widget _buildAdmissionsCrmView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Admission Enquiries & Pipeline CRM',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
              ),
              Text(
                'Total: ${controller.enquiries.length} Enquiries',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),

          RadianceCard(
            padding: const EdgeInsets.all(16),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Ref ID')),
                DataColumn(label: Text('Student')),
                DataColumn(label: Text('Class')),
                DataColumn(label: Text('Guardian & Phone')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Action')),
              ],
              rows: controller.enquiries.map((enq) {
                return DataRow(cells: [
                  DataCell(Text(enq.enquiryId, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                  DataCell(Text(enq.studentName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
                  DataCell(Text('Class ${enq.classLevel}', style: GoogleFonts.inter(fontSize: 13))),
                  DataCell(Text('${enq.guardianName} (${enq.contactNumber})', style: GoogleFonts.inter(fontSize: 12))),
                  DataCell(StatusBadge(status: enq.status)),
                  DataCell(
                    DropdownButton<String>(
                      value: enq.status,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 'NEW', child: Text('NEW')),
                        DropdownMenuItem(value: 'CONTACTED', child: Text('CONTACTED')),
                        DropdownMenuItem(value: 'VISIT_SCHEDULED', child: Text('VISIT SCHEDULED')),
                        DropdownMenuItem(value: 'ADMITTED', child: Text('ADMITTED')),
                        DropdownMenuItem(value: 'CLOSED', child: Text('CLOSED')),
                      ],
                      onChanged: (val) {
                        if (val != null) controller.updateEnquiryStatus(enq.enquiryId, val);
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Student Management Screen
  Widget _buildStudentManagementView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student Accounts & Enrolments',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
              ),
              RadianceButton(
                label: 'Enroll New Student',
                icon: Icons.person_add_alt_1,
                onPressed: () => _showStudentCreationDialog(Get.context!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          RadianceCard(
            padding: const EdgeInsets.all(16),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Student ID')),
                DataColumn(label: Text('Full Name')),
                DataColumn(label: Text('Roll No')),
                DataColumn(label: Text('Class Level')),
                DataColumn(label: Text('DOB')),
                DataColumn(label: Text('Emergency Contact')),
                DataColumn(label: Text('Linked Parents')),
              ],
              rows: controller.students.map((s) {
                return DataRow(cells: [
                  DataCell(Text(s.studentId, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                  DataCell(Text(s.fullName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
                  DataCell(Text(s.rollNumber, style: GoogleFonts.inter(fontSize: 13))),
                  DataCell(Text('Class ${s.classLevel}', style: GoogleFonts.inter(fontSize: 13))),
                  DataCell(Text(s.dateOfBirth, style: GoogleFonts.inter(fontSize: 12))),
                  DataCell(Text(s.emergencyContact, style: GoogleFonts.inter(fontSize: 12))),
                  DataCell(Text('${s.parentUids.length} linked', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryRoyalBlue))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Batch Management Screen
  Widget _buildBatchManagementView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Batch & Subject Catalog',
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.batches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final b = controller.batches[index];
              return RadianceCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlueBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.layers, color: AppColors.primaryRoyalBlue, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            'Class ${b.classLevel} • Subject: ${b.subject} • Academic Year: ${b.academicYear}',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          if (b.schedule.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Timetable: ${b.schedule.map((s) => '${s.dayOfWeek} ${s.startTime}-${s.endTime}').join(', ')}',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryRoyalBlue),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      '${b.enrolledStudentCount} Enrolled',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 5. Fee Management Screen
  Widget _buildFeeManagementView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fee Invoices & Ledger',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
              ),
              RadianceButton(
                label: 'Create Invoice',
                icon: Icons.add,
                onPressed: () => _showInvoiceCreationDialog(Get.context!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RadianceCard(
            padding: const EdgeInsets.all(16),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Invoice ID')),
                DataColumn(label: Text('Student')),
                DataColumn(label: Text('Period')),
                DataColumn(label: Text('Amount Due')),
                DataColumn(label: Text('Paid')),
                DataColumn(label: Text('Balance')),
                DataColumn(label: Text('Due Date')),
                DataColumn(label: Text('Status')),
              ],
              rows: controller.invoices.map((inv) {
                return DataRow(cells: [
                  DataCell(Text(inv.invoiceId, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600))),
                  DataCell(Text(inv.studentName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
                  DataCell(Text(inv.period, style: GoogleFonts.inter(fontSize: 12))),
                  DataCell(Text(inv.formattedAmountDue, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
                  DataCell(Text(inv.formattedAmountPaid, style: GoogleFonts.inter(fontSize: 12, color: AppColors.success))),
                  DataCell(Text(inv.formattedBalanceDue, style: GoogleFonts.inter(fontSize: 12, color: AppColors.error))),
                  DataCell(Text(inv.dueDate, style: GoogleFonts.inter(fontSize: 12))),
                  DataCell(StatusBadge(status: inv.status)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Audit Logs Screen
  Widget _buildAuditLogsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Security & System Audit Trail',
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 8),
          Text(
            'Immutable server-side record of administrative actions, fee adjustments, and role updates.',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          RadianceCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAuditItem('usr_admin_1', 'FEE_INVOICE_GENERATED', 'fee_invoices/INV-2026-00891', '10 mins ago'),
                const Divider(),
                _buildAuditItem('usr_teacher_phys', 'ATTENDANCE_MARKED', 'attendance/batch_c11_phys_a_2026-10-15', '2 hours ago'),
                const Divider(),
                _buildAuditItem('usr_parent_1', 'PARENT_CHILD_AUTO_LINKED', 'students/RAD-2026-0042', '1 day ago'),
                const Divider(),
                _buildAuditItem('usr_admin_1', 'RESULT_PUBLISHED', 'tests/test_phys_oct', '3 days ago'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditItem(String actor, String action, String resource, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.lock_clock, size: 20, color: AppColors.primaryRoyalBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                Text('Resource: $resource • Actor: $actor', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(time, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return RadianceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  void _showStudentCreationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Text('Enroll New Student', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller.studentNameController, decoration: const InputDecoration(labelText: 'Student Full Name')),
              const SizedBox(height: 10),
              TextField(controller: controller.rollNumberController, decoration: const InputDecoration(labelText: 'Roll Number (e.g. RAD11-099)')),
              const SizedBox(height: 10),
              TextField(controller: controller.dobController, decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)')),
              const SizedBox(height: 10),
              TextField(controller: controller.contactController, decoration: const InputDecoration(labelText: 'Emergency Mobile (+91)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(onPressed: controller.createStudent, child: const Text('Enroll')),
        ],
      ),
    );
  }

  void _showInvoiceCreationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Text('Issue Fee Invoice', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.invoiceStudentId.value.isNotEmpty ? controller.invoiceStudentId.value : null,
                    decoration: const InputDecoration(labelText: 'Select Student'),
                    items: controller.students.map((s) {
                      return DropdownMenuItem(value: s.studentId, child: Text('${s.fullName} (${s.rollNumber})'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.invoiceStudentId.value = val;
                    },
                  )),
              const SizedBox(height: 10),
              TextField(controller: controller.invoicePeriodController, decoration: const InputDecoration(labelText: 'Billing Period (e.g. November 2026)')),
              const SizedBox(height: 10),
              TextField(controller: controller.invoiceItemDescController, decoration: const InputDecoration(labelText: 'Item Description (e.g. Senior Secondary PCM Tuition)')),
              const SizedBox(height: 10),
              TextField(controller: controller.invoiceAmountRupeesController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (in ₹ Rupees)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(onPressed: controller.createInvoice, child: const Text('Issue Invoice')),
        ],
      ),
    );
  }
}
