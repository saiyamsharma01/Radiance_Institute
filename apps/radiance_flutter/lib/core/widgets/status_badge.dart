import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toUpperCase()) {
      case 'PAID':
      case 'PRESENT':
      case 'GRADED':
      case 'PUBLISHED':
      case 'APPROVED':
      case 'ADMITTED':
      case 'SUCCESS':
      case 'ACTIVE':
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;

      case 'PARTIALLY_PAID':
      case 'LATE':
      case 'PENDING':
      case 'PENDING_ADMIN_REVIEW':
      case 'PENDING_REVIEW':
      case 'CONTACTED':
      case 'VISIT_SCHEDULED':
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;

      case 'OVERDUE':
      case 'ABSENT':
      case 'FAILED':
      case 'REJECTED':
      case 'SUSPENDED':
      case 'CANCELLED':
        bg = AppColors.errorLight;
        fg = AppColors.error;
        break;

      case 'NEW':
      case 'ISSUED':
      case 'SUBMITTED':
      case 'SCHEDULED':
      case 'MARKS_ENTERED':
      default:
        bg = AppColors.infoLight;
        fg = AppColors.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
