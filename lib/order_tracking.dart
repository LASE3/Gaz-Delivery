// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_language.dart';
import 'page_transitions.dart';
import 'permission_helper.dart';
import 'driver_profile_screen.dart';
import 'driver_chat_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final bool initialIsCompleted;

  const OrderTrackingScreen({
    super.key,
    this.initialIsCompleted = false,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  // Theme Color Palette
  static const Color colorBackground = Color(0xFFF8F9FF);
  static const Color colorSurface = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceContainer = Color(0xFFE5EEFF);
  static const Color colorSurfaceHigh = Color(0xFFDCE9FF);
  static const Color colorSurfaceHighest = Color(0xFFD3E4FE);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);
  static const Color colorPrimaryContainer = Color(0xFF131B2E);
  static const Color colorOnPrimary = Color(0xFFFFFFFF);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorSecondaryFixed = Color(0xFFFFDBCE);
  static const Color colorError = Color(0xFFBA1A1A);
  static const Color colorErrorContainer = Color(0xFFFFDAD6);
  static const Color colorOnErrorContainer = Color(0xFF93000A);

  // Screen State: Live Tracking vs Completed Delivery & Rating
  late bool _isOrderDelivered;

  // Rating State (for completion view)
  int _selectedRatingStars = 5;
  final Set<int> _selectedFeedbackTags = {0, 1, 2};
  final TextEditingController _ratingNotesController = TextEditingController();
  bool _isRatingSubmitting = false;
  bool _isRatingSubmitted = false;

  // Compass rotation angle (for live map)
  double _compassRotation = 0.0;

  // Selected Quick Messages Set (for live tracking)
  final Set<int> _selectedQuickMessages = {};

  // Navigation index
  int _selectedNavIndex = 1; // "طلباتي" by default

  // Animation controller for map route pulse
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _isOrderDelivered = widget.initialIsCompleted;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ratingNotesController.dispose();
    super.dispose();
  }

  void _showChatSheet() {
    context.pushPage(const DriverChatScreen());
  }

  void _showSupportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: AppLanguage.direction,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: colorSecondaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: colorSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLanguage.tr(ar: 'مركز الدعم الفني المباشر', en: 'Live Support Center'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        Text(
                          AppLanguage.tr(
                            ar: 'فريق غاز الأردن في خدمتك على مدار الساعة',
                            en: 'Jordan Gas team is at your service 24/7',
                          ),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.phone),
                  label: Text(
                    AppLanguage.tr(
                      ar: 'اتصال بخدمة العملاء (06-5000000)',
                      en: 'Call Customer Support (06-5000000)',
                    ),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRatingSubmission() {
    setState(() {
      _isRatingSubmitting = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isRatingSubmitting = false;
          _isRatingSubmitted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.task_alt, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppLanguage.tr(
                    ar: 'شكراً لك! تم استلام تقييمك بنجاح',
                    en: 'Thank you! Your rating has been submitted',
                  ),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            backgroundColor: colorPrimaryContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, langCode, child) {
        return Directionality(
          textDirection: AppLanguage.direction,
          child: Scaffold(
            backgroundColor: colorBackground,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _isOrderDelivered
                          ? _buildCompletedOrderView()
                          : _buildLiveTrackingView(),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _isOrderDelivered ? _buildBottomNavigation() : null,
          ),
        );
      },
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorSurface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!_isOrderDelivered)
                IconButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    AppLanguage.backIcon,
                    color: colorOnSurface,
                    size: 24,
                  ),
                  tooltip: AppLanguage.tr(ar: 'رجوع', en: 'Back'),
                )
              else
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isOrderDelivered = false; // Toggle back to live track view
                    });
                  },
                  icon: const Icon(
                    Icons.replay_rounded,
                    color: colorSecondary,
                    size: 22,
                  ),
                  tooltip: AppLanguage.tr(ar: 'معاينة البث المباشر للتتبع', en: 'Preview Live Tracking'),
                ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFD651E), Color(0xFFA73A00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isOrderDelivered ? AppLanguage.tr(ar: 'غاز | GAS', en: 'Jordan Gas') : AppLanguage.tr(ar: 'تتبع التوصيل المباشر', en: 'Live Delivery Tracking'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                  if (_isOrderDelivered)
                    Text(
                      'Home',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        color: colorOnSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _showSupportDialog,
                icon: const Icon(
                  Icons.support_agent_rounded,
                  color: colorOnSurfaceVariant,
                  size: 24,
                ),
                tooltip: AppLanguage.tr(ar: 'الدعم الفني', en: 'Support'),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorSurfaceHigh, width: 1.5),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDcymBkUqtK2r72uSV8iVOPBkWf8cUREOvoOxt_quBLnhUZ-3rFNL-r7pO5GWHorxYxoLeezNJKNtNYZdJJXk0w4pCJMrF9fQhKvmu4sP4JykZujpk20e6BzqcRgX2n2mzbCvXtzzrRoFjoHl1hbE_WMzbHqoe1v_oduSg_oS-NuEHFQULOTkJwUgYNYj_VmBqwLW7C70wda6t4MaiTyl-C-RQUk4TSnWiG-cX7ck2o1tazfOC6b4RuTQ',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      color: colorOnSurfaceVariant,
                      size: 18,
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

  // ==========================================
  // VIEW 1: LIVE ACTIVE DELIVERY TRACKING
  // ==========================================
  Widget _buildLiveTrackingView() {
    return SingleChildScrollView(
      key: const ValueKey('live_tracking_view'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Map Canvas Hero
          _buildMapTrackingCanvas(),
          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Quick transition simulator button
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorSurfaceLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorSecondaryFixed),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flash_on, color: colorSecondary, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            AppLanguage.tr(ar: 'محاكاة استلام الطلب بنجاح:', en: 'Simulate successful delivery:'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colorOnSurface,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isOrderDelivered = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorSecondaryContainer,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppLanguage.tr(ar: 'تم الاستلام الآن', en: 'Received Now'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Order Lifecycle Stepper
                _buildOrderLifecycleStepper(),
                const SizedBox(height: 14),

                // 3. Driver Card
                _buildDriverCard(),
                const SizedBox(height: 14),

                // 4. Safety Verification Alert Box
                _buildSafetyAlertBox(),
                const SizedBox(height: 14),

                // 5. Order Drawer Detail Breakdown
                _buildOrderDetailsCard(),
                const SizedBox(height: 16),

                // 6. Help Support Desk Button
                _buildSupportButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. MAP TRACKING CANVAS HERO
  Widget _buildMapTrackingCanvas() {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        children: [
          // Base Map Background Image
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCM8TNi8d8qK8CkCYGdH56pEa495tmxrxtu-xj72WgSwN1DEop6_GG_71KPuuqty7vy6-nL0BXQK9r0YD6sewFSvTl3H7zjDfOZkf9DYUEozOf_FVgSSDbrtiTTiO_LBYiO0lx9mo63kLKkapmiHx7FFcyKwIe4ve3q0y7BB7P_VeVovMb_6pv_AaHvpTGVXUra88PHRl2zswrQSD9utKD7BNXuuUlvmm9tA-BhV3KaJ2-37k5p03qb2A',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                color: colorSurfaceHigh,
                child: const Center(
                  child: Icon(Icons.map_rounded, size: 64, color: colorSurfaceHighest),
                ),
              ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorPrimaryContainer.withValues(alpha: 0.7),
                    Colors.transparent,
                    colorPrimaryContainer.withValues(alpha: 0.25),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          // Custom Animated Route Painter
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _MapRoutePainter(
                    pulseScale: _pulseAnimation.value,
                    primaryColor: colorSecondaryContainer,
                    darkColor: colorPrimaryContainer,
                  ),
                );
              },
            ),
          ),

          // Top Floating Speed / GPS Breadcrumbs
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorSurfaceLowest.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
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
                        AppLanguage.tr(ar: 'بث مباشر لنظام التتبع (GPS)', en: 'Live GPS Tracking Feed'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorSurfaceLowest.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        color: colorSecondary,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLanguage.tr(ar: 'شارع المدينة المنورة', en: 'Madina Munawwara St'),
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
          ),

          // Floating Dynamic Arrival ETA Banner
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorSurfaceLowest.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorSecondaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.timer_rounded,
                      color: colorSecondaryContainer,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLanguage.tr(ar: '6 دقائق', en: '6 mins'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: colorOnSurface,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorSecondaryContainer.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                AppLanguage.tr(ar: 'وصول سريع', en: 'Fast Arrival'),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: colorSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          AppLanguage.tr(ar: 'المسافة المتبقية: 1.2 كم • خلدا / تلاع العلي', en: 'Distance left: 1.2 km • Khalda / Tlaa Al-Ali'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await PermissionHelper.requestPermission(
                        context,
                        type: AppPermissionType.location,
                      );
                      setState(() {
                        _compassRotation += 3.14159;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AnimatedRotation(
                        turns: _compassRotation / (2 * 3.14159),
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.explore_outlined,
                          color: colorOnSurface,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. ORDER LIFECYCLE STEPPER
  Widget _buildOrderLifecycleStepper() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLanguage.tr(ar: 'حالة وصول الغاز', en: 'Gas Delivery Status'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              Text(
                AppLanguage.tr(ar: 'طلب رقم #84935', en: 'Order #84935'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 14,
                left: 24,
                right: 24,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorSurfaceContainer,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerRight,
                    widthFactor: 0.68,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorSecondaryContainer,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepItem(
                    icon: Icons.check,
                    label: AppLanguage.tr(ar: 'استلام الطلب', en: 'Order Received'),
                    isCompleted: true,
                    isActive: false,
                  ),
                  _buildStepItem(
                    icon: Icons.check,
                    label: AppLanguage.tr(ar: 'تأكيد المستودع', en: 'Depot Confirmed'),
                    isCompleted: true,
                    isActive: false,
                  ),
                  _buildStepItem(
                    icon: Icons.local_shipping_rounded,
                    label: AppLanguage.tr(ar: 'في الطريق', en: 'On the Way'),
                    isCompleted: false,
                    isActive: true,
                  ),
                  _buildStepItem(
                    icon: Icons.home_rounded,
                    label: AppLanguage.tr(ar: 'تم التسليم', en: 'Delivered'),
                    isCompleted: false,
                    isActive: false,
                    onTap: () {
                      setState(() {
                        _isOrderDelivered = true;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    Color bgColor = colorSurfaceContainer;
    Color iconColor = colorOnSurfaceVariant;

    if (isCompleted || isActive) {
      bgColor = colorSecondaryContainer;
      iconColor = Colors.white;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: colorSecondaryContainer.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? colorSecondary
                  : (isCompleted ? colorOnSurface : colorOnSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  // 3. DRIVER CARD
  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
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
          InkWell(
            onTap: () {
              context.pushPage(const DriverProfileScreen());
            },
            borderRadius: BorderRadius.circular(14),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colorSecondaryContainer,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.person,
                            size: 36,
                            color: colorSecondary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -1,
                      right: -1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppLanguage.tr(
                                  ar: AppLanguage.tr(ar: 'الكابتن أحمد الخوالدة', en: 'Driver Ahmad Al-Khawaldeh'),
                                  en: 'Captain Ahmad Al-Khawaldeh',
                                ),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: colorOnSurface,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                color: colorSecondaryContainer,
                                size: 16,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorSurfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFD651E), size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  '4.9',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorOnSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLanguage.tr(
                          ar: '1,240 طلب غاز ناجح • عرض الملف الشخصي',
                          en: '1,240 deliveries • View Profile',
                        ),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping_outlined,
                            size: 15,
                            color: colorSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLanguage.tr(
                              ar: 'شاحنة معتمدة • لوحة: 48-12903',
                              en: 'Certified Truck • Plate: 48-12903',
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
          ),
          const SizedBox(height: 12),

          // Civil Defense Gas Certification Credential Tag
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: colorSecondaryContainer,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'فني غاز معتمد من الدفاع المدني الأردني', en: 'Certified Gas Technician - Jordan Civil Defense'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'فحص صمامات احترافي وتفريغ هواء آمن معتمد', en: 'Professional valve test & certified safe air purging'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 10,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Call & Chat Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLanguage.tr(ar: 'جاري الاتصال بالكابتن أحمد (0790000000)...', en: 'Calling driver Ahmad (0790000000)...'),
                            style: GoogleFonts.ibmPlexSansArabic(),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: colorPrimaryContainer,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSecondaryContainer,
                      foregroundColor: colorOnPrimary,
                      elevation: 2,
                      shadowColor: colorSecondaryContainer.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.phone_rounded, size: 18),
                    label: Text(
                      AppLanguage.tr(ar: 'اتصال بالكابتن', en: 'Call Driver'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _showChatSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSurfaceContainer,
                      foregroundColor: colorOnSurface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          AppLanguage.tr(ar: 'محادثة فورية', en: 'Live Chat'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: colorSecondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Micro Quick Instructions Direct Chips
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLanguage.tr(ar: 'رسائل سريعة للكابتن:', en: 'Quick Messages to Driver:'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildQuickChip(0, AppLanguage.tr(ar: 'أنا بالبناية الآن 👋', en: 'I am at the building now 👋')),
                    _buildQuickChip(1, AppLanguage.tr(ar: 'رن الجرس عند الوصول 🔔', en: 'Ring bell upon arrival 🔔')),
                    _buildQuickChip(2, AppLanguage.tr(ar: 'طابق ثالث بمصعد 🛗', en: '3rd floor with elevator 🛗')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(int id, String text) {
    final bool isSelected = _selectedQuickMessages.contains(id);

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedQuickMessages.remove(id);
            } else {
              _selectedQuickMessages.add(id);
            }
          });

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLanguage.tr(
                  ar: 'تم إرسال: "$text" للكابتن',
                  en: 'Sent: "$text" to captain',
                ),
                style: GoogleFonts.ibmPlexSansArabic(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              backgroundColor: colorPrimaryContainer,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? colorSecondaryContainer : colorSurfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : colorOnSurface,
            ),
          ),
        ),
      ),
    );
  }

  // 4. SAFETY VERIFICATION ALERT BOX
  Widget _buildSafetyAlertBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorErrorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorError.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: colorError,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLanguage.tr(ar: 'إرشادات الأمان المنزلية', en: 'Home Safety Guidelines'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorError,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLanguage.tr(ar: 'تأكد من وجود الختم الحراري وسلامة صمام الأمان على الأسطوانة. الكابتن مجهّز بمانع تسريب معتمد لفحص التركيب مجاناً.', en: 'Verify heat seal and safety valve integrity. Driver is equipped to test installation free of charge.'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    height: 1.4,
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

  // 5. ORDER DRAWER DETAIL BREAKDOWN
  Widget _buildOrderDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: colorSecondaryContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLanguage.tr(ar: 'تفاصيل الشحنة', en: 'Shipment Details'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorSecondaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.payments_rounded,
                      size: 13,
                      color: colorSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLanguage.tr(ar: 'نقداً عند الاستلام', en: 'Cash on Delivery'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: colorSurfaceLow),
          // Item 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.propane_tank_rounded,
                      color: colorSecondary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'أسطوانة غاز منزلي (12.5 كغ)', en: 'Household LPG Cylinder (12.5 kg)'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'استبدال أسطوانة فارغة بأسطوانة ممتلئة', en: 'Exchange empty cylinder with filled one'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 10,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                AppLanguage.tr(ar: '7.00 د.أ', en: '7.00 JOD'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Item 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: colorSecondary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'ساعة غاز إيطالي (منظم ضغط عالي)', en: 'Italian Gas Regulator (High Performance)'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'مع خرطوم أمان ومربطين مجاناً', en: 'With safety hose & 2 clamps free'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 10,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                AppLanguage.tr(ar: '10.00 د.أ', en: '10.00 JOD'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Delivery promo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLanguage.tr(ar: 'أجرة التوصيل والتركيب', en: 'Delivery & Install Fee'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOnSurfaceVariant,
                ),
              ),
              Text(
                AppLanguage.tr(ar: 'مجاني بمناسبة الشتاء', en: 'Free Winter Promotion'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: colorSurfaceLow),
          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.tr(ar: 'المجموع الكلي المطلوب', en: 'Total Amount Due'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  Text(
                    AppLanguage.tr(ar: 'شامل الضريبة وفحص التسريب', en: 'Includes tax & leak inspection'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 10,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '17.00',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colorSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppLanguage.tr(ar: 'د.أ', en: 'JOD'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. HELP SUPPORT DESK BUTTON
  Widget _buildSupportButton() {
    return Center(
      child: InkWell(
        onTap: _showSupportDialog,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorSurfaceContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.support_agent_rounded,
                size: 18,
                color: colorOnSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                AppLanguage.tr(ar: 'مركز المساعدة والدعم الفني المباشر', en: 'Help & Live Support Center'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // VIEW 2: COMPLETED DELIVERY & DRIVER RATING
  // ==========================================
  Widget _buildCompletedOrderView() {
    return SingleChildScrollView(
      key: const ValueKey('completed_order_view'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
      child: Column(
        children: [
          // Celebratory Status Header
          _buildCelebratoryHeader(),
          const SizedBox(height: 20),

          // Receipt & Payment Summary Card
          _buildReceiptSummaryCard(),
          const SizedBox(height: 16),

          // Dedicated Driver Rating Component
          _buildDriverRatingCard(),
          const SizedBox(height: 16),

          // Action CTA Buttons
          _buildCompletionActions(),
          const SizedBox(height: 16),

          // Mandatory Safety Reminder Footer
          _buildSafetyReminderFooter(),
        ],
      ),
    );
  }

  // Celebratory Header
  Widget _buildCelebratoryHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorSurfaceHigh,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorSecondaryContainer.withValues(alpha: 0.2),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: colorSecondaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorSurfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: colorSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                AppLanguage.tr(ar: 'طلب منجز ومغلق', en: 'Order Completed & Closed'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLanguage.tr(ar: 'تم تسليم الطلب بنجاح!', en: 'Order Delivered Successfully!'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorOnSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLanguage.tr(ar: 'نتمنى لكم استخداماً آمناً ودافئاً في منزلكم.', en: 'Wishing you a safe and warm home.'),
          textAlign: TextAlign.center,
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 13,
            color: colorOnSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // Receipt Summary Card
  Widget _buildReceiptSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
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
          // Header with Order Number and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.tr(ar: 'رقم الفاتورة المرجعية', en: 'Reference Invoice Number'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                  Text(
                    '#84935',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: colorSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLanguage.tr(ar: 'اليوم 02:45 م (18 دقيقة)', en: 'Today 02:45 PM (18 mins)'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: colorSurfaceLow),

          // Items Manifest Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.propane_tank_rounded,
                      color: colorSecondary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'أسطوانة غاز منزلي 12.5 كغ', en: 'LPG Gas Cylinder 12.5 kg'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'استبدال أسطوانة فارغة', en: 'Exchange empty cylinder'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                AppLanguage.tr(ar: '7.00 د.أ', en: '7.00 JOD'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.build_circle_outlined,
                      color: colorOnSurfaceVariant,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'منظم ضغط غاز إيطالي أصلي', en: 'Original Italian Gas Regulator'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'ضمان عام كامل', en: '1 Year Full Warranty'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                AppLanguage.tr(ar: '10.00 د.أ', en: '10.00 JOD'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Free Safety Check Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorSurfaceHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      color: colorSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLanguage.tr(ar: 'فحص تسريب صمام الأمان مجاناً', en: 'Free Valve Leak Inspection'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        Text(
                          AppLanguage.tr(ar: 'تم فحص مانع التسريب بمحلول الفحص بنجاح', en: 'Leak barrier verified with inspection solution'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 10,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorSurfaceLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLanguage.tr(ar: 'مكتمل', en: 'Completed'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Total and Cash Received
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'المبلغ المستلم نقداً', en: 'Amount Received in Cash'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    Text(
                      AppLanguage.tr(ar: '17.00 د.أ', en: '17.00 JOD'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: colorSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 15,
                      color: colorOnSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        AppLanguage.tr(ar: 'تم استلام المبلغ بالكامل نقداً ومطابقته بواسطة الكابتن', en: 'Amount fully collected in cash and verified by driver'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
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

  // Driver Rating Card
  Widget _buildDriverRatingCard() {
    final List<Map<String, dynamic>> tags = [
      {'icon': Icons.timer_outlined, 'label': AppLanguage.tr(ar: 'التزام بالوقت والسرعة', en: 'Punctual & Fast')},
      {'icon': Icons.sentiment_very_satisfied_outlined, 'label': AppLanguage.tr(ar: 'لباقة وحسن تعامل', en: 'Polite & Friendly')},
      {'icon': Icons.health_and_safety_outlined, 'label': AppLanguage.tr(ar: 'إجراء فحص الأمان والصمام', en: 'Performed Safety & Valve Test')},
      {'icon': Icons.fitness_center_outlined, 'label': AppLanguage.tr(ar: 'المساعدة بنقل الأسطوانة', en: 'Helped Carrying Cylinder')},
      {'icon': Icons.calculate_outlined, 'label': AppLanguage.tr(ar: 'الدقة بالحساب النقدي', en: 'Accurate Cash Change')},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
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
          // Driver profile row
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDP2ZsrRZL2oDNSp0f_qmYelhRHaLPGMhhcTaTI0mjWQ1cg1hmiB_8-Ieo63kK2tiNdQlxTA1Uk0GD258cMXN-3j7dmuR9baIdSlE2GmQTo1SoiHJB2kqUa3dV9JPvpUQ0f2wrm-rdDDZFPUVZjh4WAzDd97ujlyux_amY-f_vqC5cInWYaVgeEiTfVhKwQVeWXD3UcnJC5LLeh6lnRm6W4rmlhwADCnamcrGQz48qXGc8J8Gwt00uovQ',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.person,
                          size: 32,
                          color: colorSecondary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: colorSecondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'الكابتن أحمد الخوالدة', en: 'Driver Ahmad Al-Khawaldeh'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    Text(
                      AppLanguage.tr(ar: 'مركبة توزيع معتمدة • لوحة 42-8921', en: 'Certified Delivery Truck • Plate 42-8921'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 3),
                      Text(
                        '4.9',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppLanguage.tr(ar: '1,420+ توصيلة', en: '1,420+ Deliveries'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 10,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Rating Prompt
          Text(
            AppLanguage.tr(ar: 'كيف كانت تجربة التوصيل والتعامل مع الكابتن؟', en: 'How was your delivery experience with the driver?'),
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLanguage.tr(ar: 'تقييمك يساعدنا على الحفاظ على معايير السلامة والخدمة المتميزة لطواقمنا في الميدان.', en: 'Your rating helps maintain safety standards and premium service for field crews.'),
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 11,
              color: colorOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // 5 Star Interactive Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= _selectedRatingStars;

              return IconButton(
                onPressed: () {
                  setState(() {
                    _selectedRatingStars = starIndex;
                  });
                },
                iconSize: 36,
                icon: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled ? colorSecondary : colorSurfaceHighest,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Quick Feedback Tag Pills
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLanguage.tr(ar: 'ما الذي أعجبك في خدمة الكابتن؟', en: 'What did you like about the service?'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorOnSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(tags.length, (i) {
              final isSelected = _selectedFeedbackTags.contains(i);
              final tag = tags[i];

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedFeedbackTags.remove(i);
                    } else {
                      _selectedFeedbackTags.add(i);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? colorSecondary : colorSurfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tag['icon'],
                        size: 15,
                        color: isSelected ? Colors.white : colorOnSurface,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tag['label'],
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : colorOnSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Optional Notes
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLanguage.tr(ar: 'ملاحظات إضافية (اختياري)', en: 'Additional Notes (Optional)'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorOnSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorSurfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _ratingNotesController,
              maxLines: 3,
              style: GoogleFonts.ibmPlexSansArabic(fontSize: 12, color: colorOnSurface),
              decoration: InputDecoration(
                hintText: AppLanguage.tr(ar: 'أضف ملاحظات إضافية عن أداء الكابتن (اختياري)...', en: 'Add driver feedback (optional)...'),
                hintStyle: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  color: colorOnSurfaceVariant.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Completion Actions
  Widget _buildCompletionActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isRatingSubmitted ? null : _handleRatingSubmission,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isRatingSubmitted ? colorSurfaceHigh : colorSecondaryContainer,
              foregroundColor: _isRatingSubmitted ? colorOnSurface : colorOnPrimary,
              elevation: _isRatingSubmitted ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isRatingSubmitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLanguage.tr(ar: 'جاري حفظ تقييمك...', en: 'Saving rating...'),
                        style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isRatingSubmitted ? Icons.task_alt : Icons.send_rounded,
                        size: 18,
                        color: _isRatingSubmitted ? colorSecondary : Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isRatingSubmitted ? AppLanguage.tr(ar: 'شكراً لملاحظاتك!', en: 'Thank you for your rating!') : AppLanguage.tr(ar: 'إرسال التقييم', en: 'Submit Rating'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSurfaceContainer,
              foregroundColor: colorOnSurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLanguage.tr(ar: 'العودة للرئيسية', en: 'Back to Home'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Safety Reminder Footer
  Widget _buildSafetyReminderFooter() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorErrorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorOnErrorContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.crisis_alert_rounded,
              color: colorError,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLanguage.tr(ar: 'تنبيه أمان وسلامة منزلية:', en: 'Home Safety Advisory:'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorOnErrorContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLanguage.tr(ar: 'في حال ملاحظة أي رائحة غاز، يرجى إغلاق المفتاح فوراً والتواصل مع طوارئ الدفاع المدني 911 أو الدعم الفني.', en: 'If you smell gas, close valve immediately and contact Civil Defense 911 or support.'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    height: 1.4,
                    color: colorOnErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar (for completed state)
  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: colorSurface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.local_fire_department_rounded, AppLanguage.tr(ar: 'الرئيسية', en: 'Home')),
              _buildNavItem(1, Icons.receipt_long_rounded, AppLanguage.tr(ar: 'طلباتي', en: 'Orders'), hasBadge: true),
              _buildNavItem(2, Icons.notifications_rounded, AppLanguage.tr(ar: 'الإشعارات', en: 'Notifications')),
              _buildNavItem(3, Icons.person_rounded, AppLanguage.tr(ar: 'حسابي', en: 'Profile')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool hasBadge = false}) {
    final isSelected = _selectedNavIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? colorSecondaryContainer : colorOnSurfaceVariant,
              ),
              if (hasBadge)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: colorSecondaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? colorSecondaryContainer : colorOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Map Route & Animated Pulse
class _MapRoutePainter extends CustomPainter {
  final double pulseScale;
  final Color primaryColor;
  final Color darkColor;

  _MapRoutePainter({
    required this.pulseScale,
    required this.primaryColor,
    required this.darkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Route coordinates scaled
    final start = Offset(w * 0.16, h * 0.84); // Customer Home
    final p1 = Offset(w * 0.38, h * 0.75);
    final p2 = Offset(w * 0.55, h * 0.50); // Truck position
    final end = Offset(w * 0.84, h * 0.18); // Depot start

    final routePath = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, end.dx, end.dy);

    // Route Backing Line (White Shadow)
    final backPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(routePath, backPaint);

    // Dotted Orange Glow Route Line
    final linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, linePaint);

    // 1. Customer Home Destination Pin
    final homePaint = Paint()..color = darkColor;
    canvas.drawCircle(start, 18, homePaint);

    final homeRingPaint = Paint()..color = Colors.white;
    canvas.drawCircle(start, 7, homeRingPaint);

    final homeDotPaint = Paint()..color = primaryColor;
    canvas.drawCircle(start, 3, homeDotPaint);

    // 2. Animated Truck Pin
    final pulsePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.25 / pulseScale)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(p2, 22 * pulseScale, pulsePaint);

    final truckOuterPaint = Paint()..color = darkColor;
    canvas.drawCircle(p2, 16, truckOuterPaint);

    final truckInnerPaint = Paint()..color = primaryColor;
    canvas.drawCircle(p2, 13, truckInnerPaint);

    // Draw truck mini icon symbol
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.local_shipping.codePoint),
        style: TextStyle(
          fontSize: 16,
          fontFamily: Icons.local_shipping.fontFamily,
          package: Icons.local_shipping.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(p2.dx - textPainter.width / 2, p2.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _MapRoutePainter oldDelegate) {
    return oldDelegate.pulseScale != pulseScale;
  }
}
