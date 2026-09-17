// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_language.dart';
import 'home_screen.dart';
import 'orders_history_screen.dart';
import 'delivery_location.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'help_complaints_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Theme Color Tokens
  static const Color colorSurface = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceContainer = Color(0xFFE5EEFF);
  static const Color colorSurfaceHigh = Color(0xFFDCE9FF);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);
  static const Color colorOutline = Color(0xFF76777D);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorSecondaryFixed = Color(0xFFFFDBCE);

  static const Color colorError = Color(0xFFBA1A1A);
  static const Color colorErrorContainer = Color(0xFFFFDAD6);
  static const Color colorOnErrorContainer = Color(0xFF93000A);

  // Profile State
  String _userName = 'محمد القضاة';
  String get _displayUserName =>
      _userName == 'محمد القضاة'
          ? AppLanguage.tr(ar: 'محمد القضاة', en: 'Mohammad Al-Qudah')
          : _userName;
  String _userPhone = '+962 7 9123 4567';
  String _userEmail = 'm.qudah@example.com';
  String get _displayCity => AppLanguage.tr(ar: 'عمان', en: 'Amman');
  String _selectedValveType = 'quick';
  String get _displayValveType => _selectedValveType == 'quick'
      ? AppLanguage.tr(ar: 'سريع (كبس أزرق)', en: 'Quick Click-on')
      : AppLanguage.tr(ar: 'لولبي (سن يدوي)', en: 'Screw-on Thread');

  String _selectedPaymentMethod = 'cod';
  String get _displayPaymentMethod {
    if (_selectedPaymentMethod == 'cod') {
      return AppLanguage.tr(ar: 'نقدًا عند الاستلام', en: 'Cash on Delivery');
    } else if (_selectedPaymentMethod == 'cliq') {
      return AppLanguage.tr(ar: 'دفع فوري عبر كليك CliQ', en: 'Instant via CliQ');
    } else {
      return AppLanguage.tr(ar: 'بطاقة بنكية إلكترونية', en: 'Credit/Debit Card');
    }
  }

  String _getAddressTitle(Map<String, dynamic> addr) {
    if (addr['id'] == '1') return AppLanguage.tr(ar: 'المنزل', en: 'Home');
    if (addr['id'] == '2') return AppLanguage.tr(ar: 'مكتب العمل', en: 'Work Office');
    return addr['title']?.toString() ?? '';
  }

  String _getAddressText(Map<String, dynamic> addr) {
    if (addr['id'] == '1') {
      return AppLanguage.tr(
        ar: 'عمان، تلاع العلي، شارع وصفي التل، عمارة 42، طابق 3، شقة 6',
        en: 'Amman, Tlaa Al-Ali, Wasfi Al-Tal St, Bldg 42, Floor 3, Apt 6',
      );
    }
    if (addr['id'] == '2') {
      return AppLanguage.tr(
        ar: 'عمان، الدوار السابع، مجمع جوهرة عمان، طابق 2',
        en: 'Amman, 7th Circle, Jawharat Amman Complex, Floor 2',
      );
    }
    return addr['address']?.toString() ?? '';
  }

  String? _getAddressLandmark(Map<String, dynamic> addr) {
    if (addr['id'] == '1') return AppLanguage.tr(ar: 'قرب حلويات حبيبة', en: 'Near Habiba Sweets');
    if (addr['id'] == '2') return AppLanguage.tr(ar: 'بجانب بنك الإسكان', en: 'Next to Housing Bank');
    return addr['landmark']?.toString();
  }

  // Settings State
  bool _notificationsEnabled = true;
  // Selected language tracked via AppLanguage

  // Saved Addresses State
  final List<Map<String, dynamic>> _savedAddresses = [
    {
      'id': '1',
      'title': 'المنزل',
      'isDefault': true,
      'address': 'عمان، تلاع العلي، شارع وصفي التل، عمارة 42، طابق 3، شقة 6',
      'hasElevator': true,
      'landmark': 'قرب حلويات حبيبة',
      'icon': Icons.home_rounded,
    },
    {
      'id': '2',
      'title': 'مكتب العمل',
      'isDefault': false,
      'address': 'عمان، الدوار السابع، مجمع جوهرة عمان، طابق 2',
      'hasElevator': true,
      'landmark': 'بجانب بنك الإسكان',
      'icon': Icons.apartment_rounded,
    },
  ];

  // Bottom Navigation Index: 3 = 'حسابي'
  int _navIndex = 3;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, langCode, child) {
        return Directionality(
          textDirection: AppLanguage.direction,
          child: Scaffold(
            backgroundColor: colorSurface,
            appBar: _buildTopAppBar(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileHeaderCard(),
                  const SizedBox(height: 16),
                  _buildQuickUtilityStrip(),
                  const SizedBox(height: 20),
                  _buildSavedAddressesSection(),
                  const SizedBox(height: 20),
                  _buildAccountSettingsSection(),
                  const SizedBox(height: 20),
                  _buildEmergencyHotlineCard(),
                  const SizedBox(height: 24),
                  _buildLogoutAndVersion(),
                  const SizedBox(height: 80), // Padding for bottom nav
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNav(),
          ),
        );
      },
    );
  }

  // ==========================================
  // TOP APP BAR
  // ==========================================
  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: colorSurface.withValues(alpha: 0.85),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                color: colorSecondaryContainer,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLanguage.tr(ar: 'الملف الشخصي', en: 'User Profile'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              Text(
                'User Profile & Settings',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: colorOnSurface,
                  size: 22,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
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
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ==========================================
  // PROFILE HEADER CARD
  // ==========================================
  Widget _buildProfileHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxInsets.boxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          // Background subtle warm glow effects
          Positioned(
            top: -24,
            left: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSecondaryFixed.withValues(alpha: 0.45),
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSurfaceHigh.withValues(alpha: 0.5),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with verified badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorSecondaryContainer.withValues(alpha: 0.3),
                              width: 2.5,
                            ),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF131B2E), Color(0xFF2C3E50)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 42,
                              color: Color(0xFFBEC6E0),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: colorSecondaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Name, City, Phone, Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _displayUserName,
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: colorOnSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: colorSurfaceHigh,
                                  borderRadius: BorderRadius.circular(12),
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
                                    const SizedBox(width: 4),
                                    Text(
                                      _displayCity,
                                      style: GoogleFonts.ibmPlexSansArabic(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF3F465C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              _userPhone,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colorOnSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userEmail,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: colorOutline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Verified Security Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorSurfaceLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorSurfaceContainer,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 20,
                        color: colorSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLanguage.tr(
                            ar: 'عميل معتمد وموثق بالهوية ومعايير الأمان الأردنية',
                            en: 'Verified under Jordan Safety Standards',
                          ),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorOnSurface,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Edit Profile Button
                InkWell(
                  onTap: () => _showEditProfileDialog(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 19,
                          color: colorOnSurface,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLanguage.tr(ar: 'تعديل الملف الشخصي', en: 'Edit Profile'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurface,
                          ),
                        ),
                      ],
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

  // ==========================================
  // QUICK UTILITY STRIP (VALVE & PAYMENT)
  // ==========================================
  Widget _buildQuickUtilityStrip() {
    return Row(
      children: [
        // Valve Type Card
        Expanded(
          child: InkWell(
            onTap: () => _showValveSelectorModal(),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colorSurfaceLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorSecondaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.propane_tank_rounded,
                        color: colorSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLanguage.tr(ar: 'نوع الصمام', en: 'Valve Type'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _displayValveType,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurface,
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
          ),
        ),
        const SizedBox(width: 12),

        // Payment Method Card
        Expanded(
          child: InkWell(
            onTap: () => _showPaymentMethodSelectorModal(),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colorSurfaceLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.payments_outlined,
                        color: colorOnSurface,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLanguage.tr(ar: 'طريقة الدفع', en: 'Payment Method'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _displayPaymentMethod,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurface,
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
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SECTION 1: SAVED ADDRESSES
  // ==========================================
  Widget _buildSavedAddressesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: colorSecondary,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLanguage.tr(ar: 'العناوين المحفوظة', en: 'Saved Addresses'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colorSurfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                AppLanguage.tr(ar: '${_savedAddresses.length} عناوين', en: '${_savedAddresses.length} Addresses'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Address Cards List
        ..._savedAddresses.map((addr) => _buildAddressCard(addr)),

        const SizedBox(height: 6),

        // Add Address Action Button
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DeliveryLocationScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorSecondaryContainer.withValues(alpha: 0.3),
                style: BorderStyle.solid,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_location_alt_rounded,
                  size: 20,
                  color: colorSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLanguage.tr(ar: '+ إضافة عنوان جديد', en: '+ Add New Address'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

  Widget _buildAddressCard(Map<String, dynamic> addr) {
    final bool isDefault = addr['isDefault'] == true;
    final String id = addr['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: isDefault
            ? Border.all(
                color: colorSecondaryContainer.withValues(alpha: 0.4),
                width: 1.5,
              )
            : Border.all(color: colorSurfaceContainer, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDefault
                ? colorSecondaryContainer.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDefault ? colorSecondaryFixed : colorSurfaceHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        addr['icon'] as IconData? ?? Icons.location_city_rounded,
                        size: 17,
                        color: isDefault ? colorSecondary : colorOnSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getAddressTitle(addr),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorSecondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        AppLanguage.tr(ar: 'افتراضي', en: 'Default'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showEditAddressModal(addr),
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: colorOnSurfaceVariant,
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: AppLanguage.tr(ar: 'تعديل العنوان', en: 'Edit Address'),
                  ),
                  IconButton(
                    onPressed: () => _deleteAddress(id),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: colorError,
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: AppLanguage.tr(ar: 'حذف العنوان', en: 'Delete Address'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              _getAddressText(addr),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: isDefault ? colorOnSurface : colorOnSurfaceVariant,
              ),
            ),
          ),
          if (addr['hasElevator'] == true || _getAddressLandmark(addr) != null) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  if (addr['hasElevator'] == true)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.elevator_outlined,
                          size: 16,
                          color: colorSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLanguage.tr(ar: 'يوجد مصعد كهربائي', en: 'Elevator available'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  if (_getAddressLandmark(addr) != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.explore_outlined,
                          size: 16,
                          color: colorSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getAddressLandmark(addr) ?? '',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 2: ACCOUNT & SERVICE SETTINGS
  // ==========================================
  Widget _buildAccountSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.tune_rounded,
              color: colorSecondary,
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(
              AppLanguage.tr(ar: 'إعدادات الحساب والخدمة', en: 'Account & Service Settings'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Past orders & Invoices
              _buildSettingsRow(
                icon: Icons.receipt_long_rounded,
                title: AppLanguage.tr(ar: 'سجل الطلبات والفواتير السابقة', en: 'Order History & Invoices'),
                subtitle: AppLanguage.tr(ar: 'تاريخ التوصيل والإيصالات الضريبية', en: 'Delivery dates & tax receipts'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colorSurfaceHigh,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        AppLanguage.tr(ar: AppLanguage.tr(ar: '14 طلب ناجح', en: '14 orders completed'), en: '14 orders completed'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      AppLanguage.chevronForward,
                      color: colorOutline,
                      size: 20,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersHistoryScreen(),
                    ),
                  );
                },
              ),
              _buildDivider(),

              // Help Center & Support
              _buildSettingsRow(
                icon: Icons.support_agent_rounded,
                title: AppLanguage.tr(ar: 'مركز المساعدة وبلاغات الدعم الفني', en: 'Help Center & Support'),
                subtitle: AppLanguage.tr(ar: 'خدمة العملاء وحل الشكاوى على مدار الساعة', en: '24/7 customer service & complaints'),
                trailing: Icon(
                  AppLanguage.chevronForward,
                  color: colorOutline,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpComplaintsScreen(),
                    ),
                  );
                },
              ),
              _buildDivider(),

              // Language Selector Toggle
              _buildSettingsRow(
                icon: Icons.translate_rounded,
                title: AppLanguage.tr(ar: 'لغة التطبيق', en: 'App Language'),
                subtitle: AppLanguage.tr(ar: 'تفضيلات اللغة والاتجاه', en: 'Language & Direction'),
                onTap: () {
                  AppLanguage.toggleLanguage();
                },
                trailing: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colorSurfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLangPill(
                        code: 'ar',
                        label: 'العربية',
                        isSelected: AppLanguage.isArabic,
                      ),
                      _buildLangPill(
                        code: 'en',
                        label: 'English',
                        isSelected: !AppLanguage.isArabic,
                      ),
                    ],
                  ),
                ),
              ),
              _buildDivider(),

              // Delivery Notifications Toggle Switch
              _buildSettingsRow(
                icon: Icons.notifications_active_outlined,
                title: AppLanguage.tr(ar: 'إشعارات التوصيل ووصول الكابتن', en: 'Delivery & Driver Notifications'),
                subtitle: AppLanguage.tr(ar: 'تحديث فوري لمركبة التوزيع واقترابها', en: 'Real-time vehicle arrival updates'),
                trailing: Switch.adaptive(
                  value: _notificationsEnabled,
                  activeTrackColor: colorSecondaryContainer,
                  activeThumbColor: Colors.white,
                  onChanged: (val) {
                    setState(() {
                      _notificationsEnabled = val;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                      val
                          ? AppLanguage.tr(
                              ar: 'تم تفعيل إشعارات اقتراب شاحنة الغاز',
                              en: 'Truck approach notifications enabled',
                            )
                          : AppLanguage.tr(
                              ar: 'تم تعطيل إشعارات التوصيل',
                              en: 'Delivery notifications disabled',
                            ),
                      style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    ),
                    behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF131B2E),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              _buildDivider(),

              // EMRC Licences & Legal
              _buildSettingsRow(
                icon: Icons.policy_outlined,
                title: AppLanguage.tr(ar: 'الشروط وتراخيص هيئة الطاقة EMRC', en: 'EMRC Terms & Energy Licenses'),
                subtitle: AppLanguage.tr(ar: 'سياسة الخصوصية ومعايير النقل المعتمدة', en: 'Privacy policy & certified transport standards'),
                trailing: Icon(
                  AppLanguage.chevronForward,
                  color: colorOutline,
                  size: 20,
                ),
                onTap: () => _showEmrcLicenceModal(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorSurfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(icon, size: 20, color: colorOnSurface),
              ),
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
                      fontWeight: FontWeight.w600,
                      color: colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colorOutline,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildLangPill({
    required String code,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        AppLanguage.setLanguage(code);
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? colorSurfaceLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? colorSecondaryContainer : colorOnSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: colorSurfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // ==========================================
  // SECTION 3: SAFETY & EMERGENCY HOTLINE
  // ==========================================
  Widget _buildEmergencyHotlineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorErrorContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorError.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emergency_rounded,
                size: 24,
                color: colorOnErrorContainer,
              ),
              const SizedBox(width: 8),
              Text(
                AppLanguage.tr(ar: 'طوارئ الغاز والدفاع المدني', en: 'Gas Emergency & Civil Defense'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorOnErrorContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLanguage.tr(ar: 'في حال الاشتباه بأي تسرب للغاز أو حالة طوارئ منزلية، يرجى إخلاء المكان فورا والاتصال بفرق السلامة دون تردد:', en: 'In case of suspected gas leak or emergency, evacuate immediately and contact safety services:'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: colorOnErrorContainer,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // 911 Hotline
              Expanded(
                child: InkWell(
                  onTap: () => _confirmEmergencyCall(
                    number: '911',
                    title: AppLanguage.tr(ar: 'الدفاع المدني والأمن العام (911)', en: 'Civil Defense & Public Security (911)'),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorSurfaceLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.call_rounded,
                          size: 18,
                          color: colorError,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLanguage.tr(ar: 'طوارئ 911', en: 'Emergency 911'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colorError,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Unified Gas Hotline
              Expanded(
                child: InkWell(
                  onTap: () => _confirmEmergencyCall(
                    number: '065000000',
                    title: AppLanguage.tr(ar: 'مركز الغاز الموحد للطوارئ', en: 'Unified Gas Emergency Center'),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorSurfaceLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone_in_talk_rounded,
                          size: 18,
                          color: colorSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLanguage.tr(ar: 'مركز الغاز الموحد', en: 'Unified Gas Center'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurface,
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
    );
  }

  // ==========================================
  // LOGOUT & APP VERSION METADATA
  // ==========================================
  Widget _buildLogoutAndVersion() {
    return Column(
      children: [
        InkWell(
          onTap: () => _showLogoutConfirmDialog(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: colorError,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLanguage.tr(ar: 'تسجيل الخروج', en: 'Log Out'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorError,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppLanguage.tr(ar: 'إصدار التطبيق v2.4.0', en: 'App Version v2.4.0'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorOnSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          AppLanguage.tr(ar: 'غاز الأردن المعتمد (خدمات العاصمة عمان ومحافظة الزرقاء)', en: 'Jordan Gas Certified (Amman & Zarqa Services)'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: colorOutline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: colorSurface.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: colorSurfaceContainer,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.local_gas_station_rounded,
                label: AppLanguage.tr(ar: 'الرئيسية', en: 'Home'),
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.inventory_2_outlined,
                label: AppLanguage.tr(ar: 'طلباتي', en: 'Orders'),
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications_none_rounded,
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
    final bool isSelected = _navIndex == index;

    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OrdersHistoryScreen(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        } else if (index == 3) {
          // Already on profile
          setState(() {
            _navIndex = 3;
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? colorSecondaryContainer
                      : colorOnSurfaceVariant,
                ),
                if (hasBadge && !isSelected)
                  Positioned(
                    top: -1,
                    right: -1,
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

  // ==========================================
  // MODALS & DIALOGS
  // ==========================================

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _userName);
    final phoneCtrl = TextEditingController(text: _userPhone);
    final emailCtrl = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: colorSurfaceLowest,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorSurfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppLanguage.tr(ar: 'تعديل الملف الشخصي', en: 'Edit Profile'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr(ar: 'الاسم الكامل', en: 'Full Name'),
                    labelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    filled: true,
                    fillColor: colorSurfaceLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr(ar: 'رقم الهاتف', en: 'Phone Number'),
                    labelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    filled: true,
                    fillColor: colorSurfaceLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr(ar: 'البريد الإلكتروني', en: 'Email Address'),
                    labelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    filled: true,
                    fillColor: colorSurfaceLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppLanguage.tr(ar: 'إلغاء', en: 'Cancel'),
                style: GoogleFonts.ibmPlexSansArabic(
                  color: colorOnSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName = nameCtrl.text.trim();
                  _userPhone = phoneCtrl.text.trim();
                  _userEmail = emailCtrl.text.trim();
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLanguage.tr(ar: 'تم تحديث البيانات بنجاح', en: 'Profile updated successfully'),
                      style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    ),
                    backgroundColor: const Color(0xFF131B2E),
                    behavior: SnackBarBehavior.floating,
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
              child: Text(
                AppLanguage.tr(ar: 'حفظ التغييرات', en: 'Save Changes'),
                style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showValveSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorSurfaceHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLanguage.tr(ar: 'اختر نوع صمام أسطوانة الغاز', en: 'Select Gas Valve Type'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLanguage.tr(ar: 'تأكد من اختيار الصمام المطابق لمنظم الغاز في منزلك لتفادي مشاكل التركيب', en: 'Ensure valve matches home regulator to avoid installation issues'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                title: AppLanguage.tr(ar: 'سريع (كبس أزرق) - Modern Click-on', en: 'Quick Click (Blue Modern) - Click-on'),
                desc: AppLanguage.tr(ar: 'المنظم الحديث بالضغط الأزرق المعتمد في معظم المنازل', en: 'Modern blue snap-on regulator standard in most homes'),
                isSelected: _selectedValveType == 'quick',
                onTap: () {
                  setState(() => _selectedValveType = 'quick');
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                title: AppLanguage.tr(ar: 'لولبي تقليدي (سن ناعم) - Screw-on', en: 'Traditional Screw-on (Manual Thread)'),
                desc: AppLanguage.tr(ar: 'الصمام المعدني القديم بالربط الميكانيكي اليدوي', en: 'Classic manual mechanical threaded valve'),
                isSelected: _selectedValveType == 'screw',
                onTap: () {
                  setState(() => _selectedValveType = 'screw');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentMethodSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorSurfaceHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLanguage.tr(ar: 'طريقة الدفع الافتراضية', en: 'Default Payment Method'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                title: AppLanguage.tr(ar: 'نقدًا عند الاستلام (COD)', en: 'Cash on Delivery (COD)'),
                desc: AppLanguage.tr(ar: 'الدفع المباشر لكابتن التوزيع بعد الفحص والاستلام', en: 'Direct payment to driver after inspection'),
                isSelected: _selectedPaymentMethod == 'cod',
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'cod');
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                title: AppLanguage.tr(ar: 'كليك (CliQ) - تحويل فوري', en: 'CliQ - Instant Mobile Transfer'),
                desc: AppLanguage.tr(ar: 'دفع مباشر عبر الاسم المستعار لكابتن التوصيل', en: 'Direct payment via driver Alias / IBAN'),
                isSelected: _selectedPaymentMethod == 'cliq',
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'cliq');
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                title: AppLanguage.tr(ar: 'بطاقة فيزا / ماستركارد', en: 'Visa / MasterCard'),
                desc: AppLanguage.tr(ar: 'دفع إلكتروني آمن مشفر 100%', en: '100% secure encrypted payment'),
                isSelected: _selectedPaymentMethod == 'card',
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'card');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String desc,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? colorSecondaryFixed.withValues(alpha: 0.3) : colorSurfaceLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colorSecondaryContainer : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? colorSecondaryContainer : colorOutline,
              size: 20,
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
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
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
    );
  }

  void _showEditAddressModal(Map<String, dynamic> addr) {
    final titleCtrl = TextEditingController(text: _getAddressTitle(addr));
    final addressCtrl = TextEditingController(text: _getAddressText(addr));
    final landmarkCtrl = TextEditingController(text: _getAddressLandmark(addr) ?? '');
    bool hasElevator = addr['hasElevator'] == true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Directionality(
          textDirection: AppLanguage.direction,
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            decoration: const BoxDecoration(
              color: colorSurfaceLowest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLanguage.tr(ar: 'تعديل تفاصيل العنوان', en: 'Edit Address Details'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr(ar: 'اسم العنوان (مثال: المنزل، الشاليه)', en: 'Address Name (e.g. Home, Office)'),
                    labelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    filled: true,
                    fillColor: colorSurfaceLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr(ar: 'العنوان بالتفصيل', en: 'Detailed Address'),
                    labelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    filled: true,
                    fillColor: colorSurfaceLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: landmarkCtrl,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr(ar: 'علامة مميزة (اختياري)', en: 'Nearby Landmark (Optional)'),
                    labelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    filled: true,
                    fillColor: colorSurfaceLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  value: hasElevator,
                  activeColor: colorSecondaryContainer,
                  title: Text(
                    AppLanguage.tr(ar: 'يتوفر مصعد في المبنى', en: 'Elevator Available in Building'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    AppLanguage.tr(ar: 'يساعد كابتن التوصيل في التجهيز المسبق لحمل الأسطوانات', en: 'Helps driver prepare for cylinder carrying'),
                    style: GoogleFonts.ibmPlexSansArabic(fontSize: 11),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (val) {
                    setSheetState(() => hasElevator = val ?? false);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      addr['title'] = titleCtrl.text.trim();
                      addr['address'] = addressCtrl.text.trim();
                      addr['landmark'] = landmarkCtrl.text.trim().isNotEmpty
                          ? landmarkCtrl.text.trim()
                          : null;
                      addr['hasElevator'] = hasElevator;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLanguage.tr(ar: 'تم تحديث العنوان بنجاح', en: 'Address updated successfully'),
                          style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF131B2E),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondaryContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    AppLanguage.tr(ar: 'حفظ التعديلات', en: 'Save Changes'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
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

  void _deleteAddress(String id) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: colorSurfaceLowest,
          title: Text(
            AppLanguage.tr(ar: 'حذف العنوان', en: 'Delete Address'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            AppLanguage.tr(ar: 'هل أنت متأكد من رغبتك في حذف هذا العنوان من قائمة العناوين المحفوظة؟', en: 'Are you sure you want to delete this address from your saved list?'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppLanguage.tr(ar: 'تراجع', en: 'Cancel'),
                style: GoogleFonts.ibmPlexSansArabic(
                  color: colorOnSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _savedAddresses.removeWhere((item) => item['id'] == id);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLanguage.tr(ar: 'تم حذف العنوان بنجاح', en: 'Address deleted successfully'),
                      style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF131B2E),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorError,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLanguage.tr(ar: 'حذف', en: 'Delete'),
                style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmrcLicenceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorSurfaceHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFF188ACE),
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
                          AppLanguage.tr(ar: 'تراخيص هيئة الطاقة والمعادن', en: 'EMRC Energy Licenses'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurface,
                          ),
                        ),
                        Text(
                          'EMRC Official Gas Distribution Licence',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            color: colorOutline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildEmrcBullet(
                title: AppLanguage.tr(ar: 'ترخيص نقل وتوزيع رقم JO-EMRC-2026/894', en: 'Transport & Distribution License JO-EMRC-2026/894'),
                desc: AppLanguage.tr(ar: 'مرخص رسميًا لنقل وتوزيع أسطوانات الغاز البترولي المسال (LPG) في المملكة الأردنية الهاشمية.', en: 'Officially licensed for LPG cylinder distribution across Jordan.'),
              ),
              const SizedBox(height: 10),
              _buildEmrcBullet(
                title: AppLanguage.tr(ar: 'مطابقة مواصفات مؤسسة المقاييس (JSMO)', en: 'JSMO Safety Standard Compliance'),
                desc: AppLanguage.tr(ar: 'جميع الأسطوانات والصمامات تخضع للفحص الميكانيكي الهيدروليكي واختبار التسرب الدوري قبل التحميل.', en: 'All cylinders and valves undergo hydraulic pressure & leak tests before loading.'),
              ),
              const SizedBox(height: 10),
              _buildEmrcBullet(
                title: AppLanguage.tr(ar: 'تأمين سلامة شامل ومسؤولية مدنية', en: 'Comprehensive Safety & Liability Insurance'),
                desc: AppLanguage.tr(ar: 'كافة عمليات النقل والتركيب مغطاة بوثيقة تأمين معتمدة تضمن سلامة المستهلك والمنشآت.', en: 'All deliveries covered by certified safety insurance policies.'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF131B2E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLanguage.tr(ar: 'إغلاق', en: 'Close'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmrcBullet({required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorSurfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
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

  void _confirmEmergencyCall({required String number, required String title}) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: colorSurfaceLowest,
          title: Row(
            children: [
              const Icon(Icons.phone_in_talk_rounded, color: colorError),
              const SizedBox(width: 8),
              Text(
                AppLanguage.tr(ar: 'الاتصال بالطوارئ', en: 'Emergency Call'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            AppLanguage.tr(ar: 'هل ترغب في الاتصال بـ $title على الرقم $number فوراً؟', en: 'Do you want to call $title on $number now?'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppLanguage.tr(ar: 'إلغاء', en: 'Cancel'),
                style: GoogleFonts.ibmPlexSansArabic(
                  color: colorOnSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLanguage.tr(ar: 'جاري الاتصال بـ $number ...', en: 'Calling $number ...'),
                      style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                    ),
                    backgroundColor: colorError,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorError,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLanguage.tr(ar: 'اتصال الآن', en: 'Call Now'),
                style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: colorSurfaceLowest,
          title: Row(
            children: [
              const Icon(Icons.logout_rounded, color: colorError),
              const SizedBox(width: 8),
              Text(
                AppLanguage.tr(ar: 'تسجيل الخروج', en: 'Log Out'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            AppLanguage.tr(ar: 'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟', en: 'Are you sure you want to log out of the application?'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                AppLanguage.tr(ar: 'إلغاء', en: 'Cancel'),
                style: GoogleFonts.ibmPlexSansArabic(
                  color: colorOnSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorError,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLanguage.tr(ar: 'تأكيد الخروج', en: 'Confirm Logout'),
                style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BoxInsets helper to avoid deprecated BoxShadow constructor usage if needed
class BoxInsets {
  static BoxShadow boxShadow({
    required Color color,
    required double blurRadius,
    required Offset offset,
  }) {
    return BoxShadow(
      color: color,
      blurRadius: blurRadius,
      offset: offset,
    );
  }
}