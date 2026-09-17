// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_language.dart';

class ProductsAndAccessoriesScreen extends StatefulWidget {
  const ProductsAndAccessoriesScreen({super.key});

  @override
  State<ProductsAndAccessoriesScreen> createState() =>
      _ProductsAndAccessoriesScreenState();
}

class _ProductData {
  final String id;
  final String category;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String priceSubtitleAr;
  final String priceSubtitleEn;
  final String badgeAr;
  final String badgeEn;
  final String imageUrl;
  final String unitTagAr;
  final String unitTagEn;
  final bool hasSpecs;
  final Map<String, String>? specsAr;
  final Map<String, String>? specsEn;

  String get name => AppLanguage.tr(ar: nameAr, en: nameEn);
  String get description => AppLanguage.tr(ar: descriptionAr, en: descriptionEn);
  String get priceSubtitle => AppLanguage.tr(ar: priceSubtitleAr, en: priceSubtitleEn);
  String get badge => AppLanguage.tr(ar: badgeAr, en: badgeEn);
  String get unitTag => AppLanguage.tr(ar: unitTagAr, en: unitTagEn);
  Map<String, String>? get specs => AppLanguage.isArabic ? specsAr : specsEn;

  _ProductData({
    required this.id,
    required this.category,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.priceSubtitleAr,
    required this.priceSubtitleEn,
    required this.badgeAr,
    required this.badgeEn,
    required this.imageUrl,
    required this.unitTagAr,
    required this.unitTagEn,
    this.hasSpecs = false,
    this.specsAr,
    this.specsEn,
  });
}

class _CartItem {
  final _ProductData product;
  int quantity;
  String mode; // e.g. "replacement" or "new"

  _CartItem({
    required this.product,
    required this.quantity,
    this.mode = 'replacement',
  });
}

class _ProductsAndAccessoriesScreenState
    extends State<ProductsAndAccessoriesScreen> {
  // Theme Color Palette
  static const Color colorBackground = Color(0xFFF8F9FF);
  static const Color colorSurface = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceHigh = Color(0xFFDCE9FF);
  static const Color colorSurfaceHighest = Color(0xFFD3E4FE);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);
  static const Color colorPrimaryContainer = Color(0xFF131B2E);
  static const Color colorOnPrimary = Color(0xFFFFFFFF);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorSecondaryFixed = Color(0xFFFFDBCE);

  // Search & Filter State
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Navigation Index
  int _selectedNavIndex = 0;

  // Stepper Counts per Product ID (for the card input before adding)
  final Map<String, int> _itemStepperCounts = {
    'p1': 1,
    'p2': 1,
    'p3': 1,
    'p4': 1,
  };

  // Cylinder Exchange Mode (0: replacement, 1: buy new)
  int _cylinderExchangeMode = 0;

  // Specs Accordion Expanded State
  bool _isSpecsExpanded = false;

  // Cart State (Initialized with the initial cart from HTML)
  late final List<_ProductData> _allProducts;
  final Map<String, _CartItem> _cart = {};

  @override
  void initState() {
    super.initState();
    _allProducts = [
      _ProductData(
        id: 'p1',
        category: 'cylinders',
        nameAr: 'أسطوانة غاز منزلي معبأة (12.5 كغ)',
        nameEn: 'LPG Gas Cylinder 12.5 kg',
        descriptionAr:
            'أسطوانة غاز بترول مسال مخصصة للاستخدام المنزلي والتدفئة والطبخ، فحص الصمام وختم أمان بترول الأردن معتمد.',
        descriptionEn:
            'Household LPG cylinder for cooking and heating, officially sealed and valve-tested to Jordan standards.',
        price: 7.00,
        priceSubtitleAr: '(شامل التوصيل لباب العمارة)',
        priceSubtitleEn: '(Includes doorstep delivery)',
        badgeAr: 'السعر الحكومي الرسمي',
        badgeEn: 'Official Regulated Price',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD61sYO84tZZj3-HblpbP0QtCGNwtXIUx61SSMvlVbvWz1wosP_UL5080Ps2biylblOElwUN2XosqcnjfWp0u2S6YtySLJXPk0P1YR3Kmfz2wxMG-2vc1Sm6X4D106dN0_X-9dHsG4tAVhGpDNqeuwzp4Pd9izo_bz5l5AkpyDTDe8SCuONtoMaJxRUn9hVRzaroQVFiwWZ4jOvfg0KZ5fwR5NNZtBvIfOBKL4ertPtyi9zzi_V4cK3pg',
        unitTagAr: '12.5 كغ',
        unitTagEn: '12.5 kg',
        hasSpecs: true,
        specsAr: {
          'الوزن الصافي للغاز:': '12.5 كغ صافي',
          'نوع الغاز:': 'غاز البترول المسال (LPG)',
          'فحص الصمام:': 'مختومة بحلقة أمان خضراء مرقمة',
          'شروط الاستبدال:': 'تسليم أسطوانة أردنية سليمة بدون تلف',
        },
        specsEn: {
          'Net Gas Weight:': '12.5 kg Net',
          'Gas Type:': 'Liquefied Petroleum Gas (LPG)',
          'Valve Inspection:': 'Numbered green safety seal',
          'Exchange Condition:': 'Undamaged Jordanian steel cylinder',
        },
      ),
      _ProductData(
        id: 'p2',
        category: 'regulators',
        nameAr: 'منظم غاز إيطالي أصلي',
        nameEn: 'Original Italian Gas Regulator',
        descriptionAr:
            'ساعة غاز ضغط منخفض منزلية، مزود بصمام أمان أوتوماتيكي لقطع الغاز فوراً عند حدوث تسريب ومؤشر فحص ضغط دقيق.',
        descriptionEn:
            'Low-pressure household regulator with automatic leak shut-off safety valve and precise pressure gauge.',
        price: 8.50,
        priceSubtitleAr: 'كفالة سنة كاملة',
        priceSubtitleEn: '1-Year Full Warranty',
        badgeAr: 'إيطالي 100%',
        badgeEn: '100% Italian',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD9ao2-tWWvy7VaxDJMoeJGS7-fbmKjgYz4l6JQ2QWLiAvDa_qaa2LY480UQpQ_AWd7vD9Pi2skyN7gQYMcXczw8_eK9rsYJNRnoVTxDo8lkDgNtZeatk0lbVGD8vIb6L6Q3l5ZNlHtbPlXR_hJp_4l5ZABj-gEE4uyuk1DB-QtkyMgItZT8pIVevnhmNdIsMgHE-1Qt7r2x3JSh7I2X05iS-h1kn3Ed2V7d5GRBy6ZphnPLDyKSfvTvQ',
        unitTagAr: 'أمان عالي',
        unitTagEn: 'High Safety',
      ),
      _ProductData(
        id: 'p3',
        category: 'hoses',
        nameAr: 'خرطوم غاز مقوى + 2 مرابط ستانلس',
        nameEn: 'Reinforced Gas Hose + 2 Clamps',
        descriptionAr:
            'بربيش أمان 2 متر مدعم بثلاث طبقات ألياف عازلة للحرارة ومقاوم للضغط، مطابق للمواصفات والمقاييس الأردنية.',
        descriptionEn:
            '2-meter safety hose with 3 heat-resistant reinforcement layers, certified to Jordanian standards.',
        price: 3.50,
        priceSubtitleAr: 'يشمل مرابط الشد',
        priceSubtitleEn: 'Includes stainless clamps',
        badgeAr: 'طول 2 م',
        badgeEn: '2m Length',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDNjiplZz-sxTEmYf3A2hhxICwgZ7H8gqwmW20KVpr_7B0AdNJV1fGsg7J5Fr0DhCJ3Iyz4Ep_NvnGGmaD4lAPqwXFECJ1QHuAmgu_9O3OLoIJDp-klPbyIMpHW1Uc5TMOrN_ZTF21nkUO_Nw8j_7vDDYkzdPw7GYuAx7ZLWhyBQgarryyIpCPdIzsT5xcZz8SStJW3pQC1ZVDTRS-DGT7EbXwN7czGrK_WrdfeCfPADHeAn7QbysMf4A',
        unitTagAr: '2 متر',
        unitTagEn: '2 meters',
      ),
      _ProductData(
        id: 'p4',
        category: 'safety',
        nameAr: 'مانع تسرب ذكي ومقبض حمل سهل',
        nameEn: 'Smart Leak Seal & Carry Handle',
        descriptionAr:
            'طقم حلقات سيليكون مانعة للتسريب تدوم طويلاً، مع مقبض مريح لحمل الأسطوانة ونقلها داخل المنزل بدون جهد.',
        descriptionEn:
            'Long-lasting silicone sealing rings set with ergonomic handle to safely carry and transport cylinders.',
        price: 2.25,
        priceSubtitleAr: '',
        priceSubtitleEn: '',
        badgeAr: 'حماية',
        badgeEn: 'Protection',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDqCwdM3MMc4J8JGEgZfiiIMiWEY8nbmLkiFbUKkt3cmcSBy47XNxAd9K7CLv_X8sP1kTl_0waswqGRWp442Etc5hvzDv0mU36BEutUW1Kd08FW4cBRNl4qG7lWwCmCNC6uNDJH2VLcbRR0x3mlZtleb3DPUdTBoO637gKf-zp38ly9SoDCu5khipoantGO8gYdTfAW_dgGYKoRnT8cPsczGjVOHBkWOsB1ubokE6BMKct7FcuHaJfuNg',
        unitTagAr: 'عملي',
        unitTagEn: 'Practical',
      ),
    ];

    // Initial cart configuration matching HTML demo
    _cart['p1'] = _CartItem(product: _allProducts[0], quantity: 1);
    _cart['p2'] = _CartItem(product: _allProducts[1], quantity: 1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _totalCartCount {
    int sum = 0;
    for (var item in _cart.values) {
      sum += item.quantity;
    }
    return sum;
  }

  double get _totalCartPrice {
    double sum = 0;
    for (var item in _cart.values) {
      sum += (item.product.price * item.quantity);
    }
    return sum;
  }

  String get _cartSummaryText {
    if (_cart.isEmpty) return AppLanguage.tr(ar: AppLanguage.tr(ar: 'السلة فارغة حالياً', en: 'Cart is currently empty'), en: 'Cart is currently empty');
    final List<String> list = [];
    for (var item in _cart.values) {
      if (item.quantity > 0) {
        String shortName = item.product.id == 'p1'
            ? 'أسطوانة غاز'
            : item.product.id == 'p2'
                ? 'ساعة غاز'
                : item.product.id == 'p3'
                    ? 'خرطوم غاز'
                    : 'مانع تسرب';
        list.add('${item.quantity} $shortName');
      }
    }
    return list.join(' + ');
  }

  void _addToCart(_ProductData product) {
    final int qtyToAdd = _itemStepperCounts[product.id] ?? 1;
    setState(() {
      if (_cart.containsKey(product.id)) {
        _cart[product.id]!.quantity += qtyToAdd;
      } else {
        _cart[product.id] = _CartItem(
          product: product,
          quantity: qtyToAdd,
          mode: product.id == 'p1'
              ? (_cylinderExchangeMode == 0 ? 'replacement' : 'new')
              : '',
        );
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              AppLanguage.tr(ar: 'تمت إضافة $qtyToAdd من ${product.name} إلى السلة', en: 'Added $qtyToAdd of ${product.name} to cart'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: colorPrimaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showCheckoutSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: AppLanguage.direction,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
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
                      AppLanguage.tr(ar: 'تفاصيل السلة ومعاينة الطلب', en: 'Cart Details & Order Preview'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorSurfaceHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppLanguage.tr(ar: '$_totalCartCount عناصر', en: '$_totalCartCount items'),
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
                if (_cart.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        AppLanguage.tr(ar: 'السلة فارغة حالياً', en: 'Cart is currently empty'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _cart.values.length,
                      separatorBuilder: (context, i) =>
                          const Divider(height: 16, color: colorSurfaceLow),
                      itemBuilder: (context, i) {
                        final item = _cart.values.elementAt(i);
                        return Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colorSurfaceLow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) => const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: colorOnSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    AppLanguage.tr(ar: '${item.product.price.toStringAsFixed(2)} د.أ × ${item.quantity}', en: '${item.product.price.toStringAsFixed(2)} JOD × ${item.quantity}'),
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 12,
                                      color: colorOnSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setSheetState(() {
                                      setState(() {
                                        if (item.quantity > 1) {
                                          item.quantity--;
                                        } else {
                                          _cart.remove(item.product.id);
                                        }
                                      });
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: colorSecondary,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.quantity}',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    setSheetState(() {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: colorSecondary,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                // Payment summary
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
                            AppLanguage.tr(ar: 'المجموع الفرعي:', en: 'Subtotal:'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 13,
                              color: colorOnSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${_totalCartPrice.toStringAsFixed(2)} ${AppLanguage.tr(ar: 'د.أ', en: 'JOD')}',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colorOnSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'التوصيل لباب المنزل:', en: 'Doorstep Delivery:'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 13,
                              color: colorOnSurfaceVariant,
                            ),
                          ),
                          Text(
                            AppLanguage.tr(ar: 'مجاناً مع الطلب', en: 'Free with order'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16, color: colorSurfaceHigh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'الإجمالي النهائي:', en: 'Final Total:'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colorOnSurface,
                            ),
                          ),
                          Text(
                            '${_totalCartPrice.toStringAsFixed(2)} ${AppLanguage.tr(ar: 'د.أ', en: 'JOD')}',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: colorSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _cart.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context);
                            _showOrderConfirmedDialog();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSecondaryContainer,
                      foregroundColor: colorOnPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLanguage.tr(ar: 'تأكيد الطلب والدفع عند الاستلام', en: 'Confirm Order & Pay on Delivery'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderConfirmedDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: AppLanguage.direction,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: colorSurfaceLowest,
          title: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: colorSecondaryFixed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: colorSecondaryContainer,
                size: 38,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLanguage.tr(ar: 'تم تأكيد طلبك بنجاح!', en: 'Order Placed Successfully!'),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLanguage.tr(ar: 'تم إرسال تفاصيل طلبك للموزع المعتمد في عبدون. سيصلك المندوب خلال 15-25 دقيقة.', en: 'Order details sent to certified distributor. Driver will arrive in 15-25 mins.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  color: colorOnSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSecondaryContainer,
                  foregroundColor: colorOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLanguage.tr(ar: 'حسناً', en: 'OK'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_ProductData> get _filteredProducts {
    return _allProducts.where((p) {
      final matchesCat =
          _selectedCategory == 'all' || p.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();
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
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Top Dispatch & Safety Banner
                          _buildTopDispatchBanner(),
                          const SizedBox(height: 14),

                          // 2. Search & Official Seal Badge
                          _buildSearchAndSealSection(),
                          const SizedBox(height: 14),

                          // 3. Category Filter Horizontal Scroll
                          _buildCategoryFilterRow(),
                          const SizedBox(height: 16),

                          // 4. Products List
                          _buildProductCardsList(),
                          const SizedBox(height: 16),

                          // 5. Trust & Service Micro-Cards
                          _buildTrustCards(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // Sticky Floating Bottom Cart Bar (Fixed above bottom nav)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 12,
                      child: _buildStickyCartTray(),
                    ),
                  ],
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

  // HEADER
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
                    AppLanguage.tr(ar: 'غاز', en: 'GAS'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        'EN',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorOnSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorSurfaceHigh, width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDcymBkUqtK2r72uSV8iVOPBkWf8cUREOvoOxt_quBLnhUZ-3rFNL-r7pO5GWHorxYxoLeezNJKNtNYZdJJXk0w4pCJMrF9fQhKvmu4sP4JykZujpk20e6BzqcRgX2n2mzbCvXtzzrRoFjoHl1hbE_WMzbHqoe1v_oduSg_oS-NuEHFQULOTkJwUgYNYj_VmBqwLW7C70wda6t4MaiTyl-C-RQUk4TSnWiG-cX7ck2o1tazfOC6b4RuTQ',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.person,
                          color: colorOnSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: Location
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
                                  AppLanguage.tr(ar: 'عمان، عبدون الشمالي', en: 'Amman, North Abdoun'),
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
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(0, 32),
                ),
                child: Text(
                  AppLanguage.tr(ar: 'تغيير', en: 'Change'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

  // 1. TOP DISPATCH & SAFETY BANNER
  Widget _buildTopDispatchBanner() {
    return Container(
      width: double.infinity,
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
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 110,
              height: 110,
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
                          AppLanguage.tr(ar: 'شاحنات التوزيع نشطة الآن', en: 'Trucks Active Now'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorSecondaryFixed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLanguage.tr(ar: 'توصيل سريع لعبدون وعمان الغربية', en: 'Fast delivery across Amman & Zarqa'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'زمن الوصول المتوقع', en: 'Estimated Arrival'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        color: colorSurfaceHighest,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLanguage.tr(ar: '15 - 25 دقيقة', en: '15 - 25 mins'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colorSecondaryFixed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. SEARCH & OFFICIAL SEAL BADGE
  Widget _buildSearchAndSealSection() {
    return Column(
      children: [
        // Search Input
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 14,
              color: colorOnSurface,
            ),
            decoration: InputDecoration(
              hintText: AppLanguage.tr(ar: 'ابحث عن أسطوانة، ساعة غاز، خراطيم، صمامات...', en: 'Search cylinders, regulators, hoses...'),
              hintStyle: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                color: colorOnSurfaceVariant.withValues(alpha: 0.7),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: colorOnSurfaceVariant,
                size: 22,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Official Jordan Petroleum Seal Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorSurfaceLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: colorSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        AppLanguage.tr(ar: 'أسعار رسمية معتمدة ومختومة من مصفاة البترول الأردنية', en: 'Official certified prices sealed by Jordan Petroleum Refinery'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: colorOnSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                AppLanguage.tr(ar: '100% آمن ومفحوص', en: '100% Safe & Tested'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colorSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. CATEGORY FILTER HORIZONTAL SCROLL
  Widget _buildCategoryFilterRow() {
    final List<Map<String, dynamic>> categories = [
      {'id': 'all', 'name': AppLanguage.tr(ar: 'الكل', en: 'All'), 'icon': Icons.grid_view_rounded},
      {
        'id': 'cylinders',
        'name': AppLanguage.tr(ar: 'أسطوانات الغاز', en: 'Gas Cylinders'),
        'icon': Icons.propane_tank_rounded
      },
      {'id': 'regulators', 'name': AppLanguage.tr(ar: 'منظمات وساعات', en: 'Regulators & Gauges'), 'icon': Icons.speed_rounded},
      {'id': 'hoses', 'name': AppLanguage.tr(ar: 'خراطيم ومرابط', en: 'Hoses & Clamps'), 'icon': Icons.timeline_rounded},
      {'id': 'safety', 'name': AppLanguage.tr(ar: 'مستلزمات أمان', en: 'Safety Accessories'), 'icon': Icons.shield_rounded},
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (c, i) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final bool isSelected = _selectedCategory == cat['id'];

          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = cat['id'];
              });
            },
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color:
                    isSelected ? colorPrimaryContainer : colorSurfaceLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'],
                    size: 17,
                    color: isSelected ? Colors.white : colorOnSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['name'],
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 4. PRODUCT CARDS LIST
  Widget _buildProductCardsList() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: colorOnSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              AppLanguage.tr(ar: 'لا توجد نتائج مطابقة لبحثك', en: 'No matching products found'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorOnSurface,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: products.map((product) {
        if (product.id == 'p1') {
          return _buildHeroCylinderCard(product);
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildStandardProductCard(product),
          );
        }
      }).toList(),
    );
  }

  // Hero Card for Product 1 (Gas Cylinder with Mode Selector & Specs)
  Widget _buildHeroCylinderCard(_ProductData product) {
    final int count = _itemStepperCounts[product.id] ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Stock Tag & Gov badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      AppLanguage.tr(ar: 'متوفر للتوصيل الفوري الآن في منطقتك', en: 'Available for immediate delivery in your area'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorSecondaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.badge,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colorSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Product Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container with 12.5 kg badge
              Container(
                width: 100,
                height: 116,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.propane_tank,
                          size: 48,
                          color: colorSecondaryContainer,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorPrimaryContainer.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          product.unitTag,
                          style: GoogleFonts.ibmPlexSansArabic(
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
              const SizedBox(width: 12),

              // Title, Desc, Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        color: colorOnSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          product.price.toStringAsFixed(2),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: colorSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLanguage.tr(ar: 'د.أ', en: 'JOD'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            product.priceSubtitle,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11,
                              color: colorOnSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Mode Selector: Replacement vs New Cylinder
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _cylinderExchangeMode = 0;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _cylinderExchangeMode == 0
                            ? colorSurfaceLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _cylinderExchangeMode == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sync_rounded,
                            size: 16,
                            color: _cylinderExchangeMode == 0
                                ? colorSecondary
                                : colorOnSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLanguage.tr(ar: 'استبدال فارغة (+0 د.أ)', en: 'Empty Exchange (+0 JOD)'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
                              fontWeight: _cylinderExchangeMode == 0
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _cylinderExchangeMode == 0
                                  ? colorSecondary
                                  : colorOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _cylinderExchangeMode = 1;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _cylinderExchangeMode == 1
                            ? colorSurfaceLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _cylinderExchangeMode == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 16,
                            color: _cylinderExchangeMode == 1
                                ? colorSecondary
                                : colorOnSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLanguage.tr(ar: 'شراء أسطوانة جديدة', en: 'Buy New Cylinder'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
                              fontWeight: _cylinderExchangeMode == 1
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _cylinderExchangeMode == 1
                                  ? colorSecondary
                                  : colorOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Interactive Specs Accordion
          Container(
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSpecsExpanded = !_isSpecsExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: colorSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              AppLanguage.tr(ar: 'المواصفات الفنية وضمان الأمان', en: 'Technical Specs & Safety Guarantee'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colorOnSurface,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          _isSpecsExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: colorOnSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isSpecsExpanded && product.specs != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      children: product.specs!.entries.map((entry) {
                        return Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorSurfaceLowest.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11,
                                  color: colorOnSurfaceVariant,
                                ),
                              ),
                              Text(
                                entry.value,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colorOnSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quantity Stepper & Add Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stepper
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildStepperBtn(
                      icon: Icons.remove,
                      enabled: count > 1,
                      onTap: () {
                        if (count > 1) {
                          setState(() {
                            _itemStepperCounts[product.id] = count - 1;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          '$count',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                      ),
                    ),
                    _buildStepperBtn(
                      icon: Icons.add,
                      enabled: count < 10,
                      onTap: () {
                        if (count < 10) {
                          setState(() {
                            _itemStepperCounts[product.id] = count + 1;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Add to Cart CTA
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => _addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSecondary,
                      foregroundColor: colorOnPrimary,
                      elevation: 2,
                      shadowColor: colorSecondary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: Text(
                      AppLanguage.tr(ar: 'أضف للطلب', en: 'Add to Cart'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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

  // Standard Product Card (Italian Regulator, Hose, Safety)
  Widget _buildStandardProductCard(_ProductData product) {
    final int count = _itemStepperCounts[product.id] ?? 1;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              Container(
                width: 86,
                height: 86,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.build_circle_outlined,
                          size: 36,
                          color: colorSecondary,
                        ),
                      ),
                    ),
                    if (product.badge.isNotEmpty)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorSurfaceLowest.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.badge,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colorOnSurface,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Title, Desc, Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          product.price.toStringAsFixed(2),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 18,
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
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        if (product.priceSubtitle.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            product.priceSubtitle,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colorSecondaryContainer,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Stepper & Add Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                      enabled: count > 1,
                      onTap: () {
                        if (count > 1) {
                          setState(() {
                            _itemStepperCounts[product.id] = count - 1;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 28,
                      child: Center(
                        child: Text(
                          '$count',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                      ),
                    ),
                    _buildStepperBtn(
                      icon: Icons.add,
                      enabled: count < 10,
                      onTap: () {
                        if (count < 10) {
                          setState(() {
                            _itemStepperCounts[product.id] = count + 1;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _addToCart(product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSurfaceHigh,
                  foregroundColor: colorOnSurface,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(0, 38),
                ),
                icon: const Icon(Icons.add_shopping_cart, size: 16),
                label: Text(
                  AppLanguage.tr(ar: 'أضف للطلب', en: 'Add to Cart'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
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

  Widget _buildStepperBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Material(
      color: enabled ? colorSurfaceLowest : colorSurfaceLowest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
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

  // 5. TRUST & SERVICE MICRO-CARDS
  Widget _buildTrustCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  color: colorSecondary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'الدفع عند الاستلام', en: 'Cash on Delivery'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'نقداً أو عبر CliQ', en: 'Cash or CliQ'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.handyman_outlined,
                  color: colorSecondary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'تركيب وفحص مجاني', en: 'Free Installation'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'بواسطة الموزع المعتمد', en: 'By Certified Driver'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // STICKY FLOATING BOTTOM CART TRAY
  Widget _buildStickyCartTray() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorPrimaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorPrimaryContainer.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colorSecondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    if (_totalCartCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: colorSecondaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$_totalCartCount',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: colorSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _cartSummaryText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorSurfaceHighest,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'المجموع: ', en: 'Total: '),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11,
                              color: colorSurfaceHighest,
                            ),
                          ),
                          Text(
                            '${_totalCartPrice.toStringAsFixed(2)} ${AppLanguage.tr(ar: 'د.أ', en: 'JOD')}',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: colorSecondaryFixed,
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
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _showCheckoutSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSecondaryContainer,
              foregroundColor: colorOnPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(0, 42),
            ),
            icon: Text(
              AppLanguage.tr(ar: 'معاينة الطلب', en: 'View Cart'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            label: const Icon(Icons.arrow_back, size: 16),
          ),
        ],
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
                label: AppLanguage.tr(ar: 'طلباتي', en: 'Orders'),
                hasBadge: true,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications_rounded,
                label: AppLanguage.tr(ar: 'الإشعارات', en: 'Alerts'),
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
                  color: isSelected
                      ? colorSecondaryContainer
                      : colorOnSurfaceVariant,
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
                color: isSelected
                    ? colorSecondaryContainer
                    : colorOnSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
