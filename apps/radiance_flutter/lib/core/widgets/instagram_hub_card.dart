import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class InstagramHubCard extends StatelessWidget {
  const InstagramHubCard({super.key});

  void _showInstagramDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pink, Colors.amber],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          AppStrings.instagramHandle,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepNavy,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: AppColors.primaryRoyalBlue, size: 16),
                    ],
                  ),
                  Text(
                    'Radiance Institute • Amritsar',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Follow @radiance_institute on Instagram for:',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 8),
            _buildBenefitItem(Icons.movie_filter_outlined, 'Physics derivation reels & shortcuts by Er. Bedi Sir'),
            _buildBenefitItem(Icons.emoji_events_outlined, 'JEE & NEET City Topper felicitation posts'),
            _buildBenefitItem(Icons.quiz_outlined, 'Sunday Grand Test answer keys & solution breakdowns'),
            _buildBenefitItem(Icons.school_outlined, 'Junior Foundation Academy Olympiad math tips'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBlueBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📍 85-A, Rani Ka Bagh, Amritsar',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepNavy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📞 Admissions: ${AppStrings.helpline} / ${AppStrings.phone}',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRoyalBlue,
              foregroundColor: AppColors.pureWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening @radiance_institute channel...'),
                  backgroundColor: AppColors.primaryRoyalBlue,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Visit Instagram'),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryRoyalBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF833AB4), // Purple
            Color(0xFFFD1D1D), // Pink/Red
            Color(0xFFFCB045), // Amber
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFD1D1D).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.pink, Colors.amber],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              AppStrings.instagramHandle,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.deepNavy,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: AppColors.primaryRoyalBlue, size: 16),
                        ],
                      ),
                      Text(
                        'Radiance Institute • Bedi College of Physics',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _showInstagramDialog(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FOLLOW',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryRoyalBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.softBlueSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.accentGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '"Moment of inertia shortcuts by Er. Bedi Sir are now live on Instagram!"',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '207+ Posts • 1,250+ Scholars • Rani Ka Bagh',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                InkWell(
                  onTap: () => _showInstagramDialog(context),
                  child: Row(
                    children: [
                      Text(
                        'View Reels',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryRoyalBlue,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primaryRoyalBlue),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
