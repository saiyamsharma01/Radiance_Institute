import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/radiance_button.dart';
import '../../../core/widgets/radiance_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/user_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/admin_controller.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      drawer: isDesktop ? null : Drawer(child: _buildSidebar(isDrawer: true)),
      body: Row(
        children: [
          // Desktop Navigation Sidebar
          if (isDesktop) _buildSidebar(),

          // Main Dashboard Content
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(isDesktop),
                if (!isDesktop) _buildMobileCategoryPills(),
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
                currentIndex: controller.selectedNavIndex.value > 4 ? 0 : controller.selectedNavIndex.value,
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

  Widget _buildSidebar({bool isDrawer = false}) {
    return Container(
      width: isDrawer ? 280 : 250,
      color: AppColors.deepNavy,
      child: SafeArea(
        child: Column(
          children: [
            // Institute Logo & Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    child: Image.asset('assets/images/radiance_logo.jpg', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.school, color: AppColors.primaryRoyalBlue)),
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
                            fontWeight: FontWeight.w600,
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
            _buildSidebarNavItem(0, 'Overview', Icons.dashboard_outlined, isDrawer: isDrawer),
            _buildSidebarNavItem(1, 'Admissions CRM', Icons.contact_mail_outlined, badgeCount: controller.newEnquiriesCount, isDrawer: isDrawer),
            _buildSidebarNavItem(2, 'Student Accounts', Icons.people_outline, isDrawer: isDrawer),
            _buildSidebarNavItem(3, 'Batches & Subjects', Icons.layers_outlined, isDrawer: isDrawer),
            _buildSidebarNavItem(4, 'Fees & Invoicing', Icons.account_balance_wallet_outlined, isDrawer: isDrawer),
            _buildSidebarNavItem(5, 'Audit Logs', Icons.security_outlined, isDrawer: isDrawer),

            const Spacer(),
            const Divider(color: Colors.white24, height: 1),

            // Role quick-switch menu in drawer
            if (isDrawer && Get.isRegistered<AuthController>()) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('SWITCH PORTAL VIEW', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white54, letterSpacing: 0.5)),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.school_outlined, color: Colors.white70, size: 18),
                title: Text('Student Portal', style: GoogleFonts.inter(fontSize: 12, color: Colors.white)),
                onTap: () {
                  Get.back();
                  Get.find<AuthController>().switchRole(UserRole.student);
                },
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.family_restroom_outlined, color: Colors.white70, size: 18),
                title: Text('Parent Portal', style: GoogleFonts.inter(fontSize: 12, color: Colors.white)),
                onTap: () {
                  Get.back();
                  Get.find<AuthController>().switchRole(UserRole.parent);
                },
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.psychology_outlined, color: Colors.white70, size: 18),
                title: Text('Faculty Portal', style: GoogleFonts.inter(fontSize: 12, color: Colors.white)),
                onTap: () {
                  Get.back();
                  Get.find<AuthController>().switchRole(UserRole.teacher);
                },
              ),
              const Divider(color: Colors.white24, height: 1),
            ],

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white70, size: 20),
              title: Text(
                'Sign Out',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
              ),
              onTap: () {
                if (isDrawer) Get.back();
                Get.find<AuthController>().logout();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarNavItem(int index, String title, IconData icon, {int badgeCount = 0, bool isDrawer = false}) {
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
          onTap: () {
            controller.selectedNavIndex.value = index;
            if (isDrawer) Get.back();
          },
        ),
      );
    });
  }

  Widget _buildTopHeader(bool isDesktop) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 10),
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.deepNavy, size: 18),
              tooltip: 'Exit Admin Portal',
              onPressed: () => Get.back(),
            ),
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_open_rounded, color: AppColors.deepNavy, size: 22),
                tooltip: 'All Sections',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            const SizedBox(width: 2),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isDesktop ? 'Institute Governance & Operations' : 'Admin Portal',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepNavy,
                  ),
                ),
                Text(
                  isDesktop ? 'Radiance Executive Governance • Real-Time Systems' : 'Governance & Admissions',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lightBlueBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryRoyalBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, size: 15, color: AppColors.primaryRoyalBlue),
                  const SizedBox(width: 6),
                  Text(
                    'Super Admin: Active',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryRoyalBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackground.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.sync, color: AppColors.primaryRoyalBlue, size: 19),
              tooltip: 'Sync Data',
              onPressed: controller.loadAllAdminData,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCategoryPills() {
    final tabs = [
      {'title': 'Overview', 'icon': Icons.dashboard_outlined, 'index': 0},
      {'title': 'CRM Pipeline', 'icon': Icons.contact_mail_outlined, 'index': 1, 'badge': controller.newEnquiriesCount},
      {'title': 'Students', 'icon': Icons.people_outline, 'index': 2},
      {'title': 'Batches', 'icon': Icons.layers_outlined, 'index': 3},
      {'title': 'Fee Ledger', 'icon': Icons.account_balance_outlined, 'index': 4},
      {'title': 'Audit Logs', 'icon': Icons.security_outlined, 'index': 5},
    ];

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final tab = tabs[i];
          final idx = tab['index'] as int;
          return Obx(() {
            final isSelected = controller.selectedNavIndex.value == idx;
            final badge = tab['badge'] as int? ?? 0;

            return InkWell(
              onTap: () => controller.selectedNavIndex.value = idx,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [AppColors.deepNavy, AppColors.primaryRoyalBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : AppColors.lightBlueBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryRoyalBlue : AppColors.borderSubtle,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      size: 14,
                      color: isSelected ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
                      ),
                    ),
                    if (badge > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accentGold : AppColors.primaryRoyalBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$badge',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // 1. Overview Screen
  Widget _buildOverviewView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Executive Hero Governance Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.deepNavy, Color(0xFF1B3D74), AppColors.primaryRoyalBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRoyalBlue.withOpacity(0.22),
                  blurRadius: 14,
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.pureWhite.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified, size: 12, color: AppColors.accentGold),
                                    const SizedBox(width: 4),
                                    Text(
                                      'SUPER ADMIN GOVERNANCE',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.pureWhite,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Radiance Executive Control Center',
                            style: GoogleFonts.outfit(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.pureWhite,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Session 2026-27 • Amritsar Campus • Real-Time Database Active',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.lightBlueBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildHeroActionChip(
                      icon: Icons.person_add_alt_1,
                      label: 'Record Enquiry',
                      onTap: () => _showEnquiryCreationDialog(Get.context!),
                    ),
                    _buildHeroActionChip(
                      icon: Icons.add_circle_outline,
                      label: 'Create Batch',
                      onTap: () => _showBatchCreationDialog(Get.context!),
                    ),
                    _buildHeroActionChip(
                      icon: Icons.receipt_long,
                      label: 'Issue Invoice',
                      onTap: () => _showInvoiceCreationDialog(Get.context!),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4 Core High-Level Metric Tiles (Responsive Grid)
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            return GridView.count(
              crossAxisCount: isWide ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isWide ? 1.55 : 1.25,
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
          const SizedBox(height: 22),

          // Recent Admission Enquiries & Outstanding Invoices
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 750;
            final enquiriesCard = RadianceCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Recent Admission Inquiries',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => controller.selectedNavIndex.value = 1,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                        ),
                        child: const Text('View All CRM'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.enquiries.take(3).length,
                    separatorBuilder: (_, __) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final enq = controller.enquiries[index];
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.lightBlueBackground,
                            child: Text(
                              enq.studentName.isNotEmpty ? enq.studentName[0] : 'S',
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primaryRoyalBlue),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${enq.studentName} (Class ${enq.classLevel})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                                ),
                                Text(
                                  'Guardian: ${enq.guardianName} • Phone: ${enq.contactNumber}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          StatusBadge(status: enq.status),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );

            final invoicesCard = RadianceCard(
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
                  const SizedBox(height: 12),
                  Builder(builder: (_) {
                    final totalBilled = controller.totalRevenuePaise + controller.totalOutstandingPaise;
                    final ratio = totalBilled > 0 ? (controller.totalRevenuePaise / totalBilled).clamp(0.0, 1.0) : 1.0;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Collection Rate: ${(ratio * 100).toStringAsFixed(1)}%',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success),
                            ),
                            Text(
                              '${(100 - (ratio * 100)).toStringAsFixed(1)}% Outstanding',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 6,
                            backgroundColor: AppColors.errorLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                          ),
                        ),
                      ],
                    );
                  }),
                  const Divider(height: 24),
                  RadianceButton(
                    label: 'Issue Custom Invoice',
                    icon: Icons.add_card,
                    onPressed: () => _showInvoiceCreationDialog(context),
                  ),
                ],
              ),
            );

            if (!isWide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  enquiriesCard,
                  const SizedBox(height: 20),
                  invoicesCard,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: enquiriesCard),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: invoicesCard),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeroActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.pureWhite),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.pureWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Admissions CRM Screen
  Widget _buildAdmissionsCrmView() {
    final isMobile = MediaQuery.of(Get.context!).size.width < 700;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Admission Enquiries & Pipeline CRM',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRoyalBlue,
                  foregroundColor: AppColors.pureWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(100, 36),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Enquiry'),
                onPressed: () => _showEnquiryCreationDialog(Get.context!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search and Status Filters
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by student name, guardian or phone...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: Obx(() => controller.crmSearchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => controller.crmSearchQuery.value = '',
                    )
                  : const SizedBox.shrink()),
            ),
            onChanged: (val) => controller.crmSearchQuery.value = val,
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCrmFilterChip('ALL', 'All (${controller.enquiries.length})'),
                const SizedBox(width: 8),
                _buildCrmFilterChip('NEW', 'New (${controller.enquiries.where((e) => e.status == 'NEW').length})'),
                const SizedBox(width: 8),
                _buildCrmFilterChip('CONTACTED', 'Contacted'),
                const SizedBox(width: 8),
                _buildCrmFilterChip('VISIT_SCHEDULED', 'Visit Scheduled'),
                const SizedBox(width: 8),
                _buildCrmFilterChip('ADMITTED', 'Admitted'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Obx(() {
            final list = controller.filteredEnquiries;

            if (list.isEmpty) {
              return RadianceCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text('No enquiries match the current filter or search criteria.', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                ),
              );
            }

            if (isMobile) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final enq = list[index];
                  return RadianceCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(enq.enquiryId, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryRoyalBlue)),
                            StatusBadge(status: enq.status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${enq.studentName} (Class ${enq.classLevel})',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                        ),
                        const SizedBox(height: 2),
                        Text('Guardian: ${enq.guardianName} • Phone: ${enq.contactNumber}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                        if (enq.message.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(enq.message, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary)),
                        ],
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Text('Update Status:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: enq.status,
                                isDense: true,
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryRoyalBlue),
                                items: const [
                                  DropdownMenuItem(value: 'NEW', child: Text('NEW')),
                                  DropdownMenuItem(value: 'CONTACTED', child: Text('CONTACTED')),
                                  DropdownMenuItem(value: 'VISIT_SCHEDULED', child: Text('VISIT SCHED.')),
                                  DropdownMenuItem(value: 'ADMITTED', child: Text('ADMITTED')),
                                  DropdownMenuItem(value: 'CLOSED', child: Text('CLOSED')),
                                ],
                                onChanged: (val) {
                                  if (val != null) controller.updateEnquiryStatus(enq.enquiryId, val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return RadianceCard(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Ref ID')),
                    DataColumn(label: Text('Student')),
                    DataColumn(label: Text('Class')),
                    DataColumn(label: Text('Guardian & Phone')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: list.map((enq) {
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
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCrmFilterChip(String key, String label) {
    return Obx(() {
      final isSelected = controller.crmStatusFilter.value == key;
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
        onSelected: (_) => controller.crmStatusFilter.value = key,
      );
    });
  }

  // 3. Student Management Screen
  Widget _buildStudentManagementView() {
    final isMobile = MediaQuery.of(Get.context!).size.width < 700;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Student Accounts & Enrolments',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
              ),
              RadianceButton(
                label: 'Enroll Student',
                icon: Icons.person_add_alt_1,
                onPressed: () => _showStudentCreationDialog(Get.context!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            decoration: InputDecoration(
              hintText: 'Search by student name, roll number, or student ID...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: Obx(() => controller.studentSearchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => controller.studentSearchQuery.value = '',
                    )
                  : const SizedBox.shrink()),
            ),
            onChanged: (val) => controller.studentSearchQuery.value = val,
          ),
          const SizedBox(height: 16),

          Obx(() {
            final list = controller.filteredStudents;

            if (list.isEmpty) {
              return RadianceCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text('No students found matching your search.', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                ),
              );
            }

            if (isMobile) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final s = list[index];
                  return RadianceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.lightBlueBackground,
                          child: Text(
                            s.fullName.isNotEmpty ? s.fullName[0] : 'S',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primaryRoyalBlue),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.fullName, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                              const SizedBox(height: 2),
                              Text('Roll: ${s.rollNumber} • Class ${s.classLevel} (${s.academicYear})', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                              Text('DOB: ${s.dateOfBirth} • Contact: ${s.emergencyContact}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlueBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${s.parentUids.length} linked',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryRoyalBlue),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return RadianceCard(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                  rows: list.map((s) {
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
            );
          }),
        ],
      ),
    );
  }

  // 4. Batch Management Screen
  Widget _buildBatchManagementView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Batch & Subject Catalog',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRoyalBlue,
                  foregroundColor: AppColors.pureWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(100, 36),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Batch'),
                onPressed: () => _showBatchCreationDialog(Get.context!),
              ),
            ],
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlueBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.layers, color: AppColors.primaryRoyalBlue, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.name, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                              const SizedBox(height: 2),
                              Text(
                                'Class ${b.classLevel} • Subject: ${b.subject} • Session: ${b.academicYear}',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRoyalBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${b.enrolledStudentCount} Enrolled',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryRoyalBlue),
                          ),
                        ),
                      ],
                    ),
                    if (b.schedule.isNotEmpty) ...[
                      const Divider(height: 18),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: b.schedule.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule, size: 12, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  '${s.dayOfWeek} ${s.startTime}-${s.endTime} (${s.room})',
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.deepNavy),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
  }

  // 5. Fee Management Screen
  Widget _buildFeeManagementView() {
    final isMobile = MediaQuery.of(Get.context!).size.width < 700;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Fee Invoices & Ledger',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
              ),
              RadianceButton(
                label: 'Create Invoice',
                icon: Icons.add,
                onPressed: () => _showInvoiceCreationDialog(Get.context!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            decoration: InputDecoration(
              hintText: 'Search invoices by ID, student name, or period...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: Obx(() => controller.invoiceSearchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => controller.invoiceSearchQuery.value = '',
                    )
                  : const SizedBox.shrink()),
            ),
            onChanged: (val) => controller.invoiceSearchQuery.value = val,
          ),
          const SizedBox(height: 16),

          Obx(() {
            final list = controller.filteredInvoices;

            if (list.isEmpty) {
              return RadianceCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text('No fee invoices found.', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                ),
              );
            }

            if (isMobile) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final inv = list[index];
                  return RadianceCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(inv.invoiceId, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                            StatusBadge(status: inv.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(inv.studentName, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryRoyalBlue)),
                        Text('Period: ${inv.period} • Due: ${inv.dueDate}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInvoiceStatCol('Amount Due', inv.formattedAmountDue, AppColors.deepNavy),
                            _buildInvoiceStatCol('Paid', inv.formattedAmountPaid, AppColors.success),
                            _buildInvoiceStatCol('Balance', inv.formattedBalanceDue, AppColors.error),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return RadianceCard(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                  rows: list.map((inv) {
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
            );
          }),
        ],
      ),
    );
  }

  // 6. Audit Logs Screen (Dynamic)
  Widget _buildAuditLogsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Security & System Audit Trail',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 6),
          Text(
            'Live server-side record of administrative actions, fee adjustments, and role updates.',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          Obx(() {
            final logs = controller.filteredAuditLogs;

            return RadianceCard(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final formattedDate = DateFormat('dd MMM, hh:mm a').format(log.timestamp);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shield_outlined, size: 20, color: AppColors.primaryRoyalBlue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    log.action,
                                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(formattedDate, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Resource: ${log.resource} • Actor: ${log.actorUid} (${log.actorRole})',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            if (log.details != null && log.details!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                log.details!,
                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'LIVE',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
        const SizedBox(width: 8),
        Text(value, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildInvoiceStatCol(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
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
                    isExpanded: true,
                    value: controller.invoiceStudentId.value.isNotEmpty ? controller.invoiceStudentId.value : null,
                    decoration: const InputDecoration(labelText: 'Select Student'),
                    items: controller.students.map((s) {
                      return DropdownMenuItem(
                        value: s.studentId,
                        child: Text(
                          '${s.fullName} (${s.rollNumber})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
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

  void _showBatchCreationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Text('Create New Batch', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller.batchNameController, decoration: const InputDecoration(labelText: 'Batch Name (e.g. Class 11 Physics Advanced)')),
              const SizedBox(height: 10),
              TextField(controller: controller.batchSubjectController, decoration: const InputDecoration(labelText: 'Subject (Physics, Chemistry, Math)')),
              const SizedBox(height: 10),
              TextField(controller: controller.batchRoomController, decoration: const InputDecoration(labelText: 'Lecture Room (e.g. Hall B)')),
              const SizedBox(height: 10),
              TextField(controller: controller.batchTimeController, decoration: const InputDecoration(labelText: 'Schedule Time (e.g. 15:00 - 16:30)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(onPressed: controller.createBatch, child: const Text('Create Batch')),
        ],
      ),
    );
  }

  void _showEnquiryCreationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.pureWhite,
        title: Text('Record Admission Enquiry', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller.enquiryNameController, decoration: const InputDecoration(labelText: 'Student Name')),
              const SizedBox(height: 10),
              TextField(controller: controller.enquiryGuardianController, decoration: const InputDecoration(labelText: 'Parent / Guardian Name')),
              const SizedBox(height: 10),
              TextField(controller: controller.enquiryPhoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Contact Phone Number')),
              const SizedBox(height: 10),
              TextField(controller: controller.enquiryMessageController, maxLines: 2, decoration: const InputDecoration(labelText: 'Notes / Query Details')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(onPressed: controller.createEnquiry, child: const Text('Save Enquiry')),
        ],
      ),
    );
  }
}
