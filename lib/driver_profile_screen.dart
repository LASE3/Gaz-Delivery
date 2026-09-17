// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_language.dart';
import 'page_transitions.dart';
import 'driver_chat_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  // Theme Colors
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, lang, child) {
        return Directionality(
          textDirection: AppLanguage.direction,
          child: Scaffold(
            backgroundColor: colorSurface,
            appBar: AppBar(
              backgroundColor: colorSurface.withValues(alpha: 0.9),
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  AppLanguage.isArabic
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                  color: colorOnSurface,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                AppLanguage.tr(ar: 'ملف الكابتن المعتمد', en: 'Captain Profile'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDriverHeaderCard(context),
                  const SizedBox(height: 16),
                  _buildQuickActionButtons(context),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 16),
                  _buildVehicleAndCertificatesCard(),
                  const SizedBox(height: 16),
                  _buildCustomerReviewsCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // 1. DRIVER HERO CARD
  // ==========================================
  Widget _buildDriverHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Driver Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorSecondaryContainer,
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF131B2E),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Name, Badge & Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            AppLanguage.tr(
                              ar: 'الكابتن أحمد الخوالدة',
                              en: 'Captain Ahmad Al-Khawaldeh',
                            ),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: colorOnSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          color: colorSecondaryContainer,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppLanguage.tr(
                        ar: 'فني غاز معتمد • الدفاع المدني الأردني',
                        en: 'Certified LPG Technician • Jordan Civil Defense',
                      ),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB599).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFD651E),
                                size: 16,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '4.9',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: colorSecondary,
                                ),
                              ),
                              Text(
                                ' (1,240+ تقييم)',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10.5,
                                  color: colorOnSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Civil Defense Endorsement Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorSurfaceLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorSurfaceContainer),
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
                      ar: 'مزود بأجهزة فحص تسريب الصمام الإلكترونية ومعايير الأمان 100%',
                      en: 'Equipped with digital gas leak detectors and 100% safety protocols',
                    ),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: colorOnSurface,
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
  // 2. QUICK ACTIONS (CALL / CHAT / TRACK)
  // ==========================================
  Widget _buildQuickActionButtons(BuildContext context) {
    return Row(
      children: [
        // Call Driver Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLanguage.tr(
                      ar: 'جاري الاتصال بالكابتن أحمد على 0790000000...',
                      en: 'Calling Captain Ahmad at 0790000000...',
                    ),
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
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.phone_rounded, size: 18),
            label: Text(
              AppLanguage.tr(ar: 'اتصال مباشر', en: 'Call Captain'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Live Chat Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.pushPage(const DriverChatScreen());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: colorOnSurface,
              side: const BorderSide(color: colorSecondaryContainer, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 18,
              color: colorSecondaryContainer,
            ),
            label: Text(
              AppLanguage.tr(ar: 'محادثة فورية', en: 'Live Chat'),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. STATS GRID
  // ==========================================
  Widget _buildStatsGrid() {
    return Row(
      children: [
        _buildStatCard(
          title: AppLanguage.tr(ar: 'الطلبات المنجزة', en: 'Deliveries'),
          value: '1,240+',
          icon: Icons.task_alt_rounded,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          title: AppLanguage.tr(ar: 'الالتزام بالوقت', en: 'On-Time'),
          value: '99.4%',
          icon: Icons.timer_outlined,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          title: AppLanguage.tr(ar: 'سنوات الخبرة', en: 'Experience'),
          value: AppLanguage.tr(ar: '6 سنوات', en: '6 Years'),
          icon: Icons.workspace_premium_outlined,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: colorSurfaceLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: colorSecondaryContainer),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: colorOnSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 10.5,
                color: colorOnSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 4. VEHICLE & CERTIFICATE CARD
  // ==========================================
  Widget _buildVehicleAndCertificatesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(18),
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
          Text(
            AppLanguage.tr(ar: 'بيانات المركبة والتراخيص', en: 'Vehicle & Licences'),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorOnSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.local_shipping_outlined,
            title: AppLanguage.tr(ar: 'مركبة التوزيع', en: 'Delivery Truck'),
            value: AppLanguage.tr(
              ar: 'ميتسوبيشي كانتر (شاحنة غاز مجهزة)',
              en: 'Mitsubishi Canter (Equipped Gas Truck)',
            ),
          ),
          const Divider(height: 18),
          _buildInfoRow(
            icon: Icons.pin_outlined,
            title: AppLanguage.tr(ar: 'رقم اللوحة المرخصة', en: 'License Plate'),
            value: '48-12903 (عمان - تجاري)',
          ),
          const Divider(height: 18),
          _buildInfoRow(
            icon: Icons.verified_user_outlined,
            title: AppLanguage.tr(ar: 'ترخيص هيئة الطاقة', en: 'EMRC Certificate'),
            value: 'JO-GAS-DIST-2026/894',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 11,
                  color: colorOutline,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: colorOnSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 5. CUSTOMER REVIEWS
  // ==========================================
  Widget _buildCustomerReviewsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorSurfaceLowest,
        borderRadius: BorderRadius.circular(18),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLanguage.tr(ar: 'تقييمات وتجارب العملاء', en: 'Customer Reviews'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colorOnSurface,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFFD651E), size: 16),
                  const SizedBox(width: 2),
                  Text(
                    '4.9 (1.2k)',
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildReviewItem(
            name: AppLanguage.tr(ar: 'سالم النعيمي', en: 'Salem Al-Nuaimi'),
            rating: 5,
            comment: AppLanguage.tr(
              ar: 'كابتن محترم وسريع جداً، قام بفحص الصمام والتسريب بفقاعات الصابون وتأكد من عمل المدفأة بأمان.',
              en: 'Very polite and fast captain, checked the leak with soap bubbles and verified the heater worked safely.',
            ),
            time: AppLanguage.tr(ar: 'قبل يومين', en: '2 days ago'),
          ),
          const Divider(height: 20),
          _buildReviewItem(
            name: AppLanguage.tr(ar: 'أم عمر - تلاع العلي', en: 'Um Omar - Tlaa Al-Ali'),
            rating: 5,
            comment: AppLanguage.tr(
              ar: 'وصل خلال 10 دقائق وحمل الأسطوانة للطابق الثالث مع المصعد وركب المنظم باحترافية.',
              en: 'Arrived in 10 minutes, brought the cylinder to the 3rd floor and installed the regulator professionally.',
            ),
            time: AppLanguage.tr(ar: 'قبل أسبوع', en: '1 week ago'),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String comment,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: colorOnSurface,
              ),
            ),
            Text(
              time,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 10.5,
                color: colorOutline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: List.generate(
            rating,
            (index) => const Icon(
              Icons.star_rounded,
              color: Color(0xFFFD651E),
              size: 14,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          comment,
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 11.5,
            height: 1.4,
            color: colorOnSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
