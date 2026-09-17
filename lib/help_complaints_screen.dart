// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_language.dart';
import 'permission_helper.dart';
import 'page_transitions.dart';
import 'driver_chat_screen.dart';
import 'user_profile_screen.dart';

class HelpComplaintsScreen extends StatefulWidget {
  const HelpComplaintsScreen({super.key});

  @override
  State<HelpComplaintsScreen> createState() => _HelpComplaintsScreenState();
}

class _HelpComplaintsScreenState extends State<HelpComplaintsScreen> {
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
  static const Color colorOnSecondaryFixed = Color(0xFF370E00);

  static const Color colorOnTertiaryContainer = Color(0xFF188ACE);
  static const Color colorError = Color(0xFFBA1A1A);
  static const Color colorErrorContainer = Color(0xFFFFDAD6);
  static const Color colorOnError = Color(0xFFFFFFFF);
  static const Color colorOnErrorContainer = Color(0xFF93000A);

  // Form State
  String _selectedOrder = '84935';
  String _selectedComplaintType = 'cylinder'; // 'delay', 'cylinder', 'price', 'driver', 'not_received', 'other'
  final TextEditingController _detailsController = TextEditingController();
  int _charCount = 0;
  bool _isSubmitting = false;
  bool _isSubmittedSuccess = false;
  String _generatedTicketNumber = '#C-9942';

  // Photo Attachments State
  final List<String> _attachedImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuD7P9XxUluS7yLIqWdBcSG7LurkVcv2l1OMcBT9ca_2TTROMwF1h47Zo9PEHceWtpiFY7FuzXPM_1UNCDe3YDoUFaMIy-285we1rKhGV6PluuJeQYnwd3eM9GaJuNdc8e0hUj9-QB6cyaQhCEVUEcnXG2CCfnx5V4BgACr3YShlg2uKyA5-BHkQvseK7H_F0ZMu3OmTXoWKXHCrIy5OW5AIoNP65WpudYaCtt2ItpfoF4zlwGAcwUTROA',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA5_QjNSIUJJBUZ0__OQmuH7RrPS3eDmWYwZj-1p-zI7GizUaa9efLekbeBT_H5jlzEsaQjyBTd3LLao8SqjQ_H1aMMyNRzSdZ80U-DYBSPhNA4fw77OHB1rSA4j5sareDmijqwaALFOWduxi7QnPqPNdZ9gLhTs1gZQf7_N9igl07LLvbvScmom8hGVwJu5JTlZEyHhmKyWnAswmugun_VHRjK3H_-zTBSD41purvKCGtx8jURB7cRmg',
  ];

  final List<Map<String, dynamic>> _complaintTypesList = [
    {
      'id': 'delay',
      'label': AppLanguage.tr(ar: 'تأخر وصول الكابتن', en: 'Driver delay'),
      'icon': Icons.schedule_rounded,
    },
    {
      'id': 'cylinder',
      'label': AppLanguage.tr(ar: 'عيوب الأسطوانة والصمام', en: 'Cylinder or valve defects'),
      'icon': Icons.propane_tank_rounded,
    },
    {
      'id': 'price',
      'label': AppLanguage.tr(ar: 'خلاف السعر أو الفكة', en: 'Pricing or change dispute'),
      'icon': Icons.payments_outlined,
    },
    {
      'id': 'driver',
      'label': AppLanguage.tr(ar: 'سلوك السائق أو الأمان', en: 'Driver behavior or safety'),
      'icon': Icons.person_off_outlined,
    },
    {
      'id': 'not_received',
      'label': AppLanguage.tr(ar: 'لم يتم استلام الطلب', en: 'Order not received'),
      'icon': Icons.wrong_location_outlined,
    },
    {
      'id': 'other',
      'label': AppLanguage.tr(ar: 'موضوع آخر', en: 'Other topic'),
      'icon': Icons.help_center_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _detailsController.addListener(() {
      setState(() {
        _charCount = _detailsController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_detailsController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLanguage.tr(ar: 'يرجى كتابة تفاصيل المشكلة (10 أحرف على الأقل) للمتابعة الدقيقة.', en: 'Please enter problem details (min 10 characters).'),
            style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
          ),
          backgroundColor: colorError,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isSubmittedSuccess = true;
        _generatedTicketNumber = '#C-${(9000 + (DateTime.now().millisecond % 1000))}';
      });
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLanguage.tr(ar: 'تم حذف الصورة المرفقة', en: 'Attached image removed'),
          style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
        ),
        backgroundColor: const Color(0xFF131B2E),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _addMockPhoto() async {
    final option = await showModalBottomSheet<int>(
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
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLanguage.tr(
                  ar: 'إرفاق صورة توثيقية للبلاغ',
                  en: 'Attach Complaint Photo',
                ),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDBCE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFFFD651E),
                    size: 22,
                  ),
                ),
                title: Text(
                  AppLanguage.tr(
                    ar: 'التقاط صورة بالكاميرا',
                    en: 'Take Photo with Camera',
                  ),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorOnSurface,
                  ),
                ),
                subtitle: Text(
                  AppLanguage.tr(
                    ar: 'تصوير صمام أسطوانة الغاز أو الختم الحراري',
                    en: 'Capture gas cylinder valve or seal',
                  ),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11.5,
                    color: colorOnSurfaceVariant,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, 1),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorSurfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: colorOnSurface,
                    size: 22,
                  ),
                ),
                title: Text(
                  AppLanguage.tr(
                    ar: 'اختيار من استوديو الصور',
                    en: 'Choose from Photo Gallery',
                  ),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorOnSurface,
                  ),
                ),
                subtitle: Text(
                  AppLanguage.tr(
                    ar: 'إرفاق إيصال الدفع أو تقرير السلامة',
                    en: 'Attach payment receipt or safety photo',
                  ),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11.5,
                    color: colorOnSurfaceVariant,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, 2),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

    if (option == null || !mounted) return;

    final AppPermissionType permType =
        option == 1 ? AppPermissionType.camera : AppPermissionType.gallery;

    final bool granted = await PermissionHelper.requestPermission(
      context,
      type: permType,
    );
    if (!granted || !mounted) return;

    setState(() {
      _attachedImages.add(
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&auto=format&fit=crop&q=80',
      );
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
            backgroundColor: colorSurface,
            appBar: _buildTopAppBar(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEmergencyAlertBanner(),
                  const SizedBox(height: 18),
                  _buildFilingFormCard(),
                  const SizedBox(height: 20),
                  _buildDirectAssistanceChannels(),
                  const SizedBox(height: 20),
                  _buildPastComplaintsHistory(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
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
      leading: IconButton(
        icon: Icon(
          AppLanguage.backIcon,
          color: colorOnSurface,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
        tooltip: AppLanguage.tr(ar: 'رجوع', en: 'Back'),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.support_agent_rounded,
                color: colorSecondaryContainer,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLanguage.tr(ar: 'مركز المساعدة والبلاغات', en: 'Help & Complaints Center'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              Text(
                'Help Complaints Support',
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
        GestureDetector(
          onTap: () {
            context.pushPage(const UserProfileScreen());
          },
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorSecondaryContainer.withValues(alpha: 0.4),
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
      ],
    );
  }

  // ==========================================
  // 1. SAFETY WARNING ALERT (EMERGENCY LEAK PROTOCOLS)
  // ==========================================
  Widget _buildEmergencyAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorErrorContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorError.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorError.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: colorError,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.emergency_rounded,
                color: colorOnError,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'تنبيه أمان عاجل', en: 'Urgent Safety Alert'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colorError,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorError,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLanguage.tr(ar: 'طوارئ 911', en: 'Emergency 911'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppLanguage.tr(ar: 'في حال الاشتباه بوجود تسريب غاز كثيف، أغلق محبس الصمام فوراً وتجنب إشعال أي لهب أو قواطع كهربائية، واتصل بالدفاع المدني (911) أو خط طوارئ الغاز المباشر.', en: 'In case of suspected heavy gas leak, close valve immediately, avoid flames or electric switches, and call Civil Defense (911) or gas emergency line.'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: colorOnErrorContainer,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    InkWell(
                      onTap: () => _confirmCall('911', AppLanguage.tr(ar: 'الدفاع المدني والأمن العام', en: 'Civil Defense & Public Security')),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorError,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: colorError.withValues(alpha: 0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.call_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              AppLanguage.tr(ar: 'اتصال بالدفاع المدني 911', en: 'Call Civil Defense 911'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _confirmCall('06500427', AppLanguage.tr(ar: 'طوارئ الغاز المركزية', en: 'Central Gas Emergency')),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorSurfaceLowest,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              size: 15,
                              color: colorError,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              AppLanguage.tr(ar: 'طوارئ الغاز 06-500427', en: 'Gas Emergency 06-500427'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: colorError,
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
    );
  }

  // ==========================================
  // 2. MAIN FILING FORM CARD
  // ==========================================
  Widget _buildFilingFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colorSecondaryFixed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.report_problem_rounded,
                        color: colorOnSecondaryFixed,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.tr(ar: 'تقديم شكوى أو بلاغ جديد', en: 'Submit Complaint or Report'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        AppLanguage.tr(ar: 'يتم الرد والمتابعة الميدانية خلال أقل من 15 دقيقة', en: 'Response & follow-up within 15 minutes'),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: colorSurfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  AppLanguage.tr(ar: 'رقابة الجودة', en: 'Quality Control'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorOnSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Related Order Selector Dropdown
          Text(
            AppLanguage.tr(ar: 'الطلب المرتبط بالشكوى', en: 'Related Order'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorSurfaceContainer, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedOrder,
                isExpanded: true,
                icon: const Icon(Icons.expand_more_rounded, color: colorOnSurfaceVariant),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorOnSurface,
                ),
                items: [
                  DropdownMenuItem(
                    value: '84935',
                    child: Text(AppLanguage.tr(ar: 'طلب #84935 - الكابتن أحمد الخوالدة (منذ 45 دقيقة)', en: 'Order #84935 - Driver Ahmad (45 mins ago)')),
                  ),
                  DropdownMenuItem(
                    value: '84210',
                    child: Text(AppLanguage.tr(ar: 'طلب #84210 - الكابتن سامر العبادي (أمس)', en: 'Order #84210 - Driver Samer (Yesterday)')),
                  ),
                  DropdownMenuItem(
                    value: '83002',
                    child: Text(AppLanguage.tr(ar: 'طلب #83002 - الكابتن عمر حداد (25 شباط)', en: 'Order #83002 - Driver Omar (Feb 25)')),
                  ),
                  DropdownMenuItem(
                    value: 'general',
                    child: Text(AppLanguage.tr(ar: 'بلاغ عام / لا يتعلق بطلب محدد', en: 'General Notice / Not related to order')),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedOrder = val);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Complaint Classification Grid
          Text(
            AppLanguage.tr(ar: 'تصنيف المشكلة', en: 'Issue Category'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 48,
            ),
            itemCount: _complaintTypesList.length,
            itemBuilder: (context, index) {
              final item = _complaintTypesList[index];
              final bool isSelected = _selectedComplaintType == item['id'];

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedComplaintType = item['id'];
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? colorSecondaryFixed : colorSurfaceLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colorSecondaryContainer
                          : colorSurfaceContainer,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 19,
                        color: colorSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item['label'],
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? colorOnSecondaryFixed : colorOnSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Complaint Details Textarea
          Text(
            AppLanguage.tr(ar: 'تفاصيل الشكوى الدقيقة', en: 'Detailed Description'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorSurfaceContainer, width: 1),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _detailsController,
                  maxLines: 4,
                  maxLength: 300,
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    color: colorOnSurface,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        AppLanguage.tr(ar: 'يرجى ذكر المشكلة بالتفصيل (مثال: رائحة عند موضع المحبس، عدم فحص رغوة الصابون، طلب مبلغ إضافي عن الطابق، ...)', en: 'Please describe the issue in detail (e.g. odor near valve, no foam leak test, extra floor fee requested...)'),
                    hintStyle: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      color: colorOutline,
                      height: 1.4,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLanguage.tr(ar: 'الحد الأدنى 20 حرفاً لضمان سرعة التحقق', en: 'Minimum 20 characters for fast verification'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10.5,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                    Text(
                      '$_charCount / 300',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorOutline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Photo & Evidence Attachment
          Text(
            AppLanguage.tr(ar: 'إرفاق صورة توثيقية (اختياري لكن محبذ)', en: 'Attach Photo Evidence (Optional but recommended)'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ..._attachedImages.asMap().entries.map((entry) {
                final int idx = entry.key;
                final String url = entry.value;

                return Expanded(
                  child: Container(
                    height: 90,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorSurfaceContainer),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.network(
                            url,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, color: colorOutline),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: GestureDetector(
                            onTap: () => _removeAttachment(idx),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Add Photo Box
              Expanded(
                child: InkWell(
                  onTap: _addMockPhoto,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorSecondaryContainer.withValues(alpha: 0.3),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_a_photo_rounded,
                          size: 24,
                          color: colorSecondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLanguage.tr(ar: 'إضافة صورة', en: 'Add Photo'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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

          const SizedBox(height: 18),

          // Submit Action & Success Banner
          if (!_isSubmittedSuccess)
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitComplaint,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorSecondaryContainer,
                foregroundColor: colorOnSecondaryFixed,
                disabledBackgroundColor: colorSecondaryContainer.withValues(alpha: 0.5),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: _isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppLanguage.tr(ar: 'جاري الإرسال والتدقيق...', en: 'Submitting & verifying...'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_user_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLanguage.tr(ar: 'إرسال الشكوى لفريق الجودة والمتابعة', en: 'Submit Complaint to Quality Team'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorSurfaceHigh,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colorSecondaryContainer.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: colorSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppLanguage.tr(ar: 'تم استلام بلاغك بنجاح', en: 'Report Received Successfully'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colorSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLanguage.tr(ar: 'رقم التذكرة: $_generatedTicketNumber - يقوم المشرف بالاتصال بك الآن', en: 'Ticket #$_generatedTicketNumber - A supervisor is calling you now'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorOnSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. DIRECT ASSISTANCE CHANNELS
  // ==========================================
  Widget _buildDirectAssistanceChannels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLanguage.tr(ar: 'قنوات المساعدة المباشرة', en: 'Direct Assistance Channels'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorOnSurface,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Live Chat Support Card
            Expanded(
              child: InkWell(
                onTap: () {
                  context.pushPage(const DriverChatScreen());
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorSurfaceLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorSurfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.support_agent_rounded,
                            color: colorOnTertiaryContainer,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLanguage.tr(ar: 'محادثة فورية', en: 'Live Chat'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLanguage.tr(ar: 'متاح 24/7 مع مشرف الدعم', en: 'Available 24/7 with supervisor'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'بدء المحادثة', en: 'Start Chat'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: colorSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            AppLanguage.forwardIcon,
                            size: 14,
                            color: colorSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Toll-Free Jordan Call Center Card
            Expanded(
              child: InkWell(
                onTap: () => _confirmCall('06500427', AppLanguage.tr(ar: 'الرقم الموحد لغاز الأردن', en: 'Jordan Gas Unified Number')),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorSurfaceLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorSecondaryFixed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.phone_in_talk_rounded,
                            color: colorOnSecondaryFixed,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLanguage.tr(ar: 'الرقم الموحد المجاني', en: 'Unified Toll-Free Number'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLanguage.tr(ar: '06-500-GAS (كافة المحافظات)', en: '06-500-GAS (All Governorates)'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 10.5,
                          color: colorOnSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            AppLanguage.tr(ar: 'اتصال مباشر', en: 'Direct Call'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: colorSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            AppLanguage.forwardIcon,
                            size: 14,
                            color: colorSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 4. PAST COMPLAINTS & RESOLUTION HISTORY
  // ==========================================
  Widget _buildPastComplaintsHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLanguage.tr(ar: 'سجل البلاغات والشكاوى السابقة', en: 'Past Reports & Complaints'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
            Text(
              AppLanguage.tr(ar: 'بلاغ 1 مكتمل', en: '1 Completed Report'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colorSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Resolved Complaint Card
        Container(
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Status Badge (Responsive without overflow)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Text(
                              AppLanguage.tr(ar: 'شكوى رقم #C-2041', en: 'Complaint #C-2041'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: colorOnSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorSurfaceHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLanguage.tr(ar: 'استفسار عن فحص الصمام', en: 'Valve Inquiry'),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: colorOnSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLanguage.tr(ar: 'تاريخ البلاغ: 18 شباط 2025 • مرتبط بطلب #81092', en: 'Date: Feb 18, 2025 • Order #81092'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            color: colorOutline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorSurfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: colorSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLanguage.tr(ar: 'تمت المعالجة بنجاح', en: 'Resolved'),
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
              ),

              const SizedBox(height: 12),

              // Officer Note Box
              Container(
                padding: const EdgeInsets.all(12),
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
                          Icons.verified_rounded,
                          size: 16,
                          color: colorSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLanguage.tr(ar: 'ملاحظة مسؤول الجودة (م. رامي المجالي):', en: 'Quality Supervisor Note (Eng. Rami Al-Majali):'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colorOnSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLanguage.tr(ar: 'تم زيارة الموقع من قِبل فني السلامة واستبدال مانع التسريب (الجلدة) فوراً دون أي مقابل، والتأكد من ضغط المنظم باستخدام جهاز الفحص الرقمي.', en: 'Safety technician visited site and replaced leak gasket free of charge, regulator pressure verified with digital tester.'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11.5,
                        height: 1.45,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Resolution & Token of Apology
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: colorSecondaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.redeem_rounded,
                              size: 18,
                              color: colorOnSecondaryFixed,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLanguage.tr(ar: 'تعويض رمزي معتمد', en: 'Courtesy Compensation'),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: colorOnSurface,
                                ),
                              ),
                              Text(
                                AppLanguage.tr(ar: 'خصم 2.00 د.أ على طلب التبديل القادم', en: '2.00 JOD discount on your next exchange'),
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
                  const SizedBox(width: 8),
                  Text(
                    AppLanguage.tr(ar: '2.00- د.أ', en: '-2.00 JOD'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: colorSecondary,
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

  // ==========================================
  // HELPERS
  // ==========================================
  void _confirmCall(String number, String title) {
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
                AppLanguage.tr(ar: 'الاتصال بـ $title', en: 'Call $title'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            AppLanguage.tr(ar: 'هل ترغب في الاتصال بالرقم $number الآن؟', en: 'Do you want to call $number now?'),
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
                    backgroundColor: const Color(0xFF131B2E),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorSecondaryContainer,
                foregroundColor: colorOnSecondaryFixed,
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
}
