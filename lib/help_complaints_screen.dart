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
      'label': 'تأخر وصول الكابتن',
      'icon': Icons.schedule_rounded,
    },
    {
      'id': 'cylinder',
      'label': 'عيوب الأسطوانة والصمام',
      'icon': Icons.propane_tank_rounded,
    },
    {
      'id': 'price',
      'label': 'خلاف السعر أو الفكة',
      'icon': Icons.payments_outlined,
    },
    {
      'id': 'driver',
      'label': 'سلوك السائق أو الأمان',
      'icon': Icons.person_off_outlined,
    },
    {
      'id': 'not_received',
      'label': 'لم يتم استلام الطلب',
      'icon': Icons.wrong_location_outlined,
    },
    {
      'id': 'other',
      'label': 'موضوع آخر',
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
            'يرجى كتابة تفاصيل المشكلة (10 أحرف على الأقل) للمتابعة الدقيقة.',
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
          'تم حذف الصورة المرفقة',
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
        icon: const Icon(
          Icons.arrow_forward_rounded,
          color: colorOnSurface,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
        tooltip: 'رجوع',
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
                'مركز المساعدة والبلاغات',
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
                      'تنبيه أمان عاجل',
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
                        'طوارئ 911',
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
                  'في حال الاشتباه بوجود تسريب غاز كثيف، أغلق محبس الصمام فوراً وتجنب إشعال أي لهب أو قواطع كهربائية، واتصل بالدفاع المدني (911) أو خط طوارئ الغاز المباشر.',
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
                      onTap: () => _confirmCall('911', 'الدفاع المدني والأمن العام'),
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
                              'اتصال بالدفاع المدني 911',
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
                      onTap: () => _confirmCall('06500427', 'طوارئ الغاز المركزية'),
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
                              'طوارئ الغاز 06-500427',
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
                        'تقديم شكوى أو بلاغ جديد',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                      Text(
                        'يتم الرد والمتابعة الميدانية خلال أقل من 15 دقيقة',
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
                  'رقابة الجودة',
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
            'الطلب المرتبط بالشكوى',
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
                items: const [
                  DropdownMenuItem(
                    value: '84935',
                    child: Text('طلب #84935 - الكابتن أحمد الخوالدة (منذ 45 دقيقة)'),
                  ),
                  DropdownMenuItem(
                    value: '84210',
                    child: Text('طلب #84210 - الكابتن سامر العبادي (أمس)'),
                  ),
                  DropdownMenuItem(
                    value: '83002',
                    child: Text('طلب #83002 - الكابتن عمر حداد (25 شباط)'),
                  ),
                  DropdownMenuItem(
                    value: 'general',
                    child: Text('بلاغ عام / لا يتعلق بطلب محدد'),
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
            'تصنيف المشكلة',
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
            'تفاصيل الشكوى الدقيقة',
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
                        'يرجى ذكر المشكلة بالتفصيل (مثال: رائحة عند موضع المحبس، عدم فحص رغوة الصابون، طلب مبلغ إضافي عن الطابق، ...)',
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
                      'الحد الأدنى 20 حرفاً لضمان سرعة التحقق',
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
            'إرفاق صورة توثيقية (اختياري لكن محبذ)',
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
                          'إضافة صورة',
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
                          'جاري الإرسال والتدقيق...',
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
                          'إرسال الشكوى لفريق الجودة والمتابعة',
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
                        'تم استلام بلاغك بنجاح',
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
                    'رقم التذكرة: $_generatedTicketNumber - يقوم المشرف بالاتصال بك الآن',
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
          'قنوات المساعدة المباشرة',
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
                        'محادثة فورية',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'متاح 24/7 مع مشرف الدعم',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOnSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'بدء المحادثة',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
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
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Toll-Free Jordan Call Center Card
            Expanded(
              child: InkWell(
                onTap: () => _confirmCall('06500427', 'الرقم الموحد لغاز الأردن'),
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
                        'الرقم الموحد المجاني',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorOnSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '06-500-GAS (كافة المحافظات)',
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
                            'اتصال مباشر',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12,
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
              'سجل البلاغات والشكاوى السابقة',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
            Text(
              'بلاغ 1 مكتمل',
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
              // Header & Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'شكوى رقم #C-2041',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: colorOnSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorSurfaceHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'استفسار عن فحص الصمام',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colorOnSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'تاريخ البلاغ: 18 شباط 2025 • مرتبط بطلب #81092',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          color: colorOutline,
                        ),
                      ),
                    ],
                  ),
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
                          'تمت المعالجة بنجاح',
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
                          'ملاحظة مسؤول الجودة (م. رامي المجالي):',
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
                      'تم زيارة الموقع من قِبل فني السلامة واستبدال مانع التسريب (الجلدة) فوراً دون أي مقابل، والتأكد من ضغط المنظم باستخدام جهاز الفحص الرقمي.',
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
                  Row(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تعويض رمزي معتمد',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: colorOnSurface,
                            ),
                          ),
                          Text(
                            'خصم 2.00 د.أ على طلب التبديل القادم',
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
                    '2.00- د.أ',
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
                'الاتصال بـ $title',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'هل ترغب في الاتصال بالرقم $number الآن؟',
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
                'اتصال الآن',
                style: GoogleFonts.ibmPlexSansArabic(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
