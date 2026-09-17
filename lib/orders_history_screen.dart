// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'order_tracking.dart';
import 'driver_chat_screen.dart';
import 'user_profile_screen.dart';
import 'notifications_screen.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
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

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorOnTertiaryFixedVariant = Color(0xFF004B73);

  // Active filter tab: 'active', 'completed', 'cancelled'
  String _selectedFilter = 'active';

  // Bottom Navigation Index (1 = Orders)
  int _navIndex = 1;

  void _showInvoiceSheet({
    required String orderNumber,
    required String date,
    required String address,
    required String total,
    required List<Map<String, String>> items,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فاتورة ضريبية رسمية',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        'طلب $orderNumber • $date',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'مدفوع نقداً',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF007A3D),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, color: colorSurfaceContainer),
              Text(
                'عنوان التوصيل',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: colorSecondaryContainer),
                  const SizedBox(width: 4),
                  Text(
                    address,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'تفاصيل البنود والأسعار',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['title']!,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        item['price']!,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24, color: colorSurfaceContainer),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المجموع الإجمالي الشامل:',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  Text(
                    '$total د.أ',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: colorSecondary,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 20),
                  label: Text(
                    'تحميل إيصال الفاتورة (PDF)',
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
      ),
    );
  }

  void _handleReorder(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'تمت إضافة $title إلى سلة التسوق بنجاح',
              style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: colorPrimaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorBackground,
        // Header
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: AppBar(
            backgroundColor: colorSurface.withValues(alpha: 0.95),
            elevation: 0.5,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            centerTitle: false,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Row(
              children: [
                // App Logo
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colorSecondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: colorSecondaryContainer.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'غاز الأردن | GAS',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'سجل الطلبات • Order History',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Customer Support Button
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverChatScreen(),
                    ),
                  );
                },
                icon: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colorSurfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: colorOnSurface,
                    size: 20,
                  ),
                ),
              ),
              // Profile Avatar
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16, start: 4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserProfileScreen(),
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Floating Sticky Filter Navigation Tabs
              _buildFilterTabs(),
              const SizedBox(height: 16),

              // Content based on filter
              if (_selectedFilter == 'cancelled') ...[
                _buildCancelledEmptyState(),
              ] else if (_selectedFilter == 'completed') ...[
                _buildCompletedOrdersSection(),
              ] else ...[
                // Active Filter View
                // 2. Live Dispatch Active Order Section
                _buildActiveOrderSection(),
                const SizedBox(height: 16),

                // 3. Energy Ministry Cash Compliance Notice
                _buildEnergyMinistryNotice(),
                const SizedBox(height: 16),

                // 4. Past Completed Orders Section
                _buildCompletedOrdersSection(),
              ],
            ],
          ),
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  // 1. Filter Navigation Tabs
  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorSurfaceLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Active Tab
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = 'active';
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: _selectedFilter == 'active'
                      ? colorSurfaceLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedFilter == 'active'
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
                    Text(
                      'الطلبات النشطة',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: _selectedFilter == 'active'
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _selectedFilter == 'active'
                            ? colorOnSurface
                            : colorOnSurfaceVariant,
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
          const SizedBox(width: 4),

          // Completed Tab
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = 'completed';
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: _selectedFilter == 'completed'
                      ? colorSurfaceLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedFilter == 'completed'
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
                    'الطلبات المكتملة',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: _selectedFilter == 'completed'
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: _selectedFilter == 'completed'
                          ? colorOnSurface
                          : colorOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Cancelled Tab
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = 'cancelled';
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: _selectedFilter == 'cancelled'
                      ? colorSurfaceLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedFilter == 'cancelled'
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
                    'الملغاة',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: _selectedFilter == 'cancelled'
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: _selectedFilter == 'cancelled'
                          ? colorOnSurface
                          : colorOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Active Order Live Card
  Widget _buildActiveOrderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: colorSecondaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'الطلب النشط حالياً',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorOnSurface,
                  ),
                ),
              ],
            ),
            Text(
              'يصل خلال 12 دقيقة',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Active Order Card
        Container(
          decoration: BoxDecoration(
            color: colorSurfaceLowest,
            borderRadius: BorderRadius.circular(18),
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
              // Gradient Status Header with Progress Stepper
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorPrimaryContainer,
                      colorSurfaceHigh,
                      colorSurfaceLow,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorSurfaceLowest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#84935',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorOnSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'اليوم، 11:42 ص',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11,
                                color: colorOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorSurfaceLowest.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_shipping_rounded,
                                size: 16,
                                color: colorSecondaryContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'الكابتن في الطريق إليك',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colorSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 6,
                        color: colorSurfaceContainer,
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
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تم التأكيد',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 10,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        Text(
                          'في الطريق (حي الجامعة)',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorSecondary,
                          ),
                        ),
                        Text(
                          'الوصول والتوصيل',
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

              // Items Breakdown
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    // Item 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: colorSurfaceHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.local_fire_department_rounded,
                                color: colorSecondary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'أسطوانة غاز منزلي 12.5 كغ',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: colorOnSurface,
                                  ),
                                ),
                                Text(
                                  'تبديل أسطوانة حديدية فارغة',
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
                          '1× 7.00 د.أ',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Item 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: colorSurfaceHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: Color(0xFF188ACE),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'منظّم وساعة غاز إيطالي',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: colorOnSurface,
                                  ),
                                ),
                                Text(
                                  'صمام أمان أوتوماتيكي أصلي',
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
                          '1× 10.00 د.أ',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Total Price Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorSurfaceLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payments_outlined,
                                  size: 18, color: colorSecondary),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'طريقة الدفع المحجوزة',
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 10,
                                      color: colorOnSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    'نقداً عند الاستلام',
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: colorSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'المجموع: ',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11,
                                  color: colorOnSurfaceVariant,
                                ),
                              ),
                              Text(
                                '17.00',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: colorOnSurface,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'د.أ',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colorOnSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Assigned Driver Module
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDMJ-i-wVjtyTFxb018ZLgEP9gAC-DSx0q-O6UXZDS7HA6UVjoJds92VtwETX6dZ9LFVTDoQmVt1lodwZeHggjN2j5cLv6dwll7zgZap2-uuOzIKA2LYN4C0-w7lb4Tq6Fx8i6nn3esTTtlnzaxR7cuaz_FnuYbSORWvUPKFnXNcU_h6BXahQM2M_3Qn8zL78aDio0qaoVsgVMR6UPd7Shx5HlTG4MgVZHUYGDez5sS0_7OUo8iorcnZA',
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 44,
                                      height: 44,
                                      color: colorSurfaceContainer,
                                      child: const Icon(Icons.person,
                                          color: colorSecondary),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: colorSecondaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'أحمد المجالي',
                                      style: GoogleFonts.ibmPlexSansArabic(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: colorOnSurface,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: colorSurfaceContainer,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star_rounded,
                                              size: 13,
                                              color: colorSecondaryContainer),
                                          const SizedBox(width: 2),
                                          Text(
                                            '4.9',
                                            style:
                                                GoogleFonts.ibmPlexSansArabic(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: colorOnSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'ديانا هيونداي (مركبة رقم: 14-88920)',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 11,
                                    color: colorOnSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'جاري الاتصال بالكابتن أحمد: 0790000000',
                                  style: GoogleFonts.ibmPlexSansArabic(),
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: colorPrimaryContainer,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colorSurfaceContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.phone,
                                size: 18, color: colorOnSurface),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dual Touch Action Targets (Chat & Live Tracking)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DriverChatScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorSurfaceHigh,
                                foregroundColor: colorOnSurface,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.chat_bubble_outline_rounded,
                                  size: 16),
                              label: Text(
                                'محادثة',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderTrackingScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorSecondaryContainer,
                                foregroundColor: Colors.white,
                                elevation: 1,
                                shadowColor: colorSecondaryContainer
                                    .withValues(alpha: 0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.near_me_rounded, size: 16),
                              label: Text(
                                'تتبع مباشر',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 13,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. Official Jordanian Energy Ministry Notice
  Widget _buildEnergyMinistryNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorSurfaceHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: colorOnTertiaryFixedVariant,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'الدفع نقداً فقط عند الاستلام لجميع الطلبات',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: colorSurfaceHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'معتمد',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: colorOnTertiaryFixedVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'امتثالاً لتعليمات هيئة تنظيم قطاع الطاقة والمعادن الأردنية (EMRC)، يُحاسب الموزع المعتمد بالتعرفة الرسمية للأسطوانة مباشرة عند باب منزلك مع فحص صمام الأمان مجاناً.',
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
    );
  }

  // 4. Past Completed Orders Section
  Widget _buildCompletedOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'سجل الطلبات السابقة',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorOnSurface,
              ),
            ),
            Text(
              'إجمالي المكتمل: 14 طلب',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 11,
                color: colorOnSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Order 1: Khilda
        _buildHistoricalOrderCard(
          orderNumber: '#84920',
          date: '12 شباط 2025',
          title: '1× أسطوانة غاز + رسوم طابق رابع',
          address: 'عمان، خلدا - قرب إشارة البنك العربي',
          total: '8.50',
          items: [
            {'title': '1× أسطوانة غاز منزلي 12.5 كغ', 'price': '7.00 د.أ'},
            {'title': 'رسوم صعود طابق رابع (بدون مصعد)', 'price': '1.50 د.أ'},
          ],
          hasReorder: true,
        ),
        const SizedBox(height: 12),

        // Order 2: Tla' Al-Ali
        _buildHistoricalOrderCard(
          orderNumber: '#84102',
          date: '18 كانون الثاني 2025',
          title: '1× أسطوانة غاز منزلي 12.5 كغ',
          address: 'عمان، تلاع العلي - خلف سوق السلطان',
          total: '7.00',
          items: [
            {'title': '1× أسطوانة غاز منزلي 12.5 كغ', 'price': '7.00 د.أ'},
            {'title': 'فحص صمام الأمان الإلكتروني', 'price': 'مجاني 0.00 د.أ'},
          ],
          hasReorder: false,
        ),
        const SizedBox(height: 12),

        // Order 3: Abdoun
        _buildHistoricalOrderCard(
          orderNumber: '#83590',
          date: '28 كانون الأول 2024',
          title: '2× أسطوانة غاز + خرطوم أمان إيطالي',
          address: 'عمان، عبدون الشمالي - قرب الدوار الرابع',
          total: '17.50',
          items: [
            {'title': '2× أسطوانة غاز منزلي 12.5 كغ', 'price': '14.00 د.أ'},
            {'title': '1× خرطوم أمان إيطالي 1.5 متر', 'price': '3.50 د.أ'},
          ],
          hasReorder: true,
        ),
      ],
    );
  }

  // Historical Order Card Widget
  Widget _buildHistoricalOrderCard({
    required String orderNumber,
    required String date,
    required String title,
    required String address,
    required String total,
    required List<Map<String, String>> items,
    required bool hasReorder,
  }) {
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
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorSurfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      orderNumber,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorSurfaceHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 13, color: colorSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'تم التسليم بنجاح',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: colorOnSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            overflow: TextOverflow.ellipsis,
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
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    total,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: colorOnSurface,
                    ),
                  ),
                  Text(
                    'د.أ',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          if (hasReorder) ...[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () => _showInvoiceSheet(
                        orderNumber: orderNumber,
                        date: date,
                        address: address,
                        total: total,
                        items: items,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorSurfaceLow,
                        foregroundColor: colorOnSurface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.receipt_long_rounded, size: 15),
                      label: Text(
                        'الفاتورة التفصيلية',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleReorder(title),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorSecondaryContainer,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.replay_rounded, size: 15),
                      label: Text(
                        'إعادة الطلب بنقرة',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton.icon(
                onPressed: () => _showInvoiceSheet(
                  orderNumber: orderNumber,
                  date: date,
                  address: address,
                  total: total,
                  items: items,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSurfaceHigh,
                  foregroundColor: colorOnSurface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.rate_review_outlined, size: 15),
                label: Text(
                  'عرض الفاتورة والتقييم',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Cancelled Orders Empty State
  Widget _buildCancelledEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorSurfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.remove_shopping_cart_outlined,
              size: 32,
              color: colorOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'لا توجد طلبات ملغاة',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'جميع طلبات الوقود والغاز الخاصة بك تم إنجازها وتسليمها بسلامة تامة عبر شبكة موزعينا المعتمدين.',
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12,
              color: colorOnSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedFilter = 'active';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSurfaceHigh,
              foregroundColor: colorOnSurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'الرجوع إلى النشطة',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: colorSurface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
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
          // Already on orders history
          setState(() {
            _navIndex = 1;
          });
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserProfileScreen(),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
}
