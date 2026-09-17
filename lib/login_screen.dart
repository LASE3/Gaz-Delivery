// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Theme Color Palette
  static const Color colorBackground = Color(0xFFF8F9FF);
  static const Color colorSurfaceLowest = Color(0xFFFFFFFF);
  static const Color colorSurfaceLow = Color(0xFFEFF4FF);
  static const Color colorSurfaceContainer = Color(0xFFE5EEFF);
  static const Color colorSurfaceHighest = Color(0xFFD3E4FE);

  static const Color colorOnSurface = Color(0xFF0B1C30);
  static const Color colorOnSurfaceVariant = Color(0xFF565E74);
  static const Color colorPrimaryContainer = Color(0xFF131B2E);

  static const Color colorSecondary = Color(0xFFA73A00);
  static const Color colorSecondaryContainer = Color(0xFFFD651E);
  static const Color colorOutlineVariant = Color(0xFFC6C6CD);

  // Auth Method: 'phone' vs 'email'
  String _authMethod = 'phone';

  // Text Controllers
  final TextEditingController _phoneController =
      TextEditingController(text: '0791234567');
  final TextEditingController _emailController =
      TextEditingController(text: 'name@example.jo');

  // OTP Controllers & Focus Nodes
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (index) => FocusNode());

  // OTP State
  bool _isOtpSent = false;
  int _countdownSeconds = 45;
  Timer? _countdownTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Default initial preview code matching HTML
    _otpControllers[0].text = '4';
    _otpControllers[1].text = '8';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _phoneController.dispose();
    _emailController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _countdownSeconds = 45;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _handleSendOtp() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOtpSent = true;
        });
        _startCountdown();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mark_email_read_outlined,
                    color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'تم إرسال رمز التحقق إلى ${_authMethod == 'phone' ? _phoneController.text : _emailController.text}',
                  style: GoogleFonts.ibmPlexSansArabic(fontSize: 13),
                ),
              ],
            ),
            backgroundColor: colorPrimaryContainer,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _handleLoginSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Brand & Mascot Hero Banner
                _buildHeroBanner(),
                const SizedBox(height: 16),

                // 2. Main Authentication Card
                _buildAuthCard(),
                const SizedBox(height: 16),

                // 3. Social Logins Section
                _buildSocialLogins(),
                const SizedBox(height: 16),

                // 4. Sign Up Redirection
                _buildSignUpRedirection(),
                const SizedBox(height: 16),

                // 5. Jordan Petroleum Refinery Trust Badge
                _buildRefineryTrustBadge(),
                const SizedBox(height: 12),

                // 6. Security Metric Footer Card
                _buildSecurityFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. BRAND & MASCOT HERO BANNER
  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLow,
        borderRadius: BorderRadius.circular(20),
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
          // Header Row with Logo & Area Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorSecondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: colorSecondaryContainer.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'غاز الأردن',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'توصيل سريع وموثوق',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorSurfaceHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFF004B73),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'عمان والزرقاء',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF004B73),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Hero Title, Subtitle & 3D Mascot Illustration
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'دفء بيتك بضغطة زر',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: colorOnSurface,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'خدمة تبديل وتوصيل أسطوانات الغاز المنزلية فوراً إلى باب منزلك مع فحص الصمام المعتمد.',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        color: colorOnSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 86,
                height: 86,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuClY2HNIr7buS7cBAyX7rBUMqY1XMZuLmed02efCeJTpAWmLKbO7RUcf-pADm37xYWV_Ox7Qgt9vOMdck2MD8p9cOQNlmlKjyzgmQm50oPfavBmmSHaa-rMzPCTli_ObuhrTo09MVuJ9P7E3FGh_sz4yP-0BvQ7ryehc5GCFHUJgLzrJbThYQoXOHVLHMEtsdTDw44MVUzPYnJW-PmsKDtoruFZ1ayGWAf75pQE9Ihg6iIUqaKclZF2cw',
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.local_fire_department,
                    size: 64,
                    color: colorSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. MAIN AUTH CARD
  Widget _buildAuthCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segmented Switcher (Phone vs Email)
          Container(
            padding: const EdgeInsets.all(4),
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
                        _authMethod = 'phone';
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _authMethod == 'phone'
                            ? colorSurfaceLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _authMethod == 'phone'
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
                        'رقم الهاتف',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: _authMethod == 'phone'
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: _authMethod == 'phone'
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
                        _authMethod = 'email';
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _authMethod == 'email'
                            ? colorSurfaceLowest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _authMethod == 'email'
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
                        'البريد الإلكتروني',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13,
                          fontWeight: _authMethod == 'email'
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: _authMethod == 'email'
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
          const SizedBox(height: 16),

          // Input Section (Phone vs Email)
          if (_authMethod == 'phone') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'رقم الهاتف المحمول',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorOnSurface,
                  ),
                ),
                Text(
                  'مثال: 07XXXXXXXX',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 11,
                    color: colorOnSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Country Code with Jordan Flag
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colorSurfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildJordanFlag(),
                      const SizedBox(width: 6),
                      Text(
                        '+962',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Phone TextField
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: colorSurfaceLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: '07 9123 4567',
                          hintStyle: GoogleFonts.ibmPlexSansArabic(
                            color: colorOutlineVariant,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'البريد الإلكتروني المسجل',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorOnSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorSurfaceLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 15,
                    color: colorOnSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'name@example.jo',
                    hintStyle: GoogleFonts.ibmPlexSansArabic(
                      color: colorOutlineVariant,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Primary Action Button (Continue / Send OTP)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : (_isOtpSent ? _handleLoginSuccess : _handleSendOtp),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorSecondaryContainer,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: colorSecondaryContainer.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
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
                        Text(
                          _isOtpSent
                              ? 'تسجيل الدخول ومتابعة الطلب'
                              : 'متابعة / إرسال رمز التحقق',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                      ],
                    ),
            ),
          ),

          // OTP Toast & Countdown Badge
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const SizedBox(width: 8),
                    Text(
                      'رمز التحقق جاهز للإرسال بـ SMS',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11,
                        color: colorOnSurface,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: colorSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _countdownSeconds > 0
                          ? 'إعادة الإرسال: 00:${_countdownSeconds.toString().padLeft(2, '0')}'
                          : 'يمكنك طلب رمز جديد',
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
          ),

          // 4-Digit OTP Input Section
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorSurfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أدخل الرمز المكون من 4 أرقام',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _startCountdown();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تمت إعادة إرسال رمز التحقق بنجاح',
                              style: GoogleFonts.ibmPlexSansArabic(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: colorPrimaryContainer,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        'إعادة إرسال الآن',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: colorSurfaceLowest,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: colorOnSurface,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          hintText: '•',
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && index < 3) {
                            _otpFocusNodes[index + 1].requestFocus();
                          } else if (val.isEmpty && index > 0) {
                            _otpFocusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. SOCIAL LOGINS SECTION
  Widget _buildSocialLogins() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(color: colorSurfaceHighest, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'أو سجل عبر',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12,
                  color: colorOnSurfaceVariant,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: colorSurfaceHighest, thickness: 1),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Google Login
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _handleLoginSuccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSurfaceLowest,
                    foregroundColor: colorOnSurface,
                    elevation: 1,
                    shadowColor: Colors.black.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                    width: 18,
                    height: 18,
                    errorBuilder: (c, e, s) => const Icon(Icons.g_mobiledata, size: 22),
                  ),
                  label: Text(
                    'Google',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Apple Login
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _handleLoginSuccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSurfaceLowest,
                    foregroundColor: colorOnSurface,
                    elevation: 1,
                    shadowColor: Colors.black.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.apple, size: 22, color: colorOnSurface),
                  label: Text(
                    'Apple ID',
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
    );
  }

  // 4. SIGN UP REDIRECTION
  Widget _buildSignUpRedirection() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ليس لديك حساب؟',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              color: colorOnSurfaceVariant,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'يمكنك إدخال رقم هاتفك مباشرة لتسجيل حساب جديد والطلب فوراً',
                    style: GoogleFonts.ibmPlexSansArabic(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: colorPrimaryContainer,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text(
              'إنشاء حساب جديد',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colorSecondary,
                decoration: TextDecoration.underline,
                decorationColor: colorSecondaryContainer,
                decorationThickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. JORDAN PETROLEUM REFINERY TRUST BADGE
  Widget _buildRefineryTrustBadge() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorSurfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorSurfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Color(0xFF004B73),
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
                    Text(
                      'أسطوانات غاز آمنة ومفحوصة',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: colorSecondary,
                      size: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'معتمدة ومختومة رسمياً وفق مواصفات مصفاة البترول الأردنية مع معاينة الصمام قبل التركيب.',
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

  // 6. SECURITY FOOTER
  Widget _buildSecurityFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: colorSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'اتصال مشفر وآمن 256-bit',
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
              color: colorSurfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'الأردن',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colorOnSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Jordan Flag Representation
  Widget _buildJordanFlag() {
    return Container(
      width: 22,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Black, White, Green horizontal stripes
          Column(
            children: [
              Expanded(child: Container(color: Colors.black)),
              Expanded(child: Container(color: Colors.white)),
              Expanded(child: Container(color: const Color(0xFF007A3D))),
            ],
          ),
          // Red Chevron Triangle with White 7-Point Star
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(11, 14),
              painter: _JordanTrianglePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Jordan Flag Chevron
class _JordanTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCE1126)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Mini star dot in center of chevron
    final starPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.35, size.height / 2), 1.2, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
