import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Standardized official Radiance Institute logo emblem badge.
/// Features the signature golden-royal radiant gradient border,
/// subtle ambient glow, and anti-aliased circular clip.
class RadianceLogoBadge extends StatelessWidget {
  final double size;
  final bool showGlow;
  final double borderWidth;
  final EdgeInsetsGeometry? margin;

  const RadianceLogoBadge({
    super.key,
    this.size = 40.0,
    this.showGlow = true,
    this.borderWidth = 2.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFBBF24), // Vibrant Amber Gold
            Color(0xFFF59E0B), // Warm Gold
            Color(0xFF3B82F6), // Royal Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                  blurRadius: size * 0.22,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: AppColors.primaryRoyalBlue.withValues(alpha: 0.25),
                  blurRadius: size * 0.18,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3C4C89),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.45),
            width: 0.8,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/radiance_logo.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.school_rounded,
              color: const Color(0xFFFBBF24),
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
