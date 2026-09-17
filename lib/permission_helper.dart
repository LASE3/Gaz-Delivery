// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_language.dart';

enum AppPermissionType {
  location,
  camera,
  gallery,
}

class PermissionHelper {
  static final Map<AppPermissionType, bool> _grantedPermissions = {
    AppPermissionType.location: false,
    AppPermissionType.camera: false,
    AppPermissionType.gallery: false,
  };

  static bool isGranted(AppPermissionType type) => _grantedPermissions[type] ?? false;

  static Future<bool> requestPermission(
    BuildContext context, {
    required AppPermissionType type,
  }) async {
    if (_grantedPermissions[type] == true) {
      return true;
    }

    String titleAr = '';
    String titleEn = '';
    String messageAr = '';
    String messageEn = '';
    IconData icon = Icons.security_rounded;

    switch (type) {
      case AppPermissionType.location:
        icon = Icons.location_on_rounded;
        titleAr = 'إذن الوصول إلى الموقع الجغرافي (GPS)';
        titleEn = 'Location Permission Required';
        messageAr =
            'يحتاج تطبيق غاز الأردن للوصول إلى موقعك لتحديد أقرب شاحنة توزيع غاز في حيك وتحديث مسار الكابتن على الخريطة الحية.';
        messageEn =
            'Jordan Gas needs access to your location to find the nearest delivery truck in your area and update live driver tracking.';
        break;
      case AppPermissionType.camera:
        icon = Icons.camera_alt_rounded;
        titleAr = 'إذن الوصول إلى الكاميرا';
        titleEn = 'Camera Permission Required';
        messageAr =
            'يتطلب التقاط صور لتوثيق حالة صمام أسطوانة الغاز أو تصوير مدخل المبنى وعداد الغاز لتسهيل وصول الكابتن.';
        messageEn =
            'Required to capture photos of gas valve safety seals, building entrance, or receipts for fast driver dispatch.';
        break;
      case AppPermissionType.gallery:
        icon = Icons.photo_library_rounded;
        titleAr = 'إذن الوصول إلى معرض الصور';
        titleEn = 'Photo Gallery Permission Required';
        messageAr =
            'يتطلب إرفاق صور الفواتير أو تقارير السلامة السابقة المخزنة على هاتفك.';
        messageEn =
            'Required to attach saved invoice receipts or previous safety inspection photos from your photo library.';
        break;
    }

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: AppLanguage.direction,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDBCE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: const Color(0xFFFD651E),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppLanguage.tr(ar: titleAr, en: titleEn),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0B1C30),
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            AppLanguage.tr(ar: messageAr, en: messageEn),
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13,
              height: 1.5,
              color: const Color(0xFF565E74),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                AppLanguage.tr(ar: 'رفض', en: 'Don\'t Allow'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF76777D),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _grantedPermissions[type] = true;
                Navigator.pop(ctx, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFD651E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLanguage.tr(ar: 'سماح بالوصول', en: 'Allow Access'),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final bool granted = result ?? false;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? AppLanguage.tr(
                    ar: 'تم منح الإذن بنجاح',
                    en: 'Permission granted successfully',
                  )
                : AppLanguage.tr(
                    ar: 'تم رفض الإذن',
                    en: 'Permission denied',
                  ),
            style: GoogleFonts.ibmPlexSansArabic(fontSize: 12.5),
          ),
          backgroundColor: granted ? const Color(0xFF131B2E) : const Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return granted;
  }
}
