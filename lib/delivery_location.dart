// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_and_checkout.dart';

class DeliveryLocationScreen extends StatefulWidget {
  final String? initialStreet;
  final String? initialBuilding;
  final String? initialFloor;
  final String? initialApartment;
  final String? initialCity;

  const DeliveryLocationScreen({
    super.key,
    this.initialStreet,
    this.initialBuilding,
    this.initialFloor,
    this.initialApartment,
    this.initialCity,
  });

  @override
  State<DeliveryLocationScreen> createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen> {
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

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorSecondaryFixed = Color(0xFFFFDBCE);
  static const Color colorOutline = Color(0xFF76777D);

  // Form State
  String _selectedCity = 'amman'; // 'amman' or 'zarqa'
  int _selectedAddressType = 0; // 0: Home, 1: Work, 2: Family, 3: Other

  late final TextEditingController _streetController;
  late final TextEditingController _buildingController;
  late final TextEditingController _floorController;
  late final TextEditingController _apartmentController;
  late final TextEditingController _driverNotesController;

  String _currentAreaName = 'تلاع العلي - قرب دوار الواحة';

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity ?? 'amman';
    _streetController = TextEditingController(
      text: widget.initialStreet ??
          'شارع وصفي التل (الجاردنز) - خلف مجمع جبر',
    );
    _buildingController = TextEditingController(
      text: widget.initialBuilding ?? 'بناء 42',
    );
    _floorController = TextEditingController(
      text: widget.initialFloor ?? 'الطابق 3',
    );
    _apartmentController = TextEditingController(
      text: widget.initialApartment ?? 'شقة 6',
    );
    _driverNotesController = TextEditingController(
      text: 'المصعد يعمل، يرجى قرع الجرس وتفقد مفتاح الأمان للأسطوانة...',
    );
  }

  @override
  void dispose() {
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _driverNotesController.dispose();
    super.dispose();
  }

  void _onGpsPressed() {
    setState(() {
      _currentAreaName = 'عبدون الشمالي - قرب السفارة';
      _streetController.text = 'شارع دمشق - عبدون الشمالي';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تحديد موقعك الحالي عبر الـ GPS بنجاح',
          style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        backgroundColor: colorPrimaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _onConfirmLocation() {
    final String fullAddress =
        '${_selectedCity == 'amman' ? 'عمّان' : 'الزرقاء'}، ${_streetController.text.trim()}، ${_buildingController.text.trim()}، ${_floorController.text.trim()}، ${_apartmentController.text.trim()}';

    // If popped from another screen expecting result
    if (Navigator.canPop(context)) {
      Navigator.pop(context, fullAddress);
    } else {
      // Or push to Cart & Checkout flow
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CartAndCheckoutScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Interactive Map Card with Coverage Status
                      _buildMapLocationCard(),
                      const SizedBox(height: 16),

                      // 2. City Selector Segment
                      _buildCitySelector(),
                      const SizedBox(height: 16),

                      // 3. Building & Apartment Details Form Card
                      _buildBuildingDetailsCard(),
                      const SizedBox(height: 16),

                      // 4. Cash on Delivery Assurance Banner
                      _buildPaymentAssuranceBanner(),
                      const SizedBox(height: 16),

                      // 5. Confirm Location & Proceed CTA
                      _buildConfirmButton(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: colorOnSurface,
                  size: 24,
                ),
                tooltip: 'رجوع',
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
                'تحديد موقع التوصيل',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
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

  // 1. MAP LOCATION CARD
  Widget _buildMapLocationCard() {
    return Container(
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Map Canvas Box
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 280,
              width: double.infinity,
              child: Stack(
                children: [
                  // Map Background Image
                  Positioned.fill(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDrML-v5u59KYRQqp3KBrJ5dahWaa7J0NWqK7BkvK-vdLi1RRkyxeoZYSTJV92qW7rUh86yHYq07DqMxRKTzfqKgTtw7OiWo3ZKLNE_nEBO6lqheY3Xo0xTmz1CbQnitZ_aoTBYoo3tdl8VBKmUDsmwaEekzkcON75zp6ZhG8KnjdFYNwYFvhW47qR20_ogpqaaf-9PIyffTW6RyBmsoNiu-FbyAeltHS92CjnfbtKdwi1pSqfNVfP_tw',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: colorSurfaceHigh,
                        child: const Center(
                          child: Icon(Icons.map_rounded, size: 64, color: colorSurfaceHighest),
                        ),
                      ),
                    ),
                  ),

                  // Subtle Ambient Overlay
                  Positioned.fill(
                    child: Container(
                      color: colorPrimaryContainer.withValues(alpha: 0.12),
                    ),
                  ),

                  // Top Coverage Status Pill & Layers button
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
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
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'نطاق التغطية الفورية نشط',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colorOnSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: colorSurfaceLowest.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.layers_rounded,
                            size: 20,
                            color: colorOnSurface,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center Pin & Bouncing Tooltip
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorPrimaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: colorPrimaryContainer.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'سيتم التوصيل إلى هنا',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: colorSecondaryContainer,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.location_on,
                          color: colorSecondary,
                          size: 46,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bottom Controls: Current Area & GPS Button
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorSurfaceLowest.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            _currentAreaName,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colorOnSurfaceVariant,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _onGpsPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorSurfaceLowest,
                            foregroundColor: colorPrimaryContainer,
                            elevation: 3,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.my_location_rounded,
                            color: colorSecondaryContainer,
                            size: 18,
                          ),
                          label: Text(
                            'موقعي الحالي',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Coverage Banner
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: colorSecondaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: colorSecondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خدمة التوصيل متاحة في منطقتك',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        Text(
                          'عمّان - تلاع العلي (متوسط الوصول: 18 - 25 دقيقة)',
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
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. CITY SELECTOR
  Widget _buildCitySelector() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر المحافظة / المدينة',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCity = 'amman';
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedCity == 'amman'
                            ? colorSurfaceLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedCity == 'amman'
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        'عمّان (العاصمة)',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: _selectedCity == 'amman'
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: _selectedCity == 'amman'
                              ? colorOnSurface
                              : colorOnSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCity = 'zarqa';
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedCity == 'zarqa'
                            ? colorSurfaceLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedCity == 'zarqa'
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        'الزرقاء والرصيفة',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: _selectedCity == 'zarqa'
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: _selectedCity == 'zarqa'
                              ? colorOnSurface
                              : colorOnSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. BUILDING & APARTMENT DETAILS FORM CARD
  Widget _buildBuildingDetailsCard() {
    final List<Map<String, dynamic>> addressTypes = [
      {'icon': Icons.home_rounded, 'label': 'المنزل'},
      {'icon': Icons.apartment_rounded, 'label': 'العمل'},
      {'icon': Icons.cottage_rounded, 'label': 'بيت العائلة'},
      {'icon': Icons.location_on_rounded, 'label': 'أخرى'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pin_drop_rounded,
                color: colorSecondary,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                'تفاصيل البناء والشقة',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Street & Landmark
          Text(
            'اسم الشارع أو المعلم القريب',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.signpost_outlined,
                  size: 20,
                  color: colorOutline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _streetController,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      color: colorOnSurface,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3 Column Row: Building, Floor, Apartment
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم العمارة',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _buildingController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorOnSurface,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الطابق',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _floorController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorOnSurface,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم الشقة',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _apartmentController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorOnSurface,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Address Type Segment
          Text(
            'تصنيف العنوان',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(addressTypes.length, (index) {
              final item = addressTypes[index];
              final bool isSelected = _selectedAddressType == index;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: index != addressTypes.length - 1 ? 6 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedAddressType = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? colorSecondaryFixed : colorSurfaceLow,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: colorSecondaryContainer, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            item['icon'],
                            size: 20,
                            color: isSelected ? colorSecondary : colorOnSurfaceVariant,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['label'],
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? colorSecondary : colorOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Driver Notes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ملاحظات دقيقة لكابتن الغاز',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorOnSurfaceVariant,
                ),
              ),
              Text(
                'مهم لسلامة الوصول',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  size: 22,
                  color: colorOutline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _driverNotesController,
                    maxLines: 2,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      color: colorOnSurface,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'المصعد يعمل، يرجى قرع الجرس وتفقد مفتاح الأمان للأسطوانة...',
                      hintStyle: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOutline,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. CASH ON DELIVERY ASSURANCE BANNER
  Widget _buildPaymentAssuranceBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorPrimaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.payments_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الدفع نقداً عند استلام الأسطوانة',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  Text(
                    'السعر الرسمي محدد من وزارة الطاقة الأردنية',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.verified_rounded,
            color: colorSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  // 5. CONFIRM LOCATION BUTTON
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _onConfirmLocation,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorSecondaryContainer,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: colorSecondaryContainer.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تأكيد الموقع ومتابعة الطلب',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_back_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
