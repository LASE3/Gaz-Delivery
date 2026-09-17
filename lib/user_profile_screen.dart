// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String _userPhone = '+962 7 9123 4567';
  String _userEmail = 'm.qudah@example.com';
  final String _userCity = 'عمان';
  String _selectedValveType = 'سريع (كبس أزرق)';
  String _selectedPaymentMethod = 'نقدًا عند الاستلام';

  // Settings State
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'ar'; // 'ar' or 'en'

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
    return Directionality(
      textDirection: TextDirection.rtl,
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
                'الملف الشخصي',
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
                                  _userName,
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
                                      _userCity,
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
                          'عميل معتمد وموثق بالهوية ومعايير الأمان الأردنية',
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
                          'تعديل الملف الشخصي',
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
                          'نوع الصمام',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedValveType,
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
                          'طريقة الدفع',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedPaymentMethod,
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
                  'العناوين المحفوظة',
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
                '${_savedAddresses.length} عناوين',
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
                  '+ إضافة عنوان جديد',
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
                    addr['title'],
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
                        'افتراضي',
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
                    tooltip: 'تعديل العنوان',
                  ),
                  IconButton(
                    onPressed: () => _deleteAddress(id),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: colorError,
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'حذف العنوان',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              addr['address'],
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: isDefault ? colorOnSurface : colorOnSurfaceVariant,
              ),
            ),
          ),
          if (addr['hasElevator'] == true || addr['landmark'] != null) ...[
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
                          'يوجد مصعد كهربائي',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  if (addr['landmark'] != null)
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
                          addr['landmark'],
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
              'إعدادات الحساب والخدمة',
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
                title: 'سجل الطلبات والفواتير السابقة',
                subtitle: 'تاريخ التوصيل والإيصالات الضريبية',
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
                        '14 طلب ناجح',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_left_rounded,
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
                title: 'مركز المساعدة وبلاغات الدعم الفني',
                subtitle: 'خدمة العملاء وحل الشكاوى على مدار الساعة',
                trailing: const Icon(
                  Icons.chevron_left_rounded,
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
                title: 'لغة التطبيق',
                subtitle: 'Language Preferences',
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
                        isSelected: _selectedLanguage == 'ar',
                      ),
                      _buildLangPill(
                        code: 'en',
                        label: 'English',
                        isSelected: _selectedLanguage == 'en',
                      ),
                    ],
                  ),
                ),
              ),
              _buildDivider(),

              // Delivery Notifications Toggle Switch
              _buildSettingsRow(
                icon: Icons.notifications_active_outlined,
                title: 'إشعارات التوصيل ووصول الكابتن',
                subtitle: 'تحديث فوري لمركبة التوزيع واقترابها',
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
                              ? 'تم تفعيل إشعارات اقتراب شاحنة الغاز'
                              : 'تم تعطيل إشعارات التوصيل',
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
                title: 'الشروط وتراخيص هيئة الطاقة EMRC',
                subtitle: 'سياسة الخصوصية ومعايير النقل المعتمدة',
                trailing: const Icon(
                  Icons.chevron_left_rounded,
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? colorSurfaceLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? colorOnSurface : colorOnSurfaceVariant,
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
                'طوارئ الغاز والدفاع المدني',
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
            'في حال الاشتباه بأي تسرب للغاز أو حالة طوارئ منزلية، يرجى إخلاء المكان فورا والاتصال بفرق السلامة دون تردد:',
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
                    title: 'الدفاع المدني والأمن العام (911)',
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
                          'طوارئ 911',
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
                    title: 'مركز الغاز الموحد للطوارئ',
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
                          'مركز الغاز الموحد',
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
                  'تسجيل الخروج',
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
          'إصدار التطبيق v2.4.0',
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorOnSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'غاز الأردن المعتمد (خدمات العاصمة عمان ومحافظة الزرقاء)',
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
                label: 'الرئيسية',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.inventory_2_outlined,
                label: 'طلباتي',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications_none_rounded,
                label: 'الإشعارات',
                hasBadge: true,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_rounded,
                label: 'حسابي',
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
        textDirection: TextDirection.rtl,
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
                'تعديل الملف الشخصي',
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
                    labelText: 'الاسم الكامل',
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
                    labelText: 'رقم الهاتف',
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
                    labelText: 'البريد الإلكتروني',
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
                'إلغاء',
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
                      'تم تحديث البيانات بنجاح',
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
                'حفظ التغييرات',
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
        textDirection: TextDirection.rtl,
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
                'اختر نوع صمام أسطوانة الغاز',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تأكد من اختيار الصمام المطابق لمنظم الغاز في منزلك لتفادي مشاكل التركيب',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                title: 'سريع (كبس أزرق) - Modern Click-on',
                desc: 'المنظم الحديث بالضغط الأزرق المعتمد في معظم المنازل',
                isSelected: _selectedValveType.contains('سريع'),
                onTap: () {
                  setState(() => _selectedValveType = 'سريع (كبس أزرق)');
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                title: 'لولبي تقليدي (سن ناعم) - Screw-on',
                desc: 'الصمام المعدني القديم بالربط الميكانيكي اليدوي',
                isSelected: _selectedValveType.contains('لولبي'),
                onTap: () {
                  setState(() => _selectedValveType = 'لولبي (سن يدوي)');
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
        textDirection: TextDirection.rtl,
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
                'طريقة الدفع الافتراضية',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                title: 'نقدًا عند الاستلام (COD)',
                desc: 'الدفع المباشر لكابتن التوزيع بعد الفحص والاستلام',
                isSelected: _selectedPaymentMethod.contains('نقدًا'),
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'نقدًا عند الاستلام');
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                title: 'كليك (CliQ) - تحويل فوري',
                desc: 'دفع مباشر عبر الاسم المستعار لكابتن التوصيل',
                isSelected: _selectedPaymentMethod.contains('كليك'),
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'دفع فوري عبر كليك CliQ');
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                title: 'بطاقة فيزا / ماستركارد',
                desc: 'دفع إلكتروني آمن مشفر 100%',
                isSelected: _selectedPaymentMethod.contains('بطاقة'),
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'بطاقة بنكية إلكترونية');
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
    final titleCtrl = TextEditingController(text: addr['title']);
    final addressCtrl = TextEditingController(text: addr['address']);
    final landmarkCtrl = TextEditingController(text: addr['landmark'] ?? '');
    bool hasElevator = addr['hasElevator'] == true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
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
                  'تعديل تفاصيل العنوان',
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
                    labelText: 'اسم العنوان (مثال: المنزل، الشاليه)',
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
                    labelText: 'العنوان بالتفصيل',
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
                    labelText: 'علامة مميزة (اختياري)',
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
                    'يتوفر مصعد في المبنى',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'يساعد كابتن التوصيل في التجهيز المسبق لحمل الأسطوانات',
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
                          'تم تحديث العنوان بنجاح',
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
                    'حفظ التعديلات',
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
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: colorSurfaceLowest,
          title: Text(
            'حذف العنوان',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في حذف هذا العنوان من قائمة العناوين المحفوظة؟',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'تراجع',
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
                      'تم حذف العنوان بنجاح',
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
                'حذف',
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
        textDirection: TextDirection.rtl,
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
                          'تراخيص هيئة الطاقة والمعادن',
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
                title: 'ترخيص نقل وتوزيع رقم JO-EMRC-2026/894',
                desc: 'مرخص رسميًا لنقل وتوزيع أسطوانات الغاز البترولي المسال (LPG) في المملكة الأردنية الهاشمية.',
              ),
              const SizedBox(height: 10),
              _buildEmrcBullet(
                title: 'مطابقة مواصفات مؤسسة المقاييس (JSMO)',
                desc: 'جميع الأسطوانات والصمامات تخضع للفحص الميكانيكي الهيدروليكي واختبار التسرب الدوري قبل التحميل.',
              ),
              const SizedBox(height: 10),
              _buildEmrcBullet(
                title: 'تأمين سلامة شامل ومسؤولية مدنية',
                desc: 'كافة عمليات النقل والتركيب مغطاة بوثيقة تأمين معتمدة تضمن سلامة المستهلك والمنشآت.',
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
                  'إغلاق',
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
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: colorSurfaceLowest,
          title: Row(
            children: [
              const Icon(Icons.phone_in_talk_rounded, color: colorError),
              const SizedBox(width: 8),
              Text(
                'الاتصال بالطوارئ',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'هل ترغب في الاتصال بـ $title على الرقم $number فوراً؟',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'إلغاء',
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
                      'جاري الاتصال بـ $number ...',
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
                'اتصال الآن',
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
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: colorSurfaceLowest,
          title: Row(
            children: [
              const Icon(Icons.logout_rounded, color: colorError),
              const SizedBox(width: 8),
              Text(
                'تسجيل الخروج',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'إلغاء',
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
                'تأكيد الخروج',
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
