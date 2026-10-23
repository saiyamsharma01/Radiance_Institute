import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final SplashController controller;

  // Animation controllers for rich micro-interactions
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  late final AnimationController _entranceController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SplashController>();

    // Continuous smooth rotation for the radiant golden ring
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Subtle gentle breathing pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Initial entrance animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF070F20),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Ambient Dynamic Background Gradients & Glow Orbs
          _buildAmbientBackground(size),

          // 2. Custom Painter for subtle celestial particles/nodes
          CustomPaint(
            size: size,
            painter: _CosmicNodePainter(pulse: _pulseController),
          ),

          // 3. Top Skip Button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: TextButton.icon(
                  onPressed: controller.skip,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                    ),
                  ),
                  icon: const Icon(Icons.fast_forward_rounded, size: 16, color: Color(0xFFFBBF24)),
                  label: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. Main Dynamic Foreground Elements
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dynamic Glowing Crest / Emblem
                        _buildHeroLogo(),
                        const SizedBox(height: 24),

                        // Official Brand Identity
                        _buildBrandIdentity(),
                        const SizedBox(height: 18),

                        // Dynamic Highlights Rotating Card
                        _buildDynamicHighlights(),
                        const SizedBox(height: 36),

                        // Dynamic Progress Bar & Live Status
                        _buildProgressSection(),
                        const SizedBox(height: 24),

                        // Security & Location Credentials
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Ambient decorative layered glow
  Widget _buildAmbientBackground(Size size) {
    return Stack(
      children: [
        // Main Deep Royal Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF060B18), // Midnight Navy
                Color(0xFF0F1E3D), // Deep Radiance Navy
                Color(0xFF132B60), // Regal Royal Blue
                Color(0xFF081226), // Outer Navy
              ],
              stops: [0.0, 0.35, 0.75, 1.0],
            ),
          ),
        ),

        // Glowing Top Orb
        Positioned(
          top: -size.height * 0.12,
          right: -size.width * 0.15,
          child: Container(
            width: size.width * 0.85,
            height: size.width * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryRoyalBlue.withValues(alpha: 0.35),
                  AppColors.primaryRoyalBlue.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),

        // Glowing Bottom Gold Aura
        Positioned(
          bottom: -size.height * 0.15,
          left: -size.width * 0.2,
          child: Container(
            width: size.width * 0.9,
            height: size.width * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentGold.withValues(alpha: 0.20),
                  AppColors.accentGold.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Dynamic Emblem with rotating solar ring and subtle pulse
  Widget _buildHeroLogo() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseScale = 1.0 + (_pulseController.value * 0.04);
        return Transform.scale(
          scale: pulseScale,
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Radiant Shimmer Glow Ring
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const SweepGradient(
                      colors: [
                        Color(0xFFF59E0B), // Warm Gold
                        Color(0xFF3B82F6), // Royal Blue
                        Color(0xFF93C5FD), // Soft Blue
                        Color(0xFFF59E0B), // Warm Gold
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.45),
                        blurRadius: 36,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Outer Mask Rim
          Container(
            width: 132,
            height: 132,
            decoration: const BoxDecoration(
              color: Color(0xFF0B1428),
              shape: BoxShape.circle,
            ),
          ),

          // Inner Premium Circular Emblem
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E3A8A),
                  Color(0xFF0F1E3D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: const Color(0xFFFBBF24).withValues(alpha: 0.65),
                width: 2.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/radiance_logo.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF1E3A8A),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.school_rounded,
                    size: 56,
                    color: Color(0xFFFBBF24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Official typography and heritage tags
  Widget _buildBrandIdentity() {
    return Column(
      children: [
        // RADIANCE Main Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'RADIANCE',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: AppColors.primaryRoyalBlue.withValues(alpha: 0.8),
                    blurRadius: 18,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'PLUS',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF172B4D),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),

        // INSTITUTE subtitle
        Text(
          'INSTITUTE',
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 8.0,
            color: const Color(0xFF93C5FD),
          ),
        ),
        const SizedBox(height: 12),

        // Tagline Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.4),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
              const SizedBox(width: 6),
              Text(
                AppStrings.tagline,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFBBF24),
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Affiliation
        Text(
          AppStrings.affiliation,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.70),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Dynamic cycling highlight banner
  Widget _buildDynamicHighlights() {
    return Obx(() {
      final index = controller.activeHighlightIndex.value;
      final highlight = controller.highlights[index];

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.25),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<int>(index),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF132347).withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  highlight.icon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      highlight.title,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      highlight.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Dynamic Progress Bar and Real-time Stage Status
  Widget _buildProgressSection() {
    return Column(
      children: [
        // Live Progress Stage Text & Percentage
        Obx(() {
          final pct = (controller.progress.value * 100).toInt();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFFBBF24).withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.statusMessage.value,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFE2E8F0),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Text(
                  '$pct%',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFBBF24),
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 10),

        // Sleek Capsule Progress Bar
        Obx(() {
          final progressVal = controller.progress.value;
          return Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 60),
                      width: constraints.maxWidth * progressVal,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3B82F6), // Blue
                            Color(0xFF60A5FA), // Light Blue
                            Color(0xFFFBBF24), // Gold highlight
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFBBF24).withValues(alpha: 0.6),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                          ),
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
    );
  }

  /// Campus & SSL Security Footer
  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFF93C5FD)),
            const SizedBox(width: 4),
            Text(
              'Rani Ka Bagh, Amritsar',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF93C5FD),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '•',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              ),
            ),
            const Icon(Icons.lock_rounded, size: 11, color: Color(0xFF10B981)),
            const SizedBox(width: 4),
            Text(
              '256-Bit SSL Secure',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6EE7B7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'v1.0.0 (Production Release) • Helpline: ${AppStrings.helpline}',
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.45),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Dynamic cosmic particles painter for subtle ambient liveliness
class _CosmicNodePainter extends CustomPainter {
  final Animation<double> pulse;

  _CosmicNodePainter({required this.pulse}) : super(repaint: pulse);

  static final List<math.Point<double>> _points = [
    const math.Point(0.12, 0.18),
    const math.Point(0.85, 0.15),
    const math.Point(0.25, 0.38),
    const math.Point(0.88, 0.42),
    const math.Point(0.15, 0.72),
    const math.Point(0.80, 0.78),
    const math.Point(0.48, 0.88),
    const math.Point(0.72, 0.28),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < _points.length; i++) {
      final p = _points[i];
      final offset = Offset(p.x * size.width, p.y * size.height);
      final double flicker = math.sin((pulse.value * math.pi * 2) + i) * 0.5 + 0.5;

      paint.color = (i % 2 == 0 ? const Color(0xFFFBBF24) : const Color(0xFF60A5FA))
          .withValues(alpha: 0.12 + (flicker * 0.18));

      final radius = (1.5 + (i % 3)) * (0.8 + (flicker * 0.4));
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CosmicNodePainter oldDelegate) => true;
}
