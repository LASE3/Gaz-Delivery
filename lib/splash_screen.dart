// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'app_language.dart';
import 'package:google_fonts/google_fonts.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool autoNavigate;
  final Widget? destinationScreen;

  const SplashScreen({
    super.key,
    this.autoNavigate = true,
    this.destinationScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Theme Color Palette
  static const Color colorBackground = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceContainer = Color(0xFFE5EEFF);
  static const Color colorSurfaceHigh = Color(0xFFDCE9FF);
  static const Color colorSurfaceHighest = Color(0xFFD3E4FE);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);

  // Loading Step Simulation
  List<Map<String, dynamic>> get _steps => [
    {'progress': 0.35, 'text': AppLanguage.tr(ar: 'جاري فحص أقرب شاحنات التوزيع...', en: 'Locating nearest distribution trucks...')},
    {'progress': 0.68, 'text': AppLanguage.tr(ar: 'التحقق من مخزون أسطوانات الغاز المتوفر...', en: 'Verifying cylinder stock availability...')},
    {'progress': 0.92, 'text': AppLanguage.tr(ar: 'تحديد نقطة التوصيل وتأكيد المسار...', en: 'Setting delivery point & route...')},
    {'progress': 1.00, 'text': AppLanguage.tr(ar: 'جاهز لطلب أسطوانتك!', en: 'Ready to order your cylinder!')},
  ];

  int _currentStepIndex = 0;
  Timer? _stepTimer;
  Timer? _navigationTimer;

  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startLoadingSimulation();
  }

  void _startLoadingSimulation() {
    _stepTimer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
      if (_currentStepIndex < _steps.length - 1) {
        setState(() {
          _currentStepIndex++;
        });
      } else {
        timer.cancel();
        if (widget.autoNavigate) {
          _navigationTimer = Timer(const Duration(milliseconds: 700), () {
            if (mounted) {
              _navigateToNextScreen();
            }
          });
        }
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            widget.destinationScreen ?? const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _navigationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProgress =
        _steps[_currentStepIndex]['progress'] as double;
    final currentText = _steps[_currentStepIndex]['text'] as String;

    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, langCode, child) {
        return Directionality(
          textDirection: AppLanguage.direction,
          child: Scaffold(
        backgroundColor: colorBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 1. Top Area: Network Connection & Live Region Badge
                        _buildTopArea(),

                        // 2. Center Stage: Logo, Gas Cylinder Tactile Card & Identity
                        _buildCenterStage(),

                        // 3. Interactive Loading Stage & Truck Radar Status
                        _buildLoadingSection(currentProgress, currentText),

                        // 4. Official Jordan Regulatory & Safety Endorsement Card
                        _buildSafetyRegulatoryCard(),

                        // 5. Footer Meta: App Version & Kingdom Signature
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
      },
    );
  }

  // 1. TOP AREA
  Widget _buildTopArea() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Amman & Zarqa Active Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorSurfaceContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: colorSecondaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  AppLanguage.tr(ar: 'عمّان • الزرقاء', en: 'Amman • Zarqa'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Direct Distribution Network
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_shipping_rounded,
                  size: 16,
                  color: colorSecondaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLanguage.tr(ar: 'شبكة التوزيع المباشر', en: 'Direct Distribution Network'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. CENTER STAGE: LOGO & IDENTITY
  Widget _buildCenterStage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        // Animated Cylinder Monogram Card with Glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Radial Glow
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSecondaryContainer.withValues(alpha: 0.15),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSurfaceHighest.withValues(alpha: 0.4),
              ),
            ),

            // Tactile Logo Card
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: colorSurfaceLowest,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: colorSecondaryContainer.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomPaint(
                    size: const Size(64, 64),
                    painter: _GasCylinderPainter(),
                  ),
                ),
              ),
            ),

            // Quick Ignition Pill Badge
            Positioned(
              bottom: 4,
              left: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorSecondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorSecondaryContainer.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, size: 12, color: Colors.white),
                    const SizedBox(width: 2),
                    Text(
                      AppLanguage.tr(ar: 'سريع وآمن', en: 'Fast & Safe'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Brand Name "غاز GAS"
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              AppLanguage.tr(ar: 'غاز', en: 'GAS'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: colorOnSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'GAS',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: colorSecondaryContainer,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Official Subtitle Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: colorSurfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            AppLanguage.tr(ar: 'المنصة الوطنية المعتمدة لتوزيع الغاز المنزلي', en: 'National Household Gas Distribution Platform'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorOnSurface,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Slogans
        Text(
          AppLanguage.tr(ar: 'دِفء بيتك، بضغطة زر', en: 'Warmth for your home, at a tap'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorOnSurface,
          ),
        ),
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            AppLanguage.tr(ar: 'توصيل أسطوانات الغاز ومستلزماتها بأعلى درجات الأمان في عمّان والزرقاء', en: 'Safe delivery of gas cylinders & accessories across Amman & Zarqa'),
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // 3. LOADING SECTION
  Widget _buildLoadingSection(double progress, String statusText) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Smooth Animated Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 7,
              color: colorSurfaceContainer,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorSecondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Real-time Action Caption
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: colorSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    statusText,
                    key: ValueKey<String>(statusText),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Live Metric Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorSurfaceLowest,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: colorSecondaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  AppLanguage.tr(ar: 'متوسط وقت الوصول الفعلي: ', en: 'Average arrival time: '),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    color: colorOnSurfaceVariant,
                  ),
                ),
                Text(
                  AppLanguage.tr(ar: '١٤ دقيقة', en: '14 minutes'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. REGULATORY & SAFETY ENDORSEMENT CARD
  Widget _buildSafetyRegulatoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: colorSecondaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLanguage.tr(ar: 'هيئة تنظيم قطاع الطاقة والمعادن', en: 'Energy & Minerals Regulatory Commission'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: colorSurfaceHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'EMRC',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: colorOnSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLanguage.tr(
                        ar: 'معتمد رسمياً وفق معايير السلامة العامة ومواصفات مصفاة البترول الأردنية',
                        en: 'Officially certified per public safety standards & Jordan Petroleum Refinery specs',
                      ),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Trust Metrics Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lock_clock_outlined,
                      size: 15,
                      color: colorSecondaryContainer,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      AppLanguage.tr(
                        ar: 'صمامات محكمة الإغلاق',
                        en: 'Hermetically Sealed Valves',
                      ),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 14,
                  color: colorSurfaceHigh,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.scale_rounded,
                      size: 15,
                      color: colorSecondaryContainer,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      AppLanguage.tr(
                        ar: 'وزن مدقق (١٢.٥ كغ)',
                        en: 'Certified Weight (12.5 kg)',
                      ),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. FOOTER
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLanguage.tr(
              ar: 'المملكة الأردنية الهاشمية 🇯🇴',
              en: 'Hashemite Kingdom of Jordan 🇯🇴',
            ),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorOnSurfaceVariant,
            ),
          ),
          Text(
            'v2.4.0 (Jordan Edition)',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Tactile Gas Cylinder SVG with Flame Core
class _GasCylinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 72.0;

    // Cylinder Collar Handle
    final collarPaint = Paint()..color = const Color(0xFF0B1C30);
    final collarRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(22 * scale, 10 * scale, 28 * scale, 8 * scale),
      Radius.circular(4 * scale),
    );
    canvas.drawRRect(collarRRect, collarPaint);

    final innerHandlePaint = Paint()..color = Colors.white;
    final innerHandleRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(28 * scale, 12 * scale, 16 * scale, 4 * scale),
      Radius.circular(2 * scale),
    );
    canvas.drawRRect(innerHandleRRect, innerHandlePaint);

    // Valve Neck
    final valvePaint = Paint()..color = const Color(0xFFFD651E);
    canvas.drawRect(
      Rect.fromLTWH(32 * scale, 17 * scale, 8 * scale, 5 * scale),
      valvePaint,
    );

    // Main Cylinder Body
    final bodyPaint = Paint()..color = const Color(0xFF0B1C30);
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(15 * scale, 21 * scale, 42 * scale, 42 * scale),
      Radius.circular(14 * scale),
    );
    canvas.drawRRect(bodyRRect, bodyPaint);

    // Inner Chamber Visual Depth
    final innerBodyPaint = Paint()..color = const Color(0xFF131B2E);
    final innerBodyRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(18 * scale, 24 * scale, 36 * scale, 36 * scale),
      Radius.circular(11 * scale),
    );
    canvas.drawRRect(innerBodyRRect, innerBodyPaint);

    // Fiery Core Flame Vector
    final outerFlamePaint = Paint()
      ..color = const Color(0xFFFD651E)
      ..style = PaintingStyle.fill;
    final outerFlamePath = Path()
      ..moveTo(36 * scale, 29 * scale)
      ..cubicTo(36 * scale, 29 * scale, 44 * scale, 38.5 * scale, 44 * scale, 44.2 * scale)
      ..cubicTo(44 * scale, 48.5 * scale, 40.4 * scale, 52 * scale, 36 * scale, 52 * scale)
      ..cubicTo(31.6 * scale, 52 * scale, 28 * scale, 48.5 * scale, 28 * scale, 44.2 * scale)
      ..cubicTo(28 * scale, 38.5 * scale, 36 * scale, 29 * scale, 36 * scale, 29 * scale)
      ..close();
    canvas.drawPath(outerFlamePath, outerFlamePaint);

    // Inner Lighter Flame Core
    final innerFlamePaint = Paint()
      ..color = const Color(0xFFFFB599)
      ..style = PaintingStyle.fill;
    final innerFlamePath = Path()
      ..moveTo(36 * scale, 38 * scale)
      ..cubicTo(36 * scale, 38 * scale, 40 * scale, 42.6 * scale, 40 * scale, 45.4 * scale)
      ..cubicTo(40 * scale, 47.5 * scale, 38.2 * scale, 49.2 * scale, 36 * scale, 49.2 * scale)
      ..cubicTo(33.8 * scale, 49.2 * scale, 32 * scale, 47.5 * scale, 32 * scale, 45.4 * scale)
      ..cubicTo(32 * scale, 42.6 * scale, 36 * scale, 38 * scale, 36 * scale, 38 * scale)
      ..close();
    canvas.drawPath(innerFlamePath, innerFlamePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
