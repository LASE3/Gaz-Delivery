// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'app_language.dart';
import 'package:google_fonts/google_fonts.dart';

import 'delivery_location.dart';
import 'products_and_accessories.dart';
import 'login_screen.dart';

class DeliveryErrorStateScreen extends StatefulWidget {
  final String initialState; // 'out', 'busy', 'cart'

  const DeliveryErrorStateScreen({
    super.key,
    this.initialState = 'out',
  });

  @override
  State<DeliveryErrorStateScreen> createState() =>
      _DeliveryErrorStateScreenState();
}

class _DeliveryErrorStateScreenState extends State<DeliveryErrorStateScreen> {
  // Theme Color Palette
  static const Color colorBackground = Color(0xFFF8F9FF);
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
  static const Color colorOnTertiaryContainer = Color(0xFF188ACE);

  late String _activeState;
  final TextEditingController _notifyPhoneController = TextEditingController();
  bool _isReconnecting = false;

  @override
  void initState() {
    super.initState();
    _activeState = widget.initialState;
  }

  @override
  void dispose() {
    _notifyPhoneController.dispose();
    super.dispose();
  }

  void _handleRetryConnection() {
    setState(() {
      _isReconnecting = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isReconnecting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  AppLanguage.tr(ar: 'تم تحديث بيانات الاتصال بنجاح', en: 'Contact info updated successfully'),
                  style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                ),
              ],
            ),
            backgroundColor: colorPrimaryContainer,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _handleRegisterNotification() {
    if (_notifyPhoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLanguage.tr(ar: 'يرجى إدخال رقم الهاتف أولاً', en: 'Please enter phone number first'),
            style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          backgroundColor: colorError,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              AppLanguage.tr(ar: 'تم تسجيل رقمك! سنرسل لك إشعاراً ورصيد 3 دنانير فور توفر الخدمة.', en: 'Number registered! We will notify you with 3 JOD credit upon launch.'),
              style: GoogleFonts.ibmPlexSansArabic(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: colorPrimaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
    _notifyPhoneController.clear();
  }

  void _handleQueuePriorityBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time_filled, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              AppLanguage.tr(ar: 'تم حجز أولوية! سيتم توجيه أول شاحنة متاحة إلى موقعك.', en: 'Priority booked! Next available truck will be dispatched.'),
              style: GoogleFonts.ibmPlexSansArabic(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: colorSecondaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
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
        // Top App Bar
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: colorBackground.withValues(alpha: 0.95),
            elevation: 0.5,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            centerTitle: false,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colorSurfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppLanguage.chevronBack,
                      size: 16,
                      color: colorOnSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colorSecondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLanguage.tr(ar: 'حالات الخدمة والتوصيل', en: 'Delivery & Service States'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: colorSecondaryContainer, width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.person,
                          color: colorOnSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Subtle Connectivity Banner
              _buildConnectivityBanner(),
              const SizedBox(height: 12),

              // 2. Interactive Segmented Selector for States
              _buildStateSelectorTabs(),
              const SizedBox(height: 16),

              // 3. Dynamic State Content
              if (_activeState == 'out')
                _buildOutOfCoverageState()
              else if (_activeState == 'busy')
                _buildDriversBusyState()
              else
                _buildEmptyCartState(),

              const SizedBox(height: 20),

              // 4. Secondary States Preview & Safety Protocol Advisory
              _buildSecondaryAdvisorySection(),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  // 1. CONNECTIVITY BANNER
  Widget _buildConnectivityBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorSurfaceHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorSurfaceHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 18,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.tr(ar: 'اتصال الشبكة ضعيف أو غير مستقر', en: 'Weak or unstable connection'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  Text(
                    AppLanguage.tr(ar: 'يتم تحديث خرائط التوزيع في وضع عدم الاتصال', en: 'Maps updating in offline mode'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 10,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: _isReconnecting ? null : _handleRetryConnection,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorSurfaceLowest,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: _isReconnecting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorSecondary,
                      ),
                    )
                  : Text(
                      AppLanguage.tr(ar: 'إعادة المحاولة', en: 'Retry'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. STATE SELECTOR TABS
  Widget _buildStateSelectorTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorSurfaceLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTabItem(
            id: 'out',
            label: AppLanguage.tr(ar: 'خارج التغطية', en: 'Out of Range'),
          ),
          const SizedBox(width: 4),
          _buildTabItem(
            id: 'busy',
            label: AppLanguage.tr(ar: 'ضغط التوزيع', en: 'High Demand'),
          ),
          const SizedBox(width: 4),
          _buildTabItem(
            id: 'cart',
            label: AppLanguage.tr(ar: 'السلة فارغة', en: 'Empty Cart'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String id, required String label}) {
    final bool isSelected = _activeState == id;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeState = id;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorSurfaceLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? colorSecondaryContainer
                    : colorOnSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 3A. STATE 1: OUT OF COVERAGE
  Widget _buildOutOfCoverageState() {
    return Column(
      children: [
        // Main Illustrated Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Tactile Graphic
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: colorSecondaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_off_rounded,
                      size: 38,
                      color: colorSecondaryContainer,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorSurfaceLowest,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shield_outlined,
                              size: 11, color: colorSecondary),
                          const SizedBox(width: 2),
                          Text(
                            AppLanguage.tr(ar: 'مرخّص', en: 'Certified'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: colorSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Alert Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorErrorContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: colorError,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLanguage.tr(ar: 'إربد والعقبة والمحافظات الأخرى غير مفعلة', en: 'Irbid, Aqaba & other governorates not yet active'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorOnErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Copy
              Text(
                AppLanguage.tr(ar: 'نعتذر، الخدمة غير متاحة في هذا الموقع حالياً', en: 'Sorry, service is not available in this location currently'),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLanguage.tr(ar: 'وفقاً للوائح قطاع الطاقة والمعادن وتصاريح أسطول الغاز السائل المعتمد، تغطي مركباتنا حالياً محافظتي العاصمة عمّان والزرقاء فقط لضمان معايير السلامة التامة والتوصيل السريع.', en: 'Per EMRC regulations and fleet permits, deliveries currently cover Amman & Zarqa only to ensure safety standards and quick response.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOnSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Action Button to Change Location
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeliveryLocationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.explore_rounded, size: 18),
                  label: Text(
                    AppLanguage.tr(ar: 'تغيير العنوان إلى عمّان أو الزرقاء', en: 'Change address to Amman or Zarqa'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Notify Lead Capture Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          size: 18,
                          color: colorSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLanguage.tr(ar: 'أبلغني فور توفر الخدمة في حيي', en: 'Notify me when service launches in my area'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLanguage.tr(ar: 'سجّل رقم هاتفك وسنرسل لك إشعاراً مع رصيد ترحيبي 3 دنانير عند تدشين الأسطول في منطقتك.', en: 'Enter your phone number and receive 3 JOD credit when service opens in your neighborhood.'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: _handleRegisterNotification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimaryContainer,
                              foregroundColor: colorOnPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                            ),
                            child: Text(
                              AppLanguage.tr(ar: 'تسجيل', en: 'Register'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: colorSurfaceLowest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '+962',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 12,
                                    color: colorOnSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: TextField(
                                    controller: _notifyPhoneController,
                                    keyboardType: TextInputType.phone,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 13,
                                      color: colorOnSurface,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '079 XXXXXXX',
                                      hintStyle: GoogleFonts.ibmPlexSansArabic(
                                        fontSize: 12,
                                        color: colorOnSurfaceVariant,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
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
        ),
        const SizedBox(height: 14),

        // Logistics Regional Grid
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
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
                    AppLanguage.tr(ar: 'نطاق التغطية المرخّص اليوم', en: 'Licensed Coverage Today'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorSurfaceHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLanguage.tr(ar: 'تحديث فوري', en: 'Live Update'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorOnTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLanguage.tr(ar: 'محافظة عمّان', en: 'Amman Governorate'),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorOnSurface,
                                ),
                              ),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: colorSecondaryContainer,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppLanguage.tr(ar: '٢٤ شاحنة • ١٨ دقيقة وصول', en: '24 Trucks • 18 min arrival'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 10,
                              color: colorOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLanguage.tr(ar: 'محافظة الزرقاء', en: 'Zarqa Governorate'),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorOnSurface,
                                ),
                              ),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: colorSecondaryContainer,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppLanguage.tr(ar: '١١ شاحنة • ٢٦ دقيقة وصول', en: '11 Trucks • 26 min arrival'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 10,
                              color: colorOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3B. STATE 2: NO DRIVERS AVAILABLE / QUEUE FULL
  Widget _buildDriversBusyState() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon with alert badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorSurfaceHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  size: 38,
                  color: colorOnSurface,
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorSecondaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title & Body
          Text(
            AppLanguage.tr(ar: 'كافة سيارات الغاز منشغلة في قطاعك', en: 'All gas trucks busy in your sector'),
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLanguage.tr(ar: 'الطلب مرتفع حالياً في منطقتك (دوار عبدون ومحيطه). نلبي الطلبات بالتسلسل، وسيتوفر موزع متاح خلال دقائق.', en: 'High demand in your area. Orders fulfilled sequentially, truck available in minutes.'),
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12,
              color: colorOnSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Live Queue Meter
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'وقت الانتظار التقريبي للتفريغ', en: 'Estimated Wait Time'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurface,
                      ),
                    ),
                    Text(
                      AppLanguage.tr(ar: '١٤ دقيقة', en: '14 minutes'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorSecondaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 6,
                    color: colorSurfaceHighest,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.75,
                        child: Container(
                          color: colorSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'أمامك في الطابور: ٣ منازل', en: 'Ahead in queue: 3 homes'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                    Text(
                      AppLanguage.tr(ar: 'شاحنة أقرب قطاع: حي الياسمين', en: 'Nearest truck sector: Al-Yasmin'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _handleQueuePriorityBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimaryContainer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLanguage.tr(ar: 'حجز أولوية عند توفر الشاحنة القادمة', en: 'Reserve priority for next truck'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3C. STATE 3: EMPTY CART
  Widget _buildEmptyCartState() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_basket_outlined,
              size: 38,
              color: colorOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLanguage.tr(ar: 'سلتك فارغة تماماً', en: 'Your Cart is Empty'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLanguage.tr(ar: 'لم تقم بإضافة أي أسطوانات غاز أو ملحقات أمان (منظمات وخراطيم) بعد. أضف أسطوانتك المنزلية بنقرة واحدة.', en: 'You have not added cylinders or safety accessories yet. Add with one tap.'),
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12,
              color: colorOnSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Quick Add Cylinder Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorSurfaceHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.propane_tank_rounded,
                        color: colorSecondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLanguage.tr(ar: 'أسطوانة غاز منزلية (تبديل)', en: 'LPG Gas Cylinder (Exchange)'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        Text(
                          AppLanguage.tr(ar: 'وزن صافي ١٢.٥ كغم • فحص تسريب مجاني', en: '12.5 kg Net Weight • Free Leak Test'),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Button to Go to Catalog
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductsAndAccessoriesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorSecondaryContainer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
              label: Text(
                AppLanguage.tr(ar: 'إضافة لطلب السريع وتصفح الملحقات', en: 'Quick Add & Browse Accessories'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. SECONDARY ADVISORY SECTION
  Widget _buildSecondaryAdvisorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLanguage.tr(ar: 'حالات الخدمة الإضافية', en: 'Other Service Scenarios'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colorOnSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),

        // Quick Products Preview Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.propane_tank_rounded,
                      size: 20,
                      color: colorOnSurface,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'سلتك فارغة من أسطوانات الغاز', en: 'Cart empty of gas cylinders'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'سعر التبديل الرسمي: 7.00 د.أ شامل التوصيل', en: 'Official exchange: 7.00 JOD incl. delivery'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 10,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _activeState = 'cart';
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorSurfaceLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLanguage.tr(ar: 'تصفح المنتجات', en: 'Browse Products'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Safety Protocol Advisory Note
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorSurfaceLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.health_and_safety_rounded,
                size: 20,
                color: colorSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'بروتوكول السلامة المنزلي', en: 'Home Safety Protocol'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLanguage.tr(ar: 'يتولى السائق المعتمد فحص جلدة الصمام وتركيب المنظم في موقعك مجاناً للتأكد من عدم وجود أي تسريب غازي قبل استلام القيمة.', en: 'Certified driver inspects valve gasket and installs regulator free of charge to confirm safety before collecting payment.'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        height: 1.4,
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
  }
}
