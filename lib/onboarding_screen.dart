// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'app_language.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Theme Color Palette
  static const Color colorBackground = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceContainer = Color(0xFFE5EEFF);
  static const Color colorSurfaceHighest = Color(0xFFD3E4FE);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);
  static const Color colorPrimaryContainer = Color(0xFF131B2E);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorOutlineVariant = Color(0xFFC6C6CD);
  static const Color colorOnTertiaryFixed = Color(0xFF001D31);

  final PageController _pageController = PageController();
  int _currentPage = 0;
  

  List<Map<String, dynamic>> get _slides => [
    {
      'step': AppLanguage.tr(ar: 'الخطوة الأولى', en: 'Step 1'),
      'title': AppLanguage.tr(ar: 'اطلب أسطوانتك بسهولة', en: 'Order Your Cylinder Easily'),
      'description': AppLanguage.tr(
        ar: 'كبستين على التطبيق وبدون مكالمات هاتفية أو انتظار في البرد. الأسطوانة تصل لباب بيتك بسعرها الرسمي.',
        en: 'Two taps on the app without calls or waiting in the cold. Delivered to your doorstep at official tariff.',
      ),
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBSp7eMdxo_sNUXnJ4lKghsMx4e_Ye7LB0__jg_2Ob-Aiej_Xy1m9sCcWhudZNlSPi-2T-8L18rsQl4gd0vXP6DMSV0dtc-w290DI8wf5OXmxH6XeKLECBXx1QPXiV6UDON6Z7hMObjkP7sq3gI8umOE9KSak1Ry2Q37a4pcT-6dhXq0-sO-SJYPcZu9jaAEIEYWP7Bx4ltceoqCIGKYP8oNBZVEnUVCJYvmr3fZUOQMCj0dYNPII8B6g',
      'badgeIcon': Icons.local_fire_department_rounded,
      'badgeText': AppLanguage.tr(ar: 'أسطوانات معتمدة ومفحوصة', en: 'Certified & Inspected Cylinders'),
      'isMap': false,
    },
    {
      'step': AppLanguage.tr(ar: 'الخطوة الثانية', en: 'Step 2'),
      'title': AppLanguage.tr(ar: 'تتبع الكابتن مباشرة', en: 'Live Driver Tracking'),
      'description': AppLanguage.tr(
        ar: 'راقب مسار سيارة الغاز خطوة بخطوة على الخريطة الحية مع تقدير فوري ودقيق لوقت وصول الشحنة.',
        en: 'Follow the gas truck path turn-by-turn on live map with accurate real-time arrival estimation.',
      ),
      'image':
          'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=700&auto=format&fit=crop&q=80',
      'badgeIcon': Icons.navigation_rounded,
      'badgeText': AppLanguage.tr(ar: 'الكابتن في الطريق إليك', en: 'Driver is on the way'),
      'isMap': true,
      'etaText': AppLanguage.tr(ar: '8 دقائق', en: '8 mins'),
    },
    {
      'step': AppLanguage.tr(ar: 'الخطوة الثالثة', en: 'Step 3'),
      'title': AppLanguage.tr(ar: 'استلم وافحص بأمان', en: 'Safe Delivery & Inspection'),
      'description': AppLanguage.tr(
        ar: 'يقوم الموزع بتركيب الأسطوانة وفحص الصمام مجاناً لسلامة عائلتك، وادفع نقداً عند باب البيت بكل أمان.',
        en: 'Driver installs cylinder and inspects valve free for family safety. Pay cash safely at door.',
      ),
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDPseZcHeurRZTom2uZ9GExGAJsyNsMR-HRoeMcicbcxdOxJyNpzu-Sqk8Mg-tJKe0n9mu8m3f3XDLOFWhXdN-LS4i0lUfHK91wBUw6SzYKl403NYa42u-tIGf1Ydqd7454RLjok3WiwE3IBx9LpyZ4SVE2pMHzs82TCKEXkRx6BvYz4ZdxX_-m3nQk5G7oh1MFH4ZTtWxPgNVF_t6HeHSzVK3JJ4mc4TUYjLXfXoRf9VR3PQNYH7PmBw',
      'badgeIcon': Icons.verified_user_rounded,
      'badgeText': AppLanguage.tr(ar: 'فحص التسريب مجاني 100%', en: '100% Free Leak Inspection'),
      'isMap': false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextSlide() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _toggleLanguage() {
    AppLanguage.toggleLanguage();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLanguage.isArabic
              ? 'تم تغيير اللغة إلى العربية'
              : 'Language changed to English',
          style: GoogleFonts.ibmPlexSansArabic(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        backgroundColor: colorPrimaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastSlide = _currentPage == _slides.length - 1;

    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, langCode, child) {
        return Directionality(
          textDirection: AppLanguage.direction,
          child: Scaffold(
        backgroundColor: colorBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // 1. Top Bar Controls
                _buildTopBar(),
                const SizedBox(height: 8),

                // 2. Main Carousel Card
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorSurfaceLowest,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Column(
                        children: [
                          // Sliding Pages
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemCount: _slides.length,
                              itemBuilder: (context, index) {
                                return _buildSlideItem(_slides[index]);
                              },
                            ),
                          ),

                          // Step Dots Indicator
                          _buildStepDots(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Trust Badge
                _buildTrustBadge(),
                const SizedBox(height: 14),

                // 4. Bottom Action CTA Section
                _buildBottomCTA(isLastSlide),
              ],
            ),
          ),
        ),
      ),
    );
      },
    );
  }

  // 1. TOP BAR CONTROLS
  Widget _buildTopBar() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Language Switcher Toggle
          InkWell(
            onTap: _toggleLanguage,
            borderRadius: BorderRadius.circular(20),
            child: Container(
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
                children: [
                  const Icon(
                    Icons.language_rounded,
                    size: 18,
                    color: colorSecondaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLanguage.isArabic ? 'English' : 'عربي',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Coverage Pill & Skip Button
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: colorSecondaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLanguage.tr(ar: 'عَمّان • الزرقاء', en: 'Amman • Zarqa'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _navigateToHome,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    AppLanguage.tr(ar: 'تخطي', en: 'Skip'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. SLIDE ITEM BUILDER
  Widget _buildSlideItem(Map<String, dynamic> slide) {
    final bool isMap = slide['isMap'] == true;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          // Visual Hero Image / Map Container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorSurfaceLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isMap) ...[
                      // Simulated Tactical Map Texture with route
                      Container(
                        color: const Color(0xFFD6E4FF),
                        child: CustomPaint(
                          painter: _OnboardingMapPainter(),
                        ),
                      ),
                    ] else ...[
                      Image.network(
                        slide['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: colorSurfaceContainer,
                          child: const Center(
                            child: Icon(
                              Icons.local_fire_department,
                              size: 64,
                              color: colorSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Bottom Gradient with Badge Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorPrimaryContainer.withValues(alpha: 0.85),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: colorSurfaceLowest.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    slide['badgeIcon'] as IconData,
                                    size: 16,
                                    color: colorSecondaryContainer,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    slide['badgeText'] as String,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: colorOnSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isMap && slide['etaText'] != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorSurfaceHighest,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  slide['etaText'] as String,
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colorOnTertiaryFixed,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Text Content Section
          Column(
            children: [
              Text(
                slide['step'] as String,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                slide['title'] as String,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  slide['description'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    color: colorOnSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Stepper Indicator Dots
  Widget _buildStepDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_slides.length, (index) {
          final isSelected = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isSelected ? 28 : 8,
            height: 7,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorSecondaryContainer
                  : colorOutlineVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
          );
        }),
      ),
    );
  }

  // 3. TRUST BADGE
  Widget _buildTrustBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorSurfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            size: 16,
            color: colorSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            AppLanguage.tr(ar: 'خدمة معتمدة تغطي كافة مناطق عمّان والزرقاء', en: 'Certified service covering all Amman & Zarqa regions'),
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

  // 4. BOTTOM ACTION CTA
  Widget _buildBottomCTA(bool isLastSlide) {
    return Column(
      children: [
        // Primary Next / Get Started Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _goToNextSlide,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSecondaryContainer,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: colorSecondaryContainer.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastSlide ? AppLanguage.tr(ar: 'ابدأ الآن', en: 'Get Started') : AppLanguage.tr(ar: 'التالي', en: 'Next'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isLastSlide
                      ? Icons.rocket_launch_rounded
                      : AppLanguage.forwardIcon,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Already have an account? Login Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLanguage.tr(ar: 'لديك حساب بالفعل؟', en: 'Already have an account?'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                color: colorOnSurfaceVariant,
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: _navigateToLogin,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  AppLanguage.tr(ar: 'تسجيل الدخول', en: 'Log In'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorSecondary,
                    decoration: TextDecoration.underline,
                    decorationColor: colorSecondaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Custom Painter for Map texture simulation in slide 2
class _OnboardingMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE5EEFF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final roadPath = Path()
      ..moveTo(0, size.height * 0.7)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.6,
        size.width * 0.7,
        size.height * 0.8,
        size.width,
        size.height * 0.4,
      );
    canvas.drawPath(roadPath, roadPaint);

    // Route Orange Dash
    final routePaint = Paint()
      ..color = const Color(0xFFFD651E)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.65)
      ..cubicTo(
        size.width * 0.45,
        size.height * 0.62,
        size.width * 0.65,
        size.height * 0.75,
        size.width * 0.8,
        size.height * 0.5,
      );
    canvas.drawPath(routePath, routePaint);

    // Truck location pin dot
    final truckDotBg = Paint()..color = const Color(0xFF131B2E);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.5),
      9.0,
      truckDotBg,
    );

    final truckDot = Paint()..color = const Color(0xFFFD651E);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.5),
      5.0,
      truckDot,
    );

    // Destination Pin
    final destBg = Paint()..color = const Color(0xFF007A3D);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.65),
      7.0,
      destBg,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
