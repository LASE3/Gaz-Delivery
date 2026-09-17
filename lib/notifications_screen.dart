// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'orders_history_screen.dart';
import 'user_profile_screen.dart';
import 'order_tracking.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  // Theme Color Tokens
  static const Color colorSurface = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceContainer = Color(0xFFE5EEFF);
  static const Color colorSurfaceHigh = Color(0xFFDCE9FF);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);
  static const Color colorOutline = Color(0xFF76777D);
  static const Color colorOutlineVariant = Color(0xFFC6C6CD);

  static const Color colorPrimaryContainer = Color(0xFF131B2E);
  static const Color colorOnPrimary = Color(0xFFFFFFFF);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorSecondaryFixed = Color(0xFFFFDBCE);

  static const Color colorOnTertiaryContainer = Color(0xFF188ACE);
  static const Color colorError = Color(0xFFBA1A1A);
  static const Color colorErrorContainer = Color(0xFFFFDAD6);
  static const Color colorOnErrorContainer = Color(0xFF93000A);

  // Active Category: 'all', 'orders', 'safety', 'updates'
  String _selectedCategory = 'all';

  // Bottom Navigation Index: 2 = 'الإشعارات'
  final int _navIndex = 2;

  // Notification Data Items
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() {
    _notifications = [
      NotificationModel(
        id: '1',
        category: 'orders',
        tag: 'تحديث مباشر للرحلة',
        time: 'قبل 4 دقائق',
        title: 'الكابتن أحمد الخوالدة على وشك الوصول!',
        description:
            'يبعد الشاحن 300 متر فقط عن موقعك (عمارة 42 - شارع وصفي التل). يرجى تجهيز الأسطوانة الفارغة والمبلغ نقداً.',
        isUnread: true,
        isUrgentLive: true,
        amountDue: '17.00 د.أ',
        driverPhone: '0790000000',
        icon: Icons.directions_car_rounded,
      ),
      NotificationModel(
        id: '2',
        category: 'orders',
        tag: 'حالة الطلب',
        time: 'قبل 18 دقيقة',
        title: 'تم تعيين سائق لطلبك #84935',
        description:
            'استلم الكابتن أحمد طلبك من المحطة المركزية، ومعه أسطوانة جديدة ومختومة بالليزر مع منظم غاز إيطالي حسب طلبك.',
        isUnread: true,
        icon: Icons.assignment_turned_in_rounded,
      ),
      NotificationModel(
        id: '3',
        category: 'updates',
        tag: 'بلاغ رسمي',
        time: 'أمس',
        title: 'اعتماد التسعيرة الشهرية الرسمية لأسطوانة الغاز',
        description:
            'أعلنت هيئة تنظيم قطاع الطاقة والمعادن الأردنية ثبات سعر بيع أسطوانة الغاز المنزلي (12.5 كغ) عند 7.00 دنانير للمستهلك دون تغيير.',
        isUnread: true,
        isOfficial: true,
        icon: Icons.verified_rounded,
      ),
      NotificationModel(
        id: '4',
        category: 'orders',
        tag: 'منجز',
        time: 'قبل 3 أسابيع',
        title: 'تم تسليم طلبك #84920 بنجاح',
        description:
            'نشكرك لاختيارك تطبيق غاز الأردن. تم تركيب الأسطوانة وفحص صمام الأمان مجاناً بفقاعات الصابون لضمان سلامة عائلتك.',
        isUnread: false,
        hasInvoiceAction: true,
        icon: Icons.task_alt_rounded,
      ),
      NotificationModel(
        id: '5',
        category: 'safety',
        tag: 'إرشادات السلامة العامة',
        time: 'قبل شهر',
        title: 'نصيحة أمان منزلية: سلامة خرطوم الغاز (البربيش)',
        description:
            'احرص دائماً على فحص خرطوم التوصيل والتأكد من مرونته وعدم وجود تشققات، مع ضرورة استبداله كل سنتين على الأكثر واستخدام المرابط المعدنية الأصلية فقط.',
        isUnread: false,
        isSafetyTip: true,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCP0p2M29YGQg81NhMQI4T_xKWhREw2XkA7jObvuo182_7opAVnkcl6gSjk6DbiA5IvhqBkjJCFx665-JXBZw5IeNR0eudDtUIs4W8hfiBHbYwSjxgFu0hVlrS0n8KiLkjG-SQ005zcc2uoYlwwEyZODQ7sa_p18bPov9Qv-xFcGmoDtq3VkXqjD1w2WI1AKzwWoy9BiBVq3ml5mEiYiR4--UFvisaz1X7tzpm5K-JFsBs0O2tqTgNDZw',
        icon: Icons.shield_outlined,
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  List<NotificationModel> get _filteredNotifications {
    if (_selectedCategory == 'all') {
      return _notifications;
    }
    return _notifications
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isUnread = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تحديد جميع الإشعارات كمقروءة',
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF131B2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleNotificationRead(NotificationModel item) {
    setState(() {
      item.isUnread = !item.isUnread;
    });
  }

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
              _buildHeaderBar(),
              const SizedBox(height: 14),
              _buildFilterPills(),
              const SizedBox(height: 16),
              _buildNotificationsFeed(),
              const SizedBox(height: 24),
              _buildEndOfStreamIndicator(),
              const SizedBox(height: 80), // Space for bottom nav
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
                'الإشعارات والتنبيهات',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              Text(
                'Notifications Alerts',
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
        // Bell icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorSurfaceHigh,
            shape: BoxShape.circle,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_rounded,
                color: colorSecondaryContainer,
                size: 22,
              ),
              if (_unreadCount > 0)
                Positioned(
                  top: 7,
                  right: 7,
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

        // Profile Avatar
        GestureDetector(
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
                color: colorSecondaryContainer.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: const ClipOval(
              child: Icon(
                Icons.person_rounded,
                size: 22,
                color: Color(0xFF131B2E),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  // ==========================================
  // HEADER BAR (TITLE & MARK AS READ)
  // ==========================================
  Widget _buildHeaderBar() {
    final int unread = _unreadCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'الإشعارات',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: unread > 0
                    ? colorSecondaryContainer
                    : colorSurfaceHigh,
                borderRadius: BorderRadius.circular(12),
                boxShadow: unread > 0
                    ? [
                        BoxShadow(
                          color: colorSecondaryContainer.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                unread > 0 ? '$unread غير مقروءة' : '0 غير مقروءة',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: unread > 0 ? Colors.white : colorOnSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: unread > 0 ? _markAllAsRead : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.done_all_rounded,
                  size: 18,
                  color: unread > 0
                      ? colorOnTertiaryContainer
                      : colorOutlineVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'تحديد الكل كمقروء',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: unread > 0
                        ? colorOnTertiaryContainer
                        : colorOutlineVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // FILTER PILLS (HORIZONTAL SCROLL)
  // ==========================================
  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterPill(
            id: 'all',
            label: 'الكل',
            hasDot: true,
          ),
          const SizedBox(width: 8),
          _buildFilterPill(
            id: 'orders',
            label: 'حالة الطلب',
            icon: Icons.local_shipping_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterPill(
            id: 'safety',
            label: 'تنبيهات الأمان',
            icon: Icons.health_and_safety_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterPill(
            id: 'updates',
            label: 'عروض وتحديثات',
            icon: Icons.campaign_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill({
    required String id,
    required String label,
    IconData? icon,
    bool hasDot = false,
  }) {
    final bool isSelected = _selectedCategory == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryThemeColor : colorSurfaceLow,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? colorOnPrimary : colorOnSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? colorOnPrimary : colorOnSurfaceVariant,
              ),
            ),
            if (hasDot && isSelected) ...[
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: colorSecondaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get primaryThemeColor => colorPrimaryContainer;

  // ==========================================
  // NOTIFICATIONS FEED
  // ==========================================
  Widget _buildNotificationsFeed() {
    final list = _filteredNotifications;

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colorSurfaceLowest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: colorOutline,
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد إشعارات في هذا التصنيف حالياً',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorOnSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: list.map((item) => _buildNotificationCard(item)).toList(),
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    if (item.isUrgentLive) {
      return _buildUrgentLiveCard(item);
    } else if (item.isSafetyTip) {
      return _buildSafetyCard(item);
    } else if (item.isOfficial) {
      return _buildOfficialNoticeCard(item);
    } else {
      return _buildStandardCard(item);
    }
  }

  // 1. URGENT LIVE DISPATCH CARD
  Widget _buildUrgentLiveCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Right border highlight bar (RTL leading)
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: 5,
              child: Container(color: colorSecondaryContainer),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 14,
                top: 14,
                bottom: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Icon, Tag, Time, Unread Dot
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car icon with ping pulse
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: colorSecondaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.directions_car_rounded,
                                color: colorSecondary,
                                size: 22,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -1,
                            right: -1,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: colorSecondaryContainer,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      // Tag and Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.tag,
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: colorSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: colorOutlineVariant,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.time,
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 11,
                                    color: colorOnSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.title,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colorOnSurface,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (item.isUnread)
                        GestureDetector(
                          onTap: () => _toggleNotificationRead(item),
                          child: Container(
                            width: 9,
                            height: 9,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: const BoxDecoration(
                              color: colorSecondaryContainer,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Description
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          height: 1.5,
                          color: colorOnSurfaceVariant,
                        ),
                        children: const [
                          TextSpan(text: 'يبعد الشاحن '),
                          TextSpan(
                            text: '300 متر',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorOnSurface,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' فقط عن موقعك (عمارة 42 - شارع وصفي التل). يرجى تجهيز الأسطوانة الفارغة والمبلغ نقداً.',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Bill & Delivery Total Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.payments_outlined,
                              size: 19,
                              color: colorOnTertiaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'المبلغ الإجمالي المستحق:',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorOnSurface,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item.amountDue ?? '17.00 د.أ',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: colorSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Actions: Track & Call
                  Row(
                    children: [
                      // Track Button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderTrackingScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: colorSecondaryContainer,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: colorSecondaryContainer.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.near_me_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'تتبع مسار الشاحنة',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Phone Call Button
                      InkWell(
                        onTap: () => _confirmDriverCall(item.driverPhone ?? '0790000000'),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 44,
                          height: 42,
                          decoration: BoxDecoration(
                            color: colorSurfaceContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.phone_rounded,
                              size: 19,
                              color: colorOnSurface,
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
    );
  }

  // 2. STANDARD / DRIVER ASSIGNED / COMPLETED CARD
  Widget _buildStandardCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isUnread
              ? colorSecondaryContainer.withValues(alpha: 0.2)
              : colorSurfaceContainer,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.isUnread ? colorSurfaceHigh : colorSurfaceLow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: item.isUnread ? colorOnSurface : colorOutline,
                  ),
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
                          item.tag,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.isUnread
                                ? colorOnTertiaryContainer
                                : colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: colorOutlineVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.time,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.title,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ),

              if (item.isUnread)
                GestureDetector(
                  onTap: () => _toggleNotificationRead(item),
                  child: Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: colorSecondaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              item.description,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12.5,
                height: 1.5,
                color: colorOnSurfaceVariant,
              ),
            ),
          ),
          if (item.hasInvoiceAction) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: InkWell(
                onTap: () => _showInvoiceDetailsSheet(),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.receipt_long_rounded,
                        size: 16,
                        color: colorOnTertiaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'عرض الفاتورة الإلكترونية',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colorOnTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 3. OFFICIAL REGULATORY NOTICE CARD
  Widget _buildOfficialNoticeCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isUnread
              ? colorSecondaryContainer.withValues(alpha: 0.2)
              : colorSurfaceContainer,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: colorSurfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.verified_rounded,
                    size: 20,
                    color: colorOnSurface,
                  ),
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
                          item.tag,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: colorOutlineVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.time,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.title,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ),

              if (item.isUnread)
                GestureDetector(
                  onTap: () => _toggleNotificationRead(item),
                  child: Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: colorSecondaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12.5,
                      height: 1.5,
                      color: colorOnSurfaceVariant,
                    ),
                    children: const [
                      TextSpan(
                        text:
                            'أعلنت هيئة تنظيم قطاع الطاقة والمعادن الأردنية ثبات سعر بيع أسطوانة الغاز المنزلي (12.5 كغ) عند ',
                      ),
                      TextSpan(
                        text: '7.00 دنانير',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                      TextSpan(text: ' للمستهلك دون تغيير.'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showEmrcPricingSheet(),
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'تطبيق الأسعار الحكومية المعتمدة دائماً',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colorOnTertiaryContainer,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_back_rounded,
                        size: 15,
                        color: colorOnTertiaryContainer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. HOUSEHOLD SAFETY TIPS CARD (WITH IMAGE)
  Widget _buildSafetyCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorSurfaceContainer, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: colorErrorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.shield_outlined,
                    size: 20,
                    color: colorOnErrorContainer,
                  ),
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
                          item.tag,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colorError,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: colorOutlineVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.time,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.title,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12.5,
                    height: 1.5,
                    color: colorOnSurfaceVariant,
                  ),
                ),
                if (item.imageUrl != null) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorSurfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colorSurfaceHigh,
                          child: const Center(
                            child: Icon(
                              Icons.safety_check_rounded,
                              size: 40,
                              color: colorSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // END OF STREAM INDICATOR
  // ==========================================
  Widget _buildEndOfStreamIndicator() {
    return Column(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 22,
          color: colorOnSurfaceVariant.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 4),
        Text(
          'أنت مطلع على جميع الإشعارات السابقة',
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 11,
            color: colorOnSurfaceVariant.withValues(alpha: 0.7),
          ),
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
                icon: Icons.notifications_rounded,
                label: 'الإشعارات',
                hasBadge: false,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
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
          // Already on Notifications
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
  // MODALS & SHEETS
  // ==========================================

  void _confirmDriverCall(String phone) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: colorSurfaceLowest,
          title: Row(
            children: [
              const Icon(Icons.phone_in_talk_rounded, color: colorSecondary),
              const SizedBox(width: 8),
              Text(
                'الاتصال بالكابتن',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'هل ترغب في الاتصال بالكابتن أحمد الخوالدة على الرقم $phone لتنسيق استلام الأسطوانة؟',
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
                      'جاري الاتصال بـ $phone ...',
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
                'اتصال الآن',
                style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetailsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الفاتورة الضريبية الإلكترونية',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'مدفوع نقدًا',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF047857),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'طلب رقم #84920 • تاريخ 24 آب 2026',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOutline,
                ),
              ),
              const Divider(height: 24),
              _buildInvoiceRow('أسطوانة غاز منزلي (تبديل)', '7.00 د.أ'),
              _buildInvoiceRow('أجور التوصيل والتركيب', '1.50 د.أ'),
              _buildInvoiceRow('فحص التسريب بفقاعات الصابون', 'مجاناً'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المجموع الإجمالي:',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                  Text(
                    '8.50 د.أ',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: colorSecondary,
                    ),
                  ),
                ],
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
                  'إغلاق الفاتورة',
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

  Widget _buildInvoiceRow(String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorOnSurface,
            ),
          ),
          Text(
            price,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorOnSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _showEmrcPricingSheet() {
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
                  const Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF188ACE),
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'التسعيرة الرسمية المعتمدة - EMRC',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorOnSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'تلتزم شركة غاز الأردن بالتسعيرة الشهرية الرسمية الصادرة عن لجنة تسعير المشتقات النفطية وهيئة تنظيم قطاع الطاقة والمعادن دون أي زيادة إضافية على سعر مادة الغاز البترولي المسال.',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12.5,
                  height: 1.5,
                  color: colorOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سعر أسطوانة 12.5 كغ الرسمي:',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '7.00 د.أ',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colorSecondary,
                      ),
                    ),
                  ],
                ),
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
                  'حسناً، فهمت',
                  style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationModel {
  final String id;
  final String category; // 'orders', 'safety', 'updates'
  final String tag;
  final String time;
  final String title;
  final String description;
  bool isUnread;
  final IconData icon;
  final bool isUrgentLive;
  final String? amountDue;
  final String? driverPhone;
  final bool isOfficial;
  final bool hasInvoiceAction;
  final bool isSafetyTip;
  final String? imageUrl;

  NotificationModel({
    required this.id,
    required this.category,
    required this.tag,
    required this.time,
    required this.title,
    required this.description,
    required this.isUnread,
    required this.icon,
    this.isUrgentLive = false,
    this.amountDue,
    this.driverPhone,
    this.isOfficial = false,
    this.hasInvoiceAction = false,
    this.isSafetyTip = false,
    this.imageUrl,
  });
}
