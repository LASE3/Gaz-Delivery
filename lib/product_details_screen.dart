// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'app_language.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cart_and_checkout.dart';
import 'login_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productName;
  final double basePrice;

  const ProductDetailsScreen({
    super.key,
    this.productName,
    this.basePrice = 7.00,
  });

  String get effectiveProductName =>
      productName ??
      AppLanguage.tr(
        ar: 'أسطوانة غاز منزلي معبأة (12.5 كغ)',
        en: 'Domestic LPG Gas Cylinder (12.5 kg)',
      );

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
  static const Color colorOnSecondaryFixed = Color(0xFF370E00);
  static const Color colorOnSecondaryFixedVariant = Color(0xFF7F2B00);
  static const Color colorOnTertiaryContainer = Color(0xFF188ACE);

  // State Variables
  int _quantity = 1;
  String _serviceType = 'exchange'; // 'exchange' (+0) or 'buy_new' (+45)
  bool _isFavorite = false;
  bool _isSubmitting = false;

  // Selected Add-ons Map
  final Map<String, bool> _selectedAddons = {
    'regulator': false, // 5.50 JD
    'hose': false, // 3.00 JD
    'wrench': false, // 2.00 JD
  };

  final Map<String, double> _addonPrices = {
    'regulator': 5.50,
    'hose': 3.00,
    'wrench': 2.00,
  };

  double get _serviceTypeExtra => _serviceType == 'buy_new' ? 45.00 : 0.00;

  double get _addonsTotal {
    double sum = 0;
    _selectedAddons.forEach((key, isSelected) {
      if (isSelected) {
        sum += _addonPrices[key] ?? 0;
      }
    });
    return sum;
  }

  double get _totalPrice {
    return ((widget.basePrice + _serviceTypeExtra) * _quantity) + _addonsTotal;
  }

  void _changeQuantity(int delta) {
    final newQty = _quantity + delta;
    if (newQty >= 1 && newQty <= 5) {
      setState(() {
        _quantity = newQty;
      });
    }
  }

  void _toggleAddon(String key) {
    setState(() {
      _selectedAddons[key] = !(_selectedAddons[key] ?? false);
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? AppLanguage.tr(
                  ar: 'تمت إضافة المنتج إلى المفضلة',
                  en: 'Added product to favorites',
                )
              : AppLanguage.tr(
                  ar: 'تمت إزالة المنتج من المفضلة',
                  en: 'Removed product from favorites',
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
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLanguage.tr(ar: 'تم نسخ رابط المنتج بنجاح لمشاركته', en: 'Product link copied to clipboard'),
          style: GoogleFonts.ibmPlexSansArabic(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        backgroundColor: colorPrimaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitOrder() {
    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CartAndCheckoutScreen(),
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
        // Header
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
                  AppLanguage.tr(ar: 'تفاصيل المنتج', en: 'Product Details'),
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Action Strip (Cert tag, Fav & Share buttons)
              _buildTopActionStrip(),
              const SizedBox(height: 12),

              // 2. Hero Visual Frame with Official Badges
              _buildHeroVisualFrame(),
              const SizedBox(height: 16),

              // 3. Product Title & Subtitle
              _buildProductTitle(),
              const SizedBox(height: 14),

              // 4. Official Price Card (EMRC Regulated)
              _buildPriceCard(),
              const SizedBox(height: 18),

              // 5. Cylinder Exchange Options (Refill vs Buy New)
              _buildExchangeOptions(),
              const SizedBox(height: 18),

              // 6. Key Specs & Safety Guarantee Card
              _buildSpecsAndGuarantees(),
              const SizedBox(height: 16),

              // 7. Safety Instructions Banner
              _buildSafetyInstructions(),
              const SizedBox(height: 18),

              // 8. Recommended Add-ons Section
              _buildRecommendedAddons(),
              const SizedBox(height: 14),

              // 9. Delivery Information Pill
              _buildDeliveryInfoPill(),
            ],
          ),
        ),
        // Sticky Bottom Checkout Bar
        bottomNavigationBar: _buildStickyBottomBar(),
      ),
    );
      },
    );
  }

  // 1. TOP ACTION STRIP
  Widget _buildTopActionStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colorSurfaceHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 15,
                color: colorSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                AppLanguage.tr(ar: 'معتمد رسمياً • مصفاة البترول الأردنية', en: 'Officially Certified • Jordan Petroleum Refinery'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: _toggleFavorite,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 18,
                  color: _isFavorite ? colorSecondaryContainer : colorOnSurface,
                ),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: _handleShare,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_rounded,
                  size: 18,
                  color: colorOnSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. HERO VISUAL FRAME
  Widget _buildHeroVisualFrame() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuB0alH7OWmHdx1b0yaRWo-w8H8U1ls27iOOFbmH7lDdm9zZz734G1USRPoSOJz5R-OD8LTuhMhcGL1KXsnmGykICBDyLp4vne_4xznzue0hpoB6jQo7Yfj2rmQ0M73A4p81VvqbfRAlWI0s6pY3ZunHpP7Lu_sDFsDaQrfdzCWvW2rOPfXQUtxOFIqZwiAnJ5g5RTtF9S1KDOSvSHxq-lt00XBMV60mBJynO97OAPCsUheBnDDFNibwNg',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                color: colorSurfaceLow,
                child: const Center(
                  child: Icon(
                    Icons.propane_tank_rounded,
                    size: 80,
                    color: colorSecondaryContainer,
                  ),
                ),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorPrimaryContainer.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Regulatory Badges at Bottom of Image
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colorSurfaceLowest.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
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
                          AppLanguage.tr(ar: 'ختم حراري مشفر رقمياً', en: 'Digitally Encrypted Heat Seal'),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colorPrimaryContainer.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLanguage.tr(ar: 'فحص أمان 100%', en: '100% Safety Inspected'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      ),
    );
  }

  // 3. PRODUCT TITLE
  Widget _buildProductTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.effectiveProductName,
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: colorOnSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLanguage.tr(ar: 'غاز بترولي مسال نقي (LPG) مطابق للمواصفات القياسية الأردنية', en: 'Pure Liquefied Petroleum Gas (LPG) compliant with Jordan Standards'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 12,
            color: colorOnSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // 4. PRICE CARD (EMRC Regulated)
  Widget _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '7.00',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: colorSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLanguage.tr(ar: 'د.أ', en: 'JOD'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLanguage.tr(ar: '/ للأسطوانة', en: '/ cylinder'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.gavel_rounded,
                        size: 13,
                        color: colorOnTertiaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLanguage.tr(ar: 'سعر حكومي رسمي محدد من هيئة تنظيم الطاقة (EMRC)', en: 'Official price set by Energy Commission (EMRC)'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colorOnTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'أجرة التوصيل', en: 'Delivery Fee'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                    Text(
                      AppLanguage.tr(ar: '1.50 د.أ', en: '1.50 JOD'),
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.door_front_door_outlined,
                  size: 16,
                  color: colorSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLanguage.tr(ar: 'يشمل التوصيل الصعود بالدرج والتركيب عند باب الشقة مجاناً.', en: 'Includes stair delivery and doorstep installation free.'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
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

  // 5. CYLINDER EXCHANGE OPTIONS
  Widget _buildExchangeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLanguage.tr(ar: 'نوع الخدمة', en: 'Service Type'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colorOnSurface,
              ),
            ),
            Text(
              AppLanguage.tr(ar: 'يرجى الاختيار بدقة', en: 'Please select carefully'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 11,
                color: colorOnSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Option 1: Refill / Exchange
        InkWell(
          onTap: () {
            setState(() {
              _serviceType = 'exchange';
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _serviceType == 'exchange'
                  ? colorSurfaceLow
                  : colorSurfaceLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _serviceType == 'exchange'
                    ? colorSecondaryContainer
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _serviceType == 'exchange'
                          ? colorSecondary
                          : colorOnSurfaceVariant,
                      width: 2,
                    ),
                  ),
                  child: _serviceType == 'exchange'
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: colorSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'استبدال أسطوانة فارغة بأسطوانة معبأة', en: 'Exchange empty cylinder for filled one'),
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
                              color: colorSecondaryFixed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLanguage.tr(ar: 'الأكثر طلباً', en: 'Most Popular'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: colorOnSecondaryFixed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLanguage.tr(ar: 'يتم تسليم الأسطوانة الفارغة للكابتن عند الاستلام بنفس الحالة الجيدة', en: 'Hand over empty cylinder to driver in good condition'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppLanguage.tr(ar: '+0.00 د.أ', en: '+0.00 JOD'),
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
        const SizedBox(height: 8),

        // Option 2: Buy New Cylinder
        InkWell(
          onTap: () {
            setState(() {
              _serviceType = 'buy_new';
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _serviceType == 'buy_new'
                  ? colorSurfaceLow
                  : colorSurfaceLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _serviceType == 'buy_new'
                    ? colorSecondaryContainer
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _serviceType == 'buy_new'
                          ? colorSecondary
                          : colorOnSurfaceVariant,
                      width: 2,
                    ),
                  ),
                  child: _serviceType == 'buy_new'
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: colorSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'شراء أسطوانة حديد جديدة مع الغاز', en: 'Buy new steel cylinder with gas'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLanguage.tr(ar: 'أسطوانة جديدة مختومة وغير مستعملة مع ملكية كاملة', en: 'New sealed unused cylinder with full ownership'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppLanguage.tr(ar: '+45.00 د.أ', en: '+45.00 JOD'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 6. KEY SPECS & SAFETY GUARANTEES
  Widget _buildSpecsAndGuarantees() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLanguage.tr(ar: 'المواصفات وضمانات الأمان', en: 'Specs & Safety Guarantees'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colorOnSurface,
          ),
        ),
        const SizedBox(height: 10),
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
              // Weight Grid
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.scale_rounded,
                              size: 22, color: colorSecondary),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLanguage.tr(ar: 'الوزن الصافي للغاز', en: 'Net Gas Weight'),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10,
                                  color: colorOnSurfaceVariant,
                                ),
                              ),
                              Text(
                                AppLanguage.tr(ar: '12.5 كغم LPG', en: '12.5 kg LPG'),
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
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center_rounded,
                              size: 22, color: colorSecondary),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLanguage.tr(ar: 'الوزن الإجمالي', en: 'Total Weight'),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10,
                                  color: colorOnSurfaceVariant,
                                ),
                              ),
                              Text(
                                AppLanguage.tr(ar: '~ 27 كغم', en: '~ 27 kg'),
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Checklist
              _buildGuaranteeCheckItem(
                icon: Icons.done_all_rounded,
                title: AppLanguage.tr(ar: 'فحص رغوة الصمام مجاناً:', en: 'Free Foam Leak Inspection:'),
                subtitle:
                    AppLanguage.tr(ar: 'يقوم الكابتن باختبار تسريب الغاز بالرغوة والتأكد من إحكام الشد قبل المغادرة.', en: 'Driver conducts foam bubble test to ensure no gas leaks before departure.'),
              ),
              const SizedBox(height: 8),
              _buildGuaranteeCheckItem(
                icon: Icons.lock_outline_rounded,
                title: AppLanguage.tr(ar: 'ختم الأمان الحراري:', en: 'Tamper-Evident Heat Seal:'),
                subtitle:
                    AppLanguage.tr(ar: 'غطاء بلاستيكي منكمش بالحرارة برقم تسلسلي موثق لمنع العبث وضمان المنشأ.', en: 'Serialized heat-shrunk cap ensuring origin and preventing tampering.'),
              ),
              const SizedBox(height: 8),
              _buildGuaranteeCheckItem(
                icon: Icons.verified_user_rounded,
                title: AppLanguage.tr(ar: 'فحص صلاحية الصمام ومفتاح الغاز:', en: 'Valve Safety Certification:'),
                subtitle:
                    AppLanguage.tr(ar: 'أسطوانات خاضعة لإعادة التأهيل الدوري وضغط الهيدروستاتيك.', en: 'All cylinders undergo hydrostatic pressure safety verification.'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuaranteeCheckItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: colorSurfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: colorOnTertiaryContainer),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 11,
                color: colorOnSurfaceVariant,
                height: 1.35,
              ),
              children: [
                TextSpan(
                  text: '$title ',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontWeight: FontWeight.bold,
                    color: colorOnSurface,
                  ),
                ),
                TextSpan(text: subtitle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 7. SAFETY INSTRUCTIONS BANNER
  Widget _buildSafetyInstructions() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSecondaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 26,
            color: colorSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLanguage.tr(ar: 'تنبيهات السلامة المنزلية', en: 'Home Safety Alerts'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorOnSecondaryFixed,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLanguage.tr(ar: 'تأكد من تركيب الأسطوانة بوضعية عمودية، في مكان جيد التهوية بعيداً عن مصادر اللهب المباشر والكهرباء. تجنب فحص التسريب بالقداحة أو أعواد الثقاب نهائياً.', en: 'Keep cylinder upright in well-ventilated area away from direct flame or electricity. Never test leaks with lighters or matches.'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    color: colorOnSecondaryFixedVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 8. RECOMMENDED ADD-ONS
  Widget _buildRecommendedAddons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLanguage.tr(ar: 'ملحقات الأمان الموصى بها', en: 'Recommended Safety Accessories'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colorOnSurface,
                  ),
                ),
                Text(
                  AppLanguage.tr(ar: 'تركيب وفحص فوري مع نفس الطلب', en: 'Instant installation & testing with same order'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    color: colorOnSurfaceVariant,
                  ),
                ),
              ],
            ),
            Text(
              AppLanguage.tr(ar: 'إضافات موثوقة', en: 'Trusted Add-ons'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colorSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              // Add-on 1: Italian Regulator
              _buildAddonCard(
                keyId: 'regulator',
                title: AppLanguage.tr(ar: 'ساعة غاز إيطالي أصلية (منظم)', en: 'Italian Gas Regulator (Original)'),
                subtitle:
                    AppLanguage.tr(ar: 'منظم ضغط منزلي عالي الكفاءة مع صمام أمان تلقائي ضد التسريب.', en: 'High-efficiency regulator with automatic leak shutoff valve.'),
                price: 5.50,
                badge: AppLanguage.tr(ar: 'صنع إيطاليا', en: 'Made in Italy'),
                image:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCLoxgYEE_bad2MJxt6_KGMFb3tDNMkpKur6S-nYID_kiYUZTB5vf_qJDUfJmrrbusnn-xNIyMvruWqlKlUW-L8Emq7N0s8kXZtZQIYof_FyztmKTDQMUo1BAZ5AETmH3gPwnXBQHDWjTHP3ZikqF4DUfxcV88GE_ehjTFXGpxo9d-tng5lT-SSEGrWFj2uxYSH3GJWXALaMpICkh2CtC8S5ryX2dP4wJTzSDxh533-08hA-5A3wyC67A',
              ),
              const SizedBox(width: 10),

              // Add-on 2: Safety Hose
              _buildAddonCard(
                keyId: 'hose',
                title: AppLanguage.tr(ar: 'خرطوم أمان مقوى (2 متر) + مرابط', en: 'Reinforced Safety Hose (2m) + Clamps'),
                subtitle:
                    AppLanguage.tr(ar: 'مطاط مقوى بثلاث طبقات مع 2 مرابط ستانلس ستيل أصلية مقاومة للحرارة.', en: '3-layer reinforced rubber with 2 stainless steel heat-resistant clamps.'),
                price: 3.00,
                badge: AppLanguage.tr(ar: 'مقاوم للتلف', en: 'Durable'),
                image:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCxD5Tt6bLmqqBGpnxjXap7tABpEgHQ6Hi3J5gw_MQUb9CExRyfDr6EaXvAGSrVGUc9b4L2mv6Zy_Julso3In-q4mtP423OE8lJzuOd2Hg4kqjHtYCOSqYBkEqi_sDcG1ff_JtYbFN9gWBItVysD_3LjXJb-iVZ5WY34DLGtZafpXrI8pOgmqG-U_PR_iKjAVSQy30fRZRlsso8HRub4aa0kHhFfcNJJSATqMwfQdwPR1iX7qa0yrrLxA',
              ),
              const SizedBox(width: 10),

              // Add-on 3: Magnetic Wrench
              _buildAddonCard(
                keyId: 'wrench',
                title: AppLanguage.tr(ar: 'مفتاح غاز ذكي مغناطيسي', en: 'Smart Magnetic Gas Wrench'),
                subtitle:
                    AppLanguage.tr(ar: 'مقبض هندسي مريح مصمم لإحكام صمام الأسطوانة دون إتلاف العزقة.', en: 'Ergonomic handle designed to tighten cylinder valve safely.'),
                price: 2.00,
                badge: AppLanguage.tr(ar: 'مريح وسهل', en: 'Ergonomic'),
                image:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCCDpmyXproovbjVVLQWI-k6-iqKYAsMZPLsyrTlf7yN1PYUjhkSALbOhX66vSNGEU3anu8oDHIbSF3wyj0KdP7D5rEXPaR6L0l5tP_OjXlVI1LA-j-MbFBLnrbQDKdWQVc6ZhwUQot02rEgs_3pu7Hku4dIbbAzLpbd3uMsJhElptDZPAzqcDBfCN6MV_BTI0oI3wlTWn60ymAoB8U_nr4F-m2DBUz02C1esv7isdLDZxyreQ5ZduL5A',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddonCard({
    required String keyId,
    required String title,
    required String subtitle,
    required double price,
    required String badge,
    required String image,
  }) {
    final bool isAdded = _selectedAddons[keyId] == true;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.build_rounded,
                          size: 32,
                          color: colorSecondary,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorPrimaryContainer.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 9,
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
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 10,
                  color: colorOnSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLanguage.tr(ar: '${price.toStringAsFixed(2)} د.أ', en: '${price.toStringAsFixed(2)} JOD'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              InkWell(
                onTap: () => _toggleAddon(keyId),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isAdded ? colorSecondary : colorSurfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAdded ? Icons.check : Icons.add,
                        size: 13,
                        color: isAdded ? Colors.white : colorOnSurface,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        isAdded ? AppLanguage.tr(ar: 'تم', en: 'Added') : AppLanguage.tr(ar: 'إضافة', en: 'Add'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isAdded ? Colors.white : colorOnSurface,
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
    );
  }

  // 9. DELIVERY INFO PILL
  Widget _buildDeliveryInfoPill() {
    return Container(
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorSurfaceHighest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  size: 18,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.tr(ar: 'توصيل سريع خلال 20 - 35 دقيقة', en: 'Fast Delivery in 20 - 35 mins'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  Text(
                    AppLanguage.tr(ar: 'أقرب سيارة غاز متواجدة في منطقتك الآن', en: 'Nearest gas truck is in your neighborhood now'),
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
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: colorSecondaryContainer,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  // 10. STICKY BOTTOM CHECKOUT BAR
  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest.withValues(alpha: 0.98),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stepper & Price Breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity Stepper
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colorSurfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _changeQuantity(-1),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: colorSurfaceLowest,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.remove,
                              size: 16, color: colorOnSurface),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          _quantity.toString(),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _changeQuantity(1),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: colorSurfaceLowest,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add,
                              size: 16, color: colorOnSurface),
                        ),
                      ),
                    ],
                  ),
                ),

                // Total Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'المجموع الإجمالي', en: 'Total Amount'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _totalPrice.toStringAsFixed(2),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: colorSecondary,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          AppLanguage.tr(ar: 'د.أ', en: 'JOD'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Primary Add To Cart Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSecondaryContainer,
                  foregroundColor: colorOnPrimary,
                  elevation: 2,
                  shadowColor: colorSecondaryContainer.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppLanguage.tr(ar: 'إضافة إلى الطلب والمتابعة', en: 'Add to Cart & Proceed'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 4),

            // Cash on delivery note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 14,
                  color: colorSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  AppLanguage.tr(ar: 'الدفع نقداً عند الاستلام فقط (كاش) بعد التركيب والفحص', en: 'Cash on delivery only after installation and inspection'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 10,
                    color: colorOnSurfaceVariant,
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
