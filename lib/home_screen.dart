// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_language.dart';
import 'page_transitions.dart';
import 'permission_helper.dart';
import 'driver_profile_screen.dart';
import 'delivery_location.dart';
import 'order_tracking.dart';
import 'driver_chat_screen.dart';
import 'orders_history_screen.dart';
import 'product_details_screen.dart';
import 'user_profile_screen.dart';
import 'notifications_screen.dart';
import 'products_and_accessories.dart';
import 'help_complaints_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Theme Color Palette
  static const Color colorBackground = Color(0xFFF8F9FF);
  static const Color colorSurface = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceContainer = Color(0xFFE5EEFF);
  static const Color colorSurfaceHigh = Color(0xFFDCE9FF);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);
  static const Color colorPrimaryContainer = Color(0xFF131B2E);
  static const Color colorOnPrimary = Color(0xFFFFFFFF);
  static const Color colorPrimaryFixedDim = Color(0xFFBEC6E0);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorSecondaryFixed = Color(0xFFFFDBCE);
  static const Color colorSecondaryFixedDim = Color(0xFFFFB599);
  static const Color colorFlameBlue = Color(0xFF188ACE);

  // Delivery Location
  String _deliveryLocation = 'عمان، عبدون الشمالي';

  // Order State
  int _gasQuantity = 1;
  final double _gasUnitPrice = 7.00;
  final double _deliveryFee = 1.50;
  int _selectedNavIndex = 0;

  // Accessory Quantities Map
  final Map<int, int> _accessoryQuantities = {
    0: 0,
    1: 0,
    2: 0,
    3: 1, // Free check service selected by default
  };

  double get _totalPrice {
    double accessoriesTotal = 0;
    if ((_accessoryQuantities[0] ?? 0) > 0) accessoriesTotal += (_accessoryQuantities[0]! * 8.50);
    if ((_accessoryQuantities[1] ?? 0) > 0) accessoriesTotal += (_accessoryQuantities[1]! * 3.50);
    if ((_accessoryQuantities[2] ?? 0) > 0) accessoriesTotal += (_accessoryQuantities[2]! * 2.00);

    return (_gasQuantity * _gasUnitPrice) + _deliveryFee + accessoriesTotal;
  }

  void _incrementGas() {
    if (_gasQuantity < 5) {
      setState(() {
        _gasQuantity++;
      });
    }
  }

  void _decrementGas() {
    if (_gasQuantity > 1) {
      setState(() {
        _gasQuantity--;
      });
    }
  }

  void _toggleAccessory(int index) {
    setState(() {
      if (index == 3) {
        _accessoryQuantities[3] = (_accessoryQuantities[3] == 1) ? 0 : 1;
      } else {
        _accessoryQuantities[index] = (_accessoryQuantities[index] ?? 0) + 1;
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تمت إضافة المنتج إلى طلبك',
          style: GoogleFonts.ibmPlexSansArabic(fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        backgroundColor: colorPrimaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showOrderSuccessDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 20),
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: colorSecondaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: colorSecondaryContainer,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'تم استلام طلبك بنجاح!',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تم تأكيد طلبك لـ $_gasQuantity أسطوانة غاز بإجمالي ${_totalPrice.toStringAsFixed(2)} د.أ.\nالكابتن أحمد في طريقه لتوصيل طلبك خلال 20 دقيقة.',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 14,
                  height: 1.5,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondaryContainer,
                    foregroundColor: colorOnPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'متابعة حالة التوصيل',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showTrackingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تتبع الشحنة المباشر',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'وصول خلال 12 دقيقة',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.pushPage(const DriverProfileScreen());
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorSurfaceLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorSurfaceContainer),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorSecondaryContainer,
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.person,
                              color: colorSecondaryContainer,
                              size: 28,
                            ),
                          ),
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
                                  AppLanguage.tr(
                                    ar: 'الكابتن أحمد الخوالدة',
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
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFD651E), size: 16),
                                const SizedBox(width: 3),
                                Text(
                                  '4.9 (1,240+)',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 12,
                                    color: colorOnSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  AppLanguage.tr(ar: '• عرض الملف', en: '• View Profile'),
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: colorSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.pushPage(const DriverChatScreen());
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorSurfaceContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: colorOnSurface,
                            size: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLanguage.tr(
                                  ar: 'جاري الاتصال بالكابتن أحمد: 0790000000',
                                  en: 'Calling Captain Ahmad: 0790000000',
                                ),
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
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorSecondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.phone, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTimelineStep(
                title: AppLanguage.tr(ar: 'تم استلام وتجهيز الطلب', en: 'Order Prepared & Verified'),
                subtitle: AppLanguage.tr(ar: 'تم التحقق من ختم الأمان والوزن', en: 'Safety seal & weight inspected'),
                isDone: true,
                isCurrent: false,
              ),
              _buildTimelineStep(
                title: AppLanguage.tr(ar: 'الكابتن في الطريق إليك', en: 'Captain On The Way'),
                subtitle: AppLanguage.tr(ar: 'الشارع الرئيسي - عبدون الشمالي', en: 'Main Street - North Abdoun'),
                isDone: true,
                isCurrent: true,
              ),
              _buildTimelineStep(
                title: AppLanguage.tr(ar: 'التسليم والفحص المنزلي', en: 'Home Delivery & Inspection'),
                subtitle: AppLanguage.tr(ar: 'فحص التسريب وتأكيد الدفع نقداً', en: 'Leak test & Cash on Delivery'),
                isDone: false,
                isCurrent: false,
                isLast: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pushPage(const OrderTrackingScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.map_rounded, size: 20),
                  label: Text(
                    AppLanguage.tr(
                      ar: 'فتح شاشة التتبع والخرائط المباشرة',
                      en: 'Open Live GPS Tracking & Maps',
                    ),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isCurrent,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone ? (isCurrent ? colorSecondaryContainer : colorSecondary) : colorSurfaceHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check : Icons.circle,
                size: 14,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isDone ? colorSecondaryFixedDim : colorSurfaceHigh,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                  color: isCurrent ? colorSecondary : colorOnSurface,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
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
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section 1: Real-time Quick Status & ETA Ticker
                          _buildQuickStatusTicker(),
                          const SizedBox(height: 16),

                          // Section 2: Active Delivery Banner
                          _buildActiveDeliveryBanner(),
                          const SizedBox(height: 20),

                          // Section 3: Primary Gas Order Hero Card (1-Tap Experience)
                          _buildPrimaryGasCard(),
                          const SizedBox(height: 16),

                          // Section 4: Promotional Trust Banner (Amman & Zarqa Cash on Delivery)
                          _buildCashOnDeliveryBanner(),
                          const SizedBox(height: 20),

                          // Section 5: Gas Accessories & Safety Equipment
                          _buildAccessoriesSection(),
                          const SizedBox(height: 20),

                          // Section 6: Previous Orders
                          _buildPastOrdersSection(),
                          const SizedBox(height: 16),

                          // Section 7: Support & Quality Assurance
                          _buildHelpSupportBanner(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavigation(),
          ),
        );
      },
    );
  }

  // HEADER WIDGET
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorSurface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Logo & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand Logo & Name
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFD651E), Color(0xFFA73A00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: colorSecondaryContainer.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLanguage.tr(ar: 'غاز الأردن', en: 'Jordan Gas'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              // Language Switcher & Profile Avatar (Clickable)
              Row(
                children: [
                  // Language Toggle (EN / عربي)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        AppLanguage.toggleLanguage();
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colorSurfaceLow,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: colorSurfaceHigh),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.language_rounded,
                                size: 16,
                                color: colorSecondaryContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLanguage.isArabic ? 'EN' : 'عربي',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: colorOnSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Top-Left Profile Picture (Large Tap Target & Direct Profile Entry)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.pushPage(const UserProfileScreen());
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Tooltip(
                        message: AppLanguage.tr(ar: 'الملف الشخصي', en: 'User Profile'),
                        child: Container(
                          width: 42,
                          height: 42,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorSecondaryContainer,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorSecondaryContainer.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDcymBkUqtK2r72uSV8iVOPBkWf8cUREOvoOxt_quBLnhUZ-3rFNL-r7pO5GWHorxYxoLeezNJKNtNYZdJJXk0w4pCJMrF9fQhKvmu4sP4JykZujpk20e6BzqcRgX2n2mzbCvXtzzrRoFjoHl1hbE_WMzbHqoe1v_oduSg_oS-NuEHFQULOTkJwUgYNYj_VmBqwLW7C70wda6t4MaiTyl-C-RQUk4TSnWiG-cX7ck2o1tazfOC6b4RuTQ',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: colorSurfaceLow,
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: colorSecondaryContainer,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: Delivery Location Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: colorSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'موقع التوصيل', en: 'Delivery Location'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11,
                              color: colorOnSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _deliveryLocation,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colorOnSurface,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: colorOnSurfaceVariant,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final bool granted = await PermissionHelper.requestPermission(
                    context,
                    type: AppPermissionType.location,
                  );
                  if (!granted) return;

                  if (!mounted) return;
                  final newLocation = await context.pushPage<String>(
                    const DeliveryLocationScreen(),
                  );
                  if (newLocation != null && newLocation.isNotEmpty && mounted) {
                    setState(() {
                      _deliveryLocation = newLocation;
                    });
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(0, 32),
                ),
                icon: const Icon(
                  Icons.my_location_rounded,
                  size: 15,
                  color: colorSecondary,
                ),
                label: Text(
                  AppLanguage.tr(ar: 'تغيير', en: 'Change'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SECTION 1: REAL-TIME QUICK STATUS & ETA TICKER
  Widget _buildQuickStatusTicker() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bolt,
                    color: colorSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'المنطقة نشطة الآن',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorSurfaceHigh,
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
                      'عمّان والزرقاء',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: colorSurfaceLow, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    color: colorOnSurfaceVariant,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'زمن الوصول التقديري: ',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                  Text(
                    '20 - 35 دقيقة',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.verified_user,
                    color: colorSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'معتمد رسمياً',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      color: colorOnSurfaceVariant,
                      fontWeight: FontWeight.w500,
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

  // SECTION 2: ACTIVE DELIVERY BANNER
  Widget _buildActiveDeliveryBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorPrimaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorPrimaryContainer.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Glow Accent
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorSecondaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorSecondaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorSecondaryContainer.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: colorOnPrimary,
                  size: 24,
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
                          'طلبك قيد التوصيل الآن',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colorOnPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: colorSecondaryFixedDim,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'الكابتن أحمد في الطريق إليك (وصول خلال 12 دقيقة)',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        color: colorPrimaryFixedDim,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _showTrackingSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSecondaryContainer,
                  foregroundColor: colorOnPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(0, 38),
                ),
                child: Text(
                  'تتبع الطلب',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SECTION 3: PRIMARY GAS ORDER HERO CARD (1-TAP EXPERIENCE)
  Widget _buildPrimaryGasCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: colorSecondary,
                  size: 24,
                ),
                const SizedBox(width: 6),
                Text(
                  'ماذا تحتاج اليوم؟',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorSecondaryFixed.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'السعر مسعر حكومياً',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colorSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Main Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Feature Chips Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.door_front_door_outlined,
                          color: colorSecondary,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'توصيل فوري لباب المنزل أو الشقة',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorOnSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'غاز مسال نقي',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Product Info & Cylinder Graphic
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProductDetailsScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'اسطوانة غاز منزلي',
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: colorOnSurface,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    size: 16,
                                    color: colorSecondary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الوزن القياسي: 12.5 كغ • اضغط للتفاصيل',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12,
                                  color: colorSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '7.00',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: colorOnSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'د.أ',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: colorOnSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+ 1.50 د.أ توصيل',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12,
                                color: colorOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Tactile Cylinder Graphic Container
                  Container(
                    width: 92,
                    height: 112,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTactileCylinderGraphic(),
                        const SizedBox(height: 4),
                        Text(
                          '12.5 KG',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Safety & Inspection Notice
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.task_alt,
                      color: colorSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'يتم فحص وتأمين الأسطوانة والختم الحراري عند الاستلام لحمايتكم.',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          color: colorOnSurface,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Interactive Stepper & 1-Tap CTA
              Row(
                children: [
                  // Stepper
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _buildStepperBtn(
                          icon: Icons.remove,
                          onTap: _decrementGas,
                          enabled: _gasQuantity > 1,
                        ),
                        SizedBox(
                          width: 38,
                          child: Center(
                            child: Text(
                              '$_gasQuantity',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorOnSurface,
                              ),
                            ),
                          ),
                        ),
                        _buildStepperBtn(
                          icon: Icons.add,
                          onTap: _incrementGas,
                          enabled: _gasQuantity < 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // 1-Tap CTA Submit
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _showOrderSuccessDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorSecondaryContainer,
                          foregroundColor: colorOnPrimary,
                          elevation: 2,
                          shadowColor: colorSecondaryContainer.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_bag_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'اطلب الغاز الآن',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${((_gasQuantity * _gasUnitPrice) + _deliveryFee).toStringAsFixed(2)} د.أ)',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildStepperBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Material(
      color: enabled ? colorSurfaceLowest : colorSurfaceLowest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: enabled ? colorOnSurface : colorOnSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  // Custom Detailed Gas Cylinder Widget matching the HTML SVG
  Widget _buildTactileCylinderGraphic() {
    return SizedBox(
      width: 46,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Valve top handle
          Positioned(
            top: 0,
            child: Container(
              width: 14,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFF3F465C),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Cylinder Body
          Positioned(
            top: 6,
            child: Container(
              width: 38,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFD651E), Color(0xFFA73A00)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: colorSecondary.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_fire_department,
                      color: colorFlameBlue,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Base Rim
          Positioned(
            bottom: 2,
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF7F2B00),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 4: CASH ON DELIVERY BANNER
  Widget _buildCashOnDeliveryBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorSurfaceLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.payments_rounded,
              color: colorSecondary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الدفع نقداً عند الاستلام فقط',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'خدمتكم بأمان واحترافية في كافة أحياء عمّان ومحافظة الزرقاء. ادفع بعد معاينة الأسطوانة.',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
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

  // SECTION 5: ACCESSORIES & SAFETY EQUIPMENT
  Widget _buildAccessoriesSection() {
    final List<Map<String, dynamic>> accessories = [
      {
        'title': 'ساعة غاز إيطالي (منظم ضغط عالي الأمان)',
        'price': '8.50 د.أ',
        'badge': 'أمان عالي',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDP-Dx0IcOHsreYq8eiNbjOM8PKzjtX-GIjWNmFSbHDbOQ7ADvMZvRQXjnvRW9hUUovsdYdWPlBOp6Xf3Gs92FUqQNVZojcqr6Phm4ZOvwg-R4GJucuxfB9dJ8TkZP0US2kzVPQovAHioy0Nwh1EKA19SbW2FKWN6zLsgxA3yFNVNgtcggBIaTvuS_Glie7fL4-tR_FQUJSvn6QgB3NCTYM73rP0n4UVFS_UwkbponMr-U5nG-1os7OkQ',
        'isService': false,
      },
      {
        'title': 'بربيش غاز مقوى مع مرابط نحاسية',
        'price': '3.50 د.أ',
        'badge': '2 متر',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB2ATd8HPEC1cCG3IyYH6zCwa87Cj5-SNQyqA1L0ViTRGrV3hugqGnmJFV_5zZ49cpb-_kOTQt7dPzyEDEA-Ue2DHPO9ELLLSp7rjnRjIyaWGs_YBF4-1siT49QQazUEj_sKOV9CwXhVFwY6zIaDhKUKXRAscQoTVD1ODCIIxwHWks4aQtWK59LDiJMEnmq9xPktz5ItxttdL1miuVRPdei1dNReBK933ZdPzKvSNjxI7RwEwRvoM3xvA',
        'isService': false,
      },
      {
        'title': 'مفتاح أسطوانة أوتوماتيكي ذكي',
        'price': '2.00 د.أ',
        'badge': 'عملي',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA5MX03V-XwCQUgLfS3RS5790XmbXM5PPJpZsUB8H_AUzkE8doTKWbiN7WJiTTJHmtiRxmqTSlwla77WoPZKcxTe5CbtwLRjhHFYqfI8O6xShimghJvAINn59nTAOkz9cy1v7CmFo-lE4ki3HGJfaaWSUpF9xQ3qxho46p-T7qJBG6iPjVRKukVAnsddytnxzy2qx2ipSxaFN32XmLJAUtDxyG2xpZNiIA8Wj3m6-AGEGnMT30_Q-64Yg',
        'isService': false,
      },
      {
        'title': 'فحص تسريب وتركيب مع الكابتن',
        'price': '0.00 د.أ',
        'badge': 'خدمة مجانية',
        'imageUrl': '',
        'isService': true,
      },
    ];

    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.handyman_outlined,
                  color: colorSecondary,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  'ملحقات وإكسسوارات الغاز',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductsAndAccessoriesScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'عرض المتجر بالكامل',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: colorSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_back_rounded,
                    size: 14,
                    color: colorSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2x2 Grid
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: accessories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final item = accessories[index];
            final bool isSelected = (_accessoryQuantities[index] ?? 0) > 0;

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorSurfaceLowest,
                borderRadius: BorderRadius.circular(16),
                border: isSelected && item['isService'] == true
                    ? Border.all(color: colorSecondaryContainer, width: 1.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image / Graphic Area
                  Container(
                    height: 94,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        if (item['isService'] == true)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.health_and_safety_rounded,
                                  color: colorSecondary,
                                  size: 38,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'خدمة مجانية',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: colorOnSurface,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item['imageUrl'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.build_circle_outlined,
                                  color: colorSecondary.withValues(alpha: 0.5),
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        // Badge Tag
                        if (item['badge'] != null && item['isService'] != true)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorSurfaceLowest.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['badge'],
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: colorOnSurface,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Item Title
                  Expanded(
                    child: Text(
                      item['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurface,
                        height: 1.25,
                      ),
                    ),
                  ),

                  // Price & Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['price'],
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorSecondary,
                        ),
                      ),
                      if (item['isService'] == true)
                        InkWell(
                          onTap: () => _toggleAccessory(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? colorSecondaryContainer : colorSurfaceHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isSelected ? 'محدد' : 'تحديد',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? colorOnPrimary : colorOnSurface,
                              ),
                            ),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () => _toggleAccessory(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorSurfaceHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: colorOnSurface,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // SECTION 6: PAST ORDERS
  Widget _buildPastOrdersSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: colorSecondary,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  'طلباتك السابقة',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersHistoryScreen(),
                  ),
                );
              },
              child: Text(
                'عرض الكل',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: colorOnSurface,
                  size: 24,
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
                          'طلب #84920',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        Text(
                          ' • 1 أسطوانة',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'تم التسليم قبل 3 أسابيع (خلدا)',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'الإجمالي: 8.50 د.أ',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _gasQuantity = 1;
                  });
                  _showOrderSuccessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSurfaceHigh,
                  foregroundColor: colorOnSurface,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(0, 38),
                ),
                icon: const Icon(Icons.replay, size: 16),
                label: Text(
                  'إعادة الطلب',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SECTION 7: HELP & COMPLAINTS SUPPORT BANNER
  Widget _buildHelpSupportBanner() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HelpComplaintsScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorSurfaceLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorSecondaryContainer.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorSecondaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.support_agent_rounded,
                  color: colorSecondary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.tr(
                      ar: 'مركز المساعدة وبلاغات الجودة 24/7',
                      en: '24/7 Help & Quality Support',
                    ),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLanguage.tr(
                      ar: 'تقديم شكوى، فحص الصمامات، أو التحدث مع المشرف',
                      en: 'File complaints, valve tests, or contact supervisor',
                    ),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              AppLanguage.isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
              size: 18,
              color: colorSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // BOTTOM NAVIGATION BAR
  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: colorSurface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: AppLanguage.tr(ar: 'الرئيسية', en: 'Home'),
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.receipt_long_rounded,
                label: AppLanguage.tr(ar: 'طلباتي', en: 'My Orders'),
                hasBadge: true,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications_rounded,
                label: AppLanguage.tr(ar: 'الإشعارات', en: 'Notifications'),
                hasBadge: true,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_rounded,
                label: AppLanguage.tr(ar: 'حسابي', en: 'Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    bool hasBadge = false,
  }) {
    final bool isSelected = _selectedNavIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        if (index == 1) {
          context.pushPage(const OrdersHistoryScreen());
        } else if (index == 2) {
          context.pushPage(const NotificationsScreen());
        } else if (index == 3) {
          context.pushPage(const UserProfileScreen());
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected ? colorSecondaryContainer : colorOnSurfaceVariant,
                ),
                if (hasBadge)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: colorSecondaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? colorSecondaryContainer : colorOnSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
