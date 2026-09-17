// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'delivery_location.dart';
import 'app_language.dart';

class CartAndCheckoutScreen extends StatefulWidget {
  const CartAndCheckoutScreen({super.key});

  @override
  State<CartAndCheckoutScreen> createState() => _CartAndCheckoutScreenState();
}

class _CheckoutItem {
  final String id;
  final String name;
  final String? nameEn;
  final String badge;
  final String? badgeEn;
  final IconData? badgeIcon;
  final double unitPrice;
  final String imageUrl;
  int quantity;

  _CheckoutItem({
    required this.id,
    required this.name,
    this.nameEn,
    required this.badge,
    this.badgeEn,
    this.badgeIcon,
    required this.unitPrice,
    required this.imageUrl,
    required this.quantity,
  });

  String get displayName => AppLanguage.isArabic ? name : (nameEn ?? name);
  String get displayBadge => AppLanguage.isArabic ? badge : (badgeEn ?? badge);
}

class _CartAndCheckoutScreenState extends State<CartAndCheckoutScreen> {
  // Color Tokens matching design system
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
  static const Color colorTertiaryContainer = Color(0xFF001D31);
  static const Color colorOnTertiary = Color(0xFFFFFFFF);
  static const Color colorOnTertiaryContainer = Color(0xFF188ACE);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorSecondaryFixed = Color(0xFFFFDBCE);
  static const Color colorErrorContainer = Color(0xFFFFDAD6);
  static const Color colorOnErrorContainer = Color(0xFF93000A);

  // Address State
  String? _customDeliveryAddress;
  String get _deliveryAddress =>
      _customDeliveryAddress ??
      AppLanguage.tr(
        ar: 'تلاع العلي، شارع وصفي التل (الجاردنز)، بناء 42، طابق 3، شقة 6',
        en: 'Tlaa Al-Ali, Wasfi Al-Tal St. (Gardens), Bldg 42, Floor 3, Apt 6',
      );
  set _deliveryAddress(String val) => _customDeliveryAddress = val;

  // Driver Notes Controller
  late final TextEditingController _notesController;

  // Cart Items
  late final List<_CheckoutItem> _cartItems;
  final double _deliveryFee = 1.50;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: AppLanguage.tr(
        ar: 'المصعد يعمل، يرجى قرع الجرس وتفقد مفتاح الأمان.',
        en: 'Elevator works, please ring the bell and check safety valve.',
      ),
    );

    _cartItems = [
      _CheckoutItem(
        id: 'p1',
        name: 'أسطوانة غاز منزلي معبأة (12.5 كغ)',
        nameEn: 'Domestic LPG Gas Cylinder (12.5 kg)',
        badge: 'استبدال فارغة (0 د.أ)',
        badgeEn: 'Empty Exchange (0 JOD)',
        unitPrice: 7.00,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAXDWqWIkSCKsMSuSmawOwkITzMw95vZx6RD_CeQPWtBqyyF1A6ZRwcnTfQcBgzLPN8lB5kPkhDeJGt2j0D9XFO15UWka9_YDXLyETCAW7b4ptLUeSn-H_Prv_mLi8Dgp6uypbq1ycaBfqyvpSyuBCjo4njhOyk-eHlPApbAjzc_VyYQ7g-wC0HPlbgyIpydhe32ITZty0zQlIvHpoaIL56sSwnc_Ae6g1ax8_iF_8HEMlm5cBESnICUw',
        quantity: 1,
      ),
      _CheckoutItem(
        id: 'p2',
        name: 'منظم غاز إيطالي أصلي (ساعة غاز)',
        nameEn: 'Original Italian Gas Regulator',
        badge: 'كفالة سنة',
        badgeEn: '1-Year Warranty',
        badgeIcon: Icons.verified_rounded,
        unitPrice: 8.50,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuChn9Gjss_SNeR7sKGNvAuLnaJ9EHPX1edGI6wuIFEAFi-lmTnbUUEJbXKj9COi5usV7k6CFXoUB_o_B0T1yXCI2uct--p7G3AiMWiRFAmfcZ-sx6zEZn-2LT_1PbfT5dIJCmI2oaY1ASWK4nXpY3HN6vYqd1w857wuilO-rMXOCFmRJKUASrefzJ2cX7D9g8wyJW79qSfMsxsX_xwHOl9DPTbW9ooYGASpYKnEBFmjJpLslS9l-jYNUg',
        quantity: 1,
      ),
    ];
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _itemsSubtotal {
    double sum = 0;
    for (var item in _cartItems) {
      sum += (item.unitPrice * item.quantity);
    }
    return sum;
  }

  double get _grandTotal {
    if (_cartItems.isEmpty) return 0.0;
    return _itemsSubtotal + _deliveryFee;
  }

  int get _totalItemsCount {
    int sum = 0;
    for (var item in _cartItems) {
      sum += item.quantity;
    }
    return sum;
  }

  Future<void> _showChangeAddressDialog() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const DeliveryLocationScreen(),
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        _deliveryAddress = result;
      });
    }
  }

  void _showOrderSuccessDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: AppLanguage.direction,
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
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: colorSecondaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: colorSecondaryContainer,
                  size: 46,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLanguage.tr(ar: 'تم تأكيد وإرسال طلبك بنجاح!', en: 'Order Placed Successfully!'),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLanguage.tr(ar: 'تم استلام طلبك بإجمالي ${_grandTotal.toStringAsFixed(2)} د.أ.\nشاحنة التوزيع في الطريق إلى تلاع العلي (وصول خلال 25-35 دقيقة).\nيرجى تجهيز المبلغ نقداً للكابتن.', en: 'Your order was received for ${_grandTotal.toStringAsFixed(2)} JOD.\nDelivery truck on its way (arrival in 25-35 mins).\nPlease prepare exact cash.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
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
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLanguage.tr(ar: 'العودة للرئيسية', en: 'Back to Home'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Delivery Address Summary Card
                          _buildAddressSummaryCard(),
                          const SizedBox(height: 14),

                          // 2. Safety Inspection Delight Banner
                          _buildSafetyBanner(),
                          const SizedBox(height: 20),

                          // 3. Order Items List
                          _buildOrderItemsSection(),
                          const SizedBox(height: 20),

                          // 4. Driver Notes Section
                          _buildDriverNotesSection(),
                          const SizedBox(height: 20),

                          // 5. Payment Method Section (Cash Only Policy)
                          _buildPaymentMethodSection(),
                          const SizedBox(height: 20),

                          // 6. Pricing Breakdown Card
                          _buildPricingSummaryCard(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // Sticky Bottom Checkout Bar
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildStickyBottomCheckoutBar(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  // HEADER WIDGET
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
              ),
              const SizedBox(width: 4),
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
              Text(
                AppLanguage.tr(ar: 'إتمام الطلب', en: 'Checkout'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
            ],
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
    );
  }

  // 1. DELIVERY ADDRESS SUMMARY CARD
  Widget _buildAddressSummaryCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: colorSecondaryContainer,
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLanguage.tr(ar: 'عنوان التوصيل المعتمد', en: 'Verified Delivery Address'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _showChangeAddressDialog,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colorSurfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit_location_alt_outlined,
                        size: 15,
                        color: colorOnSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLanguage.tr(ar: 'تغيير العنوان', en: 'Change'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _deliveryAddress,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              height: 1.45,
              color: colorOnSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: colorTertiaryContainer,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                AppLanguage.tr(ar: 'وقت التوصيل التقديري: 25 - 35 دقيقة', en: 'Estimated Delivery: 25 - 35 mins'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. SAFETY INSPECTION HIGHLIGHT BANNER
  Widget _buildSafetyBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorTertiaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorTertiaryContainer.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorOnTertiaryContainer.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: colorOnTertiaryContainer,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLanguage.tr(ar: 'سلامتك أولويتنا القصوى', en: 'Your Safety is Priority'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorOnTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLanguage.tr(ar: 'خدمة الفحص المجاني لتهريب الغاز بجهاز كشف التسريب عند التركيب مشمولة دائماً.', en: 'Free leak detection test during installation is always included.'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    height: 1.35,
                    color: colorSurfaceHighest,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. ORDER ITEMS LIST SECTION
  Widget _buildOrderItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLanguage.tr(ar: 'عناصر الطلب', en: 'Order Items'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colorSurfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppLanguage.tr(ar: '$_totalItemsCount عناصر في السلة', en: '$_totalItemsCount items in cart'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_cartItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorSurfaceLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                AppLanguage.tr(ar: 'لا توجد عناصر في السلة حالياً', en: 'Cart is empty'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 14,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Column(
            children: _cartItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorSurfaceLow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.propane_tank,
                                size: 28,
                                color: colorSecondaryContainer,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.displayName,
                                      style: GoogleFonts.ibmPlexSansArabic(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: colorOnSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _cartItems.removeWhere(
                                            (element) => element.id == item.id);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: colorOnSurfaceVariant,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    tooltip: AppLanguage.tr(ar: 'حذف المنتج', en: 'Remove Item'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.id == 'p1'
                                      ? colorSecondaryFixed
                                      : colorSurfaceHigh,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item.badgeIcon != null) ...[
                                      Icon(
                                        item.badgeIcon,
                                        size: 13,
                                        color: colorOnSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Text(
                                      item.displayBadge,
                                      style: GoogleFonts.ibmPlexSansArabic(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: item.id == 'p1'
                                            ? colorSecondary
                                            : colorOnSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Stepper
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: colorSurfaceLow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              _buildStepperBtn(
                                icon: Icons.remove,
                                enabled: item.quantity > 1,
                                onTap: () {
                                  if (item.quantity > 1) {
                                    setState(() {
                                      item.quantity--;
                                    });
                                  }
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '${item.quantity}',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: colorOnSurface,
                                  ),
                                ),
                              ),
                              _buildStepperBtn(
                                icon: Icons.add,
                                enabled: item.quantity < 10,
                                onTap: () {
                                  if (item.quantity < 10) {
                                    setState(() {
                                      item.quantity++;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              (item.unitPrice * item.quantity)
                                  .toStringAsFixed(2),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: colorOnSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLanguage.tr(ar: 'د.أ', en: 'JOD'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colorOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
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
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? colorOnSurface
                : colorOnSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  // 4. DRIVER NOTES SECTION
  Widget _buildDriverNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLanguage.tr(ar: 'ملاحظات إضافية للكابتن', en: 'Driver Instructions'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorOnSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 2,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurface,
            ),
            decoration: InputDecoration(
              hintText: AppLanguage.tr(ar: 'أضف تفاصيل إضافية عن البناية أو طريقة الدخول...', en: 'Add building or entry directions...'),
              hintStyle: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12,
                color: colorOnSurfaceVariant.withValues(alpha: 0.6),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // 5. PAYMENT METHOD SECTION (CASH ONLY POLICY)
  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLanguage.tr(ar: 'طريقة الدفع', en: 'Payment Method'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colorErrorContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 13,
                    color: colorOnErrorContainer,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppLanguage.tr(ar: 'نقد فقط', en: 'Cash Only'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colorOnErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
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
              // Payment row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: colorSecondaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.payments_rounded,
                          color: colorSecondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'الدفع نقداً عند الاستلام', en: 'Cash on Delivery (COD)'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorOnSurface,
                            ),
                          ),
                          Text(
                            'Cash on Delivery',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11,
                              color: colorOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: colorSecondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Ministry Notice
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: colorSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLanguage.tr(ar: 'السعر رسمي ومحدد بموجب تسعيرة وزارة الطاقة والثروة المعدنية الأردنية. يُرجى تجهيز المبلغ المطلوب نقداً لتسليمه للكابتن.', en: 'Official price regulated by Jordan Ministry of Energy. Please prepare the cash amount for the driver.'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Warning Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.credit_card_off_rounded,
                      size: 15,
                      color: colorOnSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLanguage.tr(ar: 'لا تتوفر وسيلة دفع إلكتروني - نقد فقط', en: 'Electronic payments unavailable - Cash only'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        fontWeight: FontWeight.w500,
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

  // 6. PRICING SUMMARY CARD
  Widget _buildPricingSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              AppLanguage.tr(ar: 'ملخص الفاتورة', en: 'Invoice Summary'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildPriceRow(
                  label: AppLanguage.tr(ar: 'مجموع المنتجات', en: 'Items Total'),
                  value: AppLanguage.tr(ar: '${_itemsSubtotal.toStringAsFixed(2)} د.أ', en: '${_itemsSubtotal.toStringAsFixed(2)} JOD'),
                ),
                const SizedBox(height: 8),
                _buildPriceRow(
                  label: AppLanguage.tr(ar: 'رسوم التوصيل المعتمدة (تلاع العلي)', en: 'Official Delivery Fee (Tlaa Al-Ali)'),
                  value: AppLanguage.tr(ar: '${_deliveryFee.toStringAsFixed(2)} د.أ', en: '${_deliveryFee.toStringAsFixed(2)} JOD'),
                ),
                const SizedBox(height: 8),
                _buildPriceRow(
                  label: AppLanguage.tr(ar: 'ضريبة ورسوم خدمات', en: 'Tax & Service Fees'),
                  badge: AppLanguage.tr(ar: '(معفى حكومياً)', en: '(Gov. Exempt)'),
                  value: AppLanguage.tr(ar: '0.00 د.أ', en: '0.00 JOD'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Grand Total Accent Bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'المجموع الإجمالي المطلوب', en: 'Total Amount'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorPrimaryContainer,
                      ),
                    ),
                    Text(
                      AppLanguage.tr(ar: 'شامل التوصيل والتركيب والفحص', en: 'Includes delivery, install & test'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
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
                      _grandTotal.toStringAsFixed(2),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: colorSecondaryContainer,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLanguage.tr(ar: 'د.أ', en: 'JOD'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorPrimaryContainer,
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

  Widget _buildPriceRow({
    required String label,
    required String value,
    String? badge,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                color: colorOnSurfaceVariant,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Text(
                badge,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorSecondary,
                ),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: colorOnSurface,
          ),
        ),
      ],
    );
  }

  // STICKY BOTTOM CHECKOUT BAR
  Widget _buildStickyBottomCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest.withValues(alpha: 0.96),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: _cartItems.isEmpty ? null : _showOrderSuccessDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSecondaryContainer,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: colorSecondaryContainer.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_checkout_rounded,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLanguage.tr(ar: 'تأكيد وإرسال الطلب (${_grandTotal.toStringAsFixed(2)} د.أ)', en: 'Place Order (${_grandTotal.toStringAsFixed(2)} JOD)'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_back_rounded,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
