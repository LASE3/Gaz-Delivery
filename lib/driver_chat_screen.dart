// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_language.dart';
import 'page_transitions.dart';
import 'permission_helper.dart';
import 'driver_profile_screen.dart';

class DriverChatScreen extends StatefulWidget {
  final String? driverName;
  final String plateNumber;
  final double rating;
  final String? orderDescription;
  final String? orderPrice;
  final String? etaText;

  const DriverChatScreen({
    super.key,
    this.driverName,
    this.plateNumber = '42-8921',
    this.rating = 4.9,
    this.orderDescription,
    this.orderPrice,
    this.etaText,
  });

  String get effectiveDriverName =>
      driverName ??
      AppLanguage.tr(
        ar: 'الكابتن أحمد الخوالدة',
        en: 'Captain Ahmad Al-Khawaldeh',
      );

  String get effectiveOrderDescription =>
      orderDescription ??
      AppLanguage.tr(
        ar: 'طلبك: أسطوانة غاز منزلي 12.5 كغ (استبدال)',
        en: 'Order: Domestic 12.5kg Gas Cylinder (Exchange)',
      );

  String get effectiveOrderPrice =>
      orderPrice ?? AppLanguage.tr(ar: '7.00 د.أ', en: '7.00 JOD');

  String get effectiveEtaText =>
      etaText ??
      AppLanguage.tr(
        ar: 'في الطريق إليك • على بعد 6 دقائق (شارع وصفي التل)',
        en: 'On the way • 6 mins away (Wasfi Al-Tal St.)',
      );

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

// Model for chat messages
class _ChatMessage {
  final String id;
  final String text;
  final String time;
  final bool isFromDriver;
  final bool isFromSupport;
  final bool isCustomer;
  final String? imagePath;
  final bool isInfoCard;
  final String? infoTitle;
  final String? infoSubtitle;
  final IconData? infoIcon;

  _ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    this.isFromDriver = false,
    this.isFromSupport = false,
    this.isCustomer = false,
    this.imagePath,
    this.isInfoCard = false,
    this.infoTitle,
    this.infoSubtitle,
    this.infoIcon,
  });
}

class _DriverChatScreenState extends State<DriverChatScreen> {
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
  static const Color colorOnPrimary = Color(0xFFFFFFFF);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorOnTertiaryFixedVariant = Color(0xFF004B73);

  // Active Tab: 0 = Driver Chat (محادثة الكابتن), 1 = Customer Care (خدمة العملاء والدعم)
  int _activeTab = 0;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // Driver chat messages list
  late List<_ChatMessage> _driverMessages;

  // Customer care messages list
  late List<_ChatMessage> _supportMessages;

  // Quick reply chips for driver chat
  List<String> get _driverQuickChips => AppLanguage.isArabic
      ? [
          'أنا بالبناية الآن 🏢',
          'يرجى رن الجرس عند الوصول 🔔',
          'أنا نازل استلم الأسطوانة 🚶‍♂️',
          'المبلغ كاش جاهز 💵',
          'فحص الصمام مشمول؟ 🛡️',
        ]
      : [
          'I am at the building now 🏢',
          'Please ring the bell upon arrival 🔔',
          'Coming down to receive cylinder 🚶‍♂️',
          'Cash is ready 💵',
          'Is valve check included? 🛡️',
        ];

  // Quick reply chips for customer support
  List<String> get _supportQuickChips => AppLanguage.isArabic
      ? [
          'استفسار عن موعد التوصيل ⏱️',
          'تغيير موقع أو رقم الهاتف 📍',
          'طلب فحص صمام أمان إضافي 🔍',
          'تقديم شكوى أو ملاحظة 💬',
          'تأكيد الدفع والاستلام 🧾',
        ]
      : [
          'Inquire about delivery time ⏱️',
          'Change address or phone number 📍',
          'Request extra valve inspection 🔍',
          'Submit a complaint or note 💬',
          'Confirm payment & receipt 🧾',
        ];

  @override
  void initState() {
    super.initState();
    _initChatHistory();
  }

  void _initChatHistory() {
    _driverMessages = [
      _ChatMessage(
        id: '1',
        text: AppLanguage.tr(
          ar: 'السلام عليكم، أنا بالطريق لشارع وصفي التل. هل المصعد يعمل لنقل الأسطوانة؟',
          en: 'Hello, I am on Wasfi Al-Tal St. Is the elevator working for the cylinder?',
        ),
        time: AppLanguage.tr(ar: '02:30 م', en: '02:30 PM'),
        isFromDriver: true,
      ),
      _ChatMessage(
        id: '2',
        text: AppLanguage.tr(
          ar: 'أهلاً كابتن، نعم المصعد يعمل، العمارة 42 الطابق الثالث شقة 6.',
          en: 'Hello Captain, yes the elevator is working. Building 42, 3rd floor, Apt 6.',
        ),
        time: AppLanguage.tr(ar: '02:31 م', en: '02:31 PM'),
        isCustomer: true,
      ),
      _ChatMessage(
        id: '3',
        text: AppLanguage.tr(
          ar: 'تمام، معي جهاز فحص تسريب الغاز لتركيبها وفحص الصمام مجاناً 👍',
          en: 'Got it, I have a gas leak detector to install and check the valve for free 👍',
        ),
        time: AppLanguage.tr(ar: '02:32 م', en: '02:32 PM'),
        isFromDriver: true,
      ),
      _ChatMessage(
        id: '4',
        text: '',
        time: AppLanguage.tr(ar: '02:32 م', en: '02:32 PM'),
        isInfoCard: true,
        infoTitle: AppLanguage.tr(
          ar: 'خدمة فحص الأمان والسلامة الذكية',
          en: 'Smart Safety Inspection Service',
        ),
        infoSubtitle: AppLanguage.tr(
          ar: 'سيقوم الكابتن بفحص جلدة الغاز الإلكتروني والتأكد من ضغط المنظم',
          en: 'Captain will inspect electronic valve seal and regulator pressure',
        ),
        infoIcon: Icons.gas_meter_rounded,
      ),
    ];

    _supportMessages = [
      _ChatMessage(
        id: 's1',
        text: AppLanguage.tr(
          ar: 'مرحباً بك في خدمة عملاء غاز الأردن! 👋\nنحن هنا لمساعدتك على مدار الساعة بخصوص طلباتك واستفسارات السلامة.',
          en: 'Welcome to Jordan Gas Support! 👋\nWe are here 24/7 to assist with orders and safety inquiries.',
        ),
        time: AppLanguage.tr(ar: '02:15 م', en: '02:15 PM'),
        isFromSupport: true,
      ),
      _ChatMessage(
        id: 's2',
        text: AppLanguage.tr(
          ar: 'طلبك الحالي قيد التوصيل مع الكابتن أحمد الخوالدة، هل تواجه أي صعوبة أو تحتاج لمساعدة في تحديد العنوان؟',
          en: 'Your order is on the way with Captain Ahmad Al-Khawaldeh. Do you need any assistance?',
        ),
        time: AppLanguage.tr(ar: '02:16 م', en: '02:16 PM'),
        isFromSupport: true,
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? (AppLanguage.isArabic ? 'م' : 'PM') : (AppLanguage.isArabic ? 'ص' : 'AM');
    final timeStr = '$hour:$minute $period';

    final userMsg = _ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      time: timeStr,
      isCustomer: true,
    );

    setState(() {
      if (_activeTab == 0) {
        _driverMessages.add(userMsg);
      } else {
        _supportMessages.add(userMsg);
      }
    });

    _textController.clear();
    _scrollToBottom();

    // Trigger realistic automated responses
    if (_activeTab == 0) {
      _simulateDriverResponse(text);
    } else {
      _simulateSupportResponse(text);
    }
  }

  void _simulateDriverResponse(String userText) {
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;

      String reply = AppLanguage.tr(
        ar: 'وصلت رسالتك أخي الكريم، أنا قريب جداً منك 🚚',
        en: 'Got your message! I am very close to your location 🚚',
      );
      final lower = userText.toLowerCase();
      if (userText.contains('بناية') || userText.contains('نازل') || lower.contains('building') || lower.contains('down')) {
        reply = AppLanguage.tr(
          ar: 'ممتاز، أنا وصلت مدخل العمارة ومعي الأسطوانة المفحوصة 👍',
          en: 'Great, I have arrived at the entrance with the tested cylinder 👍',
        );
      } else if (userText.contains('جرس') || lower.contains('bell') || lower.contains('ring')) {
        reply = AppLanguage.tr(
          ar: 'تم، سأقوم برن الجرس فور الصعود للطابق الثالث.',
          en: 'Will do, I will ring the bell as soon as I head up.',
        );
      } else if (userText.contains('كاش') || userText.contains('المبلغ') || lower.contains('cash') || lower.contains('change')) {
        reply = AppLanguage.tr(
          ar: 'شكراً لك، الفكة متوفرة معي دائماً.',
          en: 'Thank you, exact change is always available.',
        );
      } else if (userText.contains('صمام') || userText.contains('فحص') || lower.contains('valve') || lower.contains('check')) {
        reply = AppLanguage.tr(
          ar: 'أكيد، فحص الصمام الإلكتروني ومانع التسريب مجاني مئة بالمئة مع التركيب.',
          en: 'Sure thing, electronic valve inspection and leak check is 100% free with installation.',
        );
      }

      final now = DateTime.now();
      final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final minute = now.minute.toString().padLeft(2, '0');
      final period = now.hour >= 12 ? (AppLanguage.isArabic ? 'م' : 'PM') : (AppLanguage.isArabic ? 'ص' : 'AM');
      final timeStr = '$hour:$minute $period';

      setState(() {
        _driverMessages.add(
          _ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: reply,
            time: timeStr,
            isFromDriver: true,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _simulateSupportResponse(String userText) {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      String reply = AppLanguage.tr(
        ar: 'شكراً لتواصلك مع مركز خدمة العملاء. تم تسجيل استفسارك وسنتابعه فوراً مع فريق العمليات.',
        en: 'Thank you for contacting customer support. Your inquiry has been noted and followed up with dispatch.',
      );
      final lower = userText.toLowerCase();
      if (userText.contains('موعد') || userText.contains('توصيل') || lower.contains('time') || lower.contains('delivery')) {
        reply = AppLanguage.tr(
          ar: 'الكابتن أحمد في منطقتك حالياً ومتبقي حوالي 5 دقائق للوصول. سنبقيك على اطلاع دائم.',
          en: 'Captain Ahmad is in your neighborhood, approximately 5 mins away. We will keep you updated.',
        );
      } else if (userText.contains('موقع') || userText.contains('هاتف') || lower.contains('address') || lower.contains('phone') || lower.contains('location')) {
        reply = AppLanguage.tr(
          ar: 'تم تحديث بيانات التوصيل وإرسال إشعار فوري لسائق الشاحنة المسؤول عن منطقتك.',
          en: 'Delivery details have been updated and sent directly to your area truck captain.',
        );
      } else if (userText.contains('شكوى') || userText.contains('ملاحظة') || lower.contains('complaint') || lower.contains('issue')) {
        reply = AppLanguage.tr(
          ar: 'نعتذر عن أي إزعاج، تم تحويل ملاحظتك لمدير الجودة وسيقوم بالاتصال بك خلال دقائق.',
          en: 'We apologize for any inconvenience. Your note has been escalated to our quality manager.',
        );
      }

      final now = DateTime.now();
      final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final minute = now.minute.toString().padLeft(2, '0');
      final period = now.hour >= 12 ? (AppLanguage.isArabic ? 'م' : 'PM') : (AppLanguage.isArabic ? 'ص' : 'AM');
      final timeStr = '$hour:$minute $period';

      setState(() {
        _supportMessages.add(
          _ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: reply,
            time: timeStr,
            isFromSupport: true,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  Future<void> _sendPhotoAttachment() async {
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
                  ar: 'إرفاق صورة للمحادثة',
                  en: 'Attach Photo to Chat',
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
                    ar: 'تصوير صمام الغاز أو مدخل البناية',
                    en: 'Photo of valve seal or building entrance',
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
                    ar: 'اختيار من معرض الصور',
                    en: 'Choose from Gallery',
                  ),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorOnSurface,
                  ),
                ),
                subtitle: Text(
                  AppLanguage.tr(
                    ar: 'إرفاق إيصال أو صورة مخزنة مسبقاً',
                    en: 'Attach receipt or previously saved photo',
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

    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? (AppLanguage.isArabic ? 'م' : 'PM') : (AppLanguage.isArabic ? 'ص' : 'AM');
    final timeStr = '$hour:$minute $period';

    final photoMsg = _ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: option == 1
          ? AppLanguage.tr(
              ar: '📷 تم التقاط وإرفاق صورة لمدخل البناية لتسهيل الوصول',
              en: '📷 Captured and attached photo of building entrance',
            )
          : AppLanguage.tr(
              ar: '🖼️ تم إرفاق صورة من المعرض لتوثيق تفاصيل الصمام',
              en: '🖼️ Attached photo from gallery for valve verification',
            ),
      time: timeStr,
      isCustomer: true,
      imagePath:
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&auto=format&fit=crop&q=80',
    );

    setState(() {
      if (_activeTab == 0) {
        _driverMessages.add(photoMsg);
      } else {
        _supportMessages.add(photoMsg);
      }
    });

    _scrollToBottom();
  }

  void _showSafetyBadgeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
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
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: colorSurfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF004B73),
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLanguage.tr(ar: 'بروتوكول السلامة وفحص الأمان المجاني', en: 'Safety Protocol & Free Inspection'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: colorOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLanguage.tr(ar: 'جميع كباتن غاز الأردن مزودون بأجهزة كشف تسريب غاز إلكترونية دقيقة ومعتمدة من مصفاة البترول والدفاع المدني. يقوم الكابتن بتركيب الأسطوانة وفحص الصمام الجلدي والتأكد من ضغط المنظم دون أي تكلفة إضافية.', en: 'All Jordan Gas captains are equipped with calibrated digital gas leak detectors certified by JPRC and Civil Defense. Captain installs cylinder and tests regulator at zero extra charge.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  color: colorOnSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecondaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLanguage.tr(ar: 'فهمت ذلك، شكراً', en: 'Understood, Thanks'),
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

  @override
  Widget build(BuildContext context) {
    final activeMessages = _activeTab == 0 ? _driverMessages : _supportMessages;
    final activeQuickChips =
        _activeTab == 0 ? _driverQuickChips : _supportQuickChips;

    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, langCode, child) {
        return Directionality(
          textDirection: AppLanguage.direction,
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
                          AppLanguage.isArabic
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: colorOnSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // GAS Flame Logo
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colorSecondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (_activeTab == 0) {
                            context.pushPage(const DriverProfileScreen());
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeTab == 0
                                  ? AppLanguage.tr(ar: 'محادثة الكابتن', en: 'Driver Live Chat')
                                  : AppLanguage.tr(ar: 'خدمة العملاء والدعم', en: 'Customer Support'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colorOnSurface,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              _activeTab == 0
                                  ? AppLanguage.tr(ar: 'متصل الآن • في الطريق', en: 'Online • On The Way')
                                  : AppLanguage.tr(ar: 'مركز المساعدة 24/7', en: 'Help Center 24/7'),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11,
                                color: colorSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: InkWell(
                      onTap: () {
                        context.pushPage(const DriverProfileScreen());
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colorSecondaryContainer, width: 1.5),
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
        body: Column(
          children: [
            // Mode Switcher (Driver Chat vs Customer Support)
            _buildModeSwitcher(),

            // Driver Radar Card or Support Help Banner
            if (_activeTab == 0) _buildDriverRadarCard() else _buildSupportHeaderCard(),

            // Safety Order Summary Bar
            _buildOrderSummaryBar(),

            // Message Stream
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: activeMessages.length + 1, // +1 for date divider
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildDateDivider();
                  }
                  final msg = activeMessages[index - 1];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            // Quick Reply Chips Bar
            _buildQuickChipsBar(activeQuickChips),

            // Chat Input Box
            _buildInputBar(),
          ],
        ),
      ),
    );
      },
    );
  }

  // Segmented Mode Switcher (Driver vs Support)
  Widget _buildModeSwitcher() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colorSurfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _activeTab = 0;
                });
                _scrollToBottom();
              },
              borderRadius: BorderRadius.circular(9),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: _activeTab == 0 ? colorSurfaceLowest : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: _activeTab == 0
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
                      Icons.local_shipping_outlined,
                      size: 16,
                      color: _activeTab == 0 ? colorSecondaryContainer : colorOnSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLanguage.tr(ar: 'الكابتن الموصّل', en: 'Delivery Captain'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: _activeTab == 0 ? FontWeight.bold : FontWeight.w500,
                        color: _activeTab == 0 ? colorOnSurface : colorOnSurfaceVariant,
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
                  _activeTab = 1;
                });
                _scrollToBottom();
              },
              borderRadius: BorderRadius.circular(9),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: _activeTab == 1 ? colorSurfaceLowest : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: _activeTab == 1
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
                      Icons.support_agent_rounded,
                      size: 16,
                      color: _activeTab == 1 ? colorSecondaryContainer : colorOnSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLanguage.tr(ar: 'خدمة العملاء (24/7)', en: 'Customer Care (24/7)'),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: _activeTab == 1 ? FontWeight.bold : FontWeight.w500,
                        color: _activeTab == 1 ? colorOnSurface : colorOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Driver Radar Card
  Widget _buildDriverRadarCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      padding: const EdgeInsets.all(12),
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
          // Driver info + Call button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  context.pushPage(const DriverProfileScreen());
                },
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 46,
                              height: 46,
                              color: colorSurfaceContainer,
                              child: const Icon(Icons.person, color: colorSecondary),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: colorSecondaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
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
                              widget.effectiveDriverName,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: colorOnSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified_rounded,
                              color: colorSecondaryContainer,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: colorSurfaceHigh,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.plateNumber,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colorOnSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('•', style: TextStyle(color: colorOnSurfaceVariant)),
                            const SizedBox(width: 6),
                            const Icon(Icons.star_rounded,
                                size: 15, color: colorSecondaryContainer),
                            const SizedBox(width: 2),
                            Text(
                              widget.rating.toString(),
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 11,
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
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone_in_talk,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            AppLanguage.tr(ar: 'جاري الاتصال بالكابتن أحمد: 0790000000', en: 'Calling Captain Ahmad: 0790000000'),
                            style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                          ),
                        ],
                      ),
                      backgroundColor: colorPrimaryContainer,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorSecondaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorSecondaryContainer.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.phone_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ETA Ticker + Safety Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                      Expanded(
                        child: Text(
                          widget.effectiveEtaText,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorOnSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: _showSafetyBadgeDialog,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorSurfaceHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 13,
                          color: colorOnTertiaryFixedVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLanguage.tr(ar: 'فحص أمان مجاني', en: 'Free Safety Check'),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorOnTertiaryFixedVariant,
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

  // 2. Customer Support Header Card
  Widget _buildSupportHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorSurfaceLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.headset_mic_rounded,
                  color: colorSecondaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.tr(ar: 'مركز رعاية عملاء غاز الأردن', en: 'Jordan Gas Customer Care Center'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLanguage.tr(ar: 'متاح للمساعدة الفورية وتعديل الطلبات', en: 'Available for instant help and order updates'),
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
                    AppLanguage.tr(ar: 'الخط الساخن لخدمة العملاء: 065000000', en: 'Customer Care Hotline: 065000000'),
                    style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorSurfaceLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.call, size: 14, color: colorSecondary),
                  const SizedBox(width: 4),
                  Text(
                    AppLanguage.tr(ar: 'اتصال مباشر', en: 'Direct Call'),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Order Summary Bar
  Widget _buildOrderSummaryBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorSurfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.propane_tank_outlined,
                size: 18,
                color: colorSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                widget.effectiveOrderDescription,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorOnSurface,
                ),
              ),
            ],
          ),
          Text(
            widget.effectiveOrderPrice,
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Date Divider
  Widget _buildDateDivider() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: colorSurfaceHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          AppLanguage.tr(ar: 'اليوم • صمام الأمان مشمول', en: 'Today • Safety Valve Included'),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 11,
            color: colorOnSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Message Bubble (Incoming vs Outgoing)
  Widget _buildMessageBubble(_ChatMessage msg) {
    if (msg.isInfoCard) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorSurfaceLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorSurfaceHighest),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorSurfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                msg.infoIcon ?? Icons.gas_meter_rounded,
                color: colorOnSurface,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.infoTitle ?? '',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    msg.infoSubtitle ?? '',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11,
                      color: colorOnSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (msg.isCustomer) {
      // Outgoing Message (Customer / User)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(bottom: 6, left: 6),
              decoration: const BoxDecoration(
                color: colorSecondaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorPrimaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.imagePath != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              msg.imagePath!,
                              width: 180,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          msg.text,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13,
                            color: colorOnPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          msg.time,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 10,
                            color: colorOnSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.done_all_rounded,
                          size: 14,
                          color: colorSecondaryContainer,
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
    } else {
      // Incoming Message (Driver or Support Agent)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorSurfaceLowest,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg.text,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13,
                        color: colorOnSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      msg.time,
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 10,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            ClipOval(
              child: msg.isFromSupport
                  ? Container(
                      width: 28,
                      height: 28,
                      color: colorSurfaceLow,
                      child: const Icon(
                        Icons.support_agent_rounded,
                        color: colorSecondaryContainer,
                        size: 18,
                      ),
                    )
                  : Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD4vH1Mu4_-cxidZyo9Wqap8HyVTTpULPFTE0pv40iQfB_UPmQoYRaO2Msub-Fv7NEunFy3pmC0uYNTaL1WUZ1xKYrbhttBWmhr2sHuxSkgaGP-eNvTO4QutbkLBRUPCynutbwuTUNj5gAPJufYPJnVRin-myy2GhRdYvYze-sP6R2EB2qHNf2vxD1dWPDqv_5tbFnM6iPnCzPVOeGLrGp4nD7nfWR7Mb7Cp-7jERwW05hsc8CYBOSw1A',
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 28,
                        height: 28,
                        color: colorSurfaceContainer,
                        child: const Icon(Icons.person, size: 16),
                      ),
                    ),
            ),
          ],
        ),
      );
    }
  }

  // Quick Reply Chips Bar
  Widget _buildQuickChipsBar(List<String> chips) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: chips.map((chipText) {
            return Container(
              margin: const EdgeInsetsDirectional.only(end: 8),
              child: InkWell(
                onTap: () => _sendMessage(chipText),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: colorSurfaceLowest,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    chipText,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorOnSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Bottom Input Station
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest.withValues(alpha: 0.96),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Camera / Door Photo Trigger
            InkWell(
              onTap: _sendPhotoAttachment,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colorSurfaceHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: colorOnSurface,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // TextField
            Expanded(
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: colorSurfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      color: colorOnSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: _activeTab == 0
                          ? AppLanguage.tr(ar: 'اكتب رسالتك للكابتن...', en: 'Type a message to captain...')
                          : AppLanguage.tr(ar: 'اكتب استفسارك لخدمة العملاء...', en: 'Type a query to customer support...'),
                      hintStyle: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13,
                        color: colorOnSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send Button
            InkWell(
              onTap: () => _sendMessage(_textController.text),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colorSecondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorSecondaryContainer.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
