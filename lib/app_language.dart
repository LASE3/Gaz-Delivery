// ignore_for_file: file_names
import 'package:flutter/material.dart';

/// Centralized Language Manager for bilingual support (Arabic / English)
class AppLanguage {
  static final ValueNotifier<String> currentLanguage = ValueNotifier<String>('en');

  static bool get isArabic => currentLanguage.value == 'ar';
  static bool get isEnglish => currentLanguage.value == 'en';

  static TextDirection get direction =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  static void toggleLanguage() {
    currentLanguage.value = isArabic ? 'en' : 'ar';
  }

  static void setLanguage(String code) {
    if (code == 'ar' || code == 'en') {
      currentLanguage.value = code;
    }
  }

  /// Helper to get text based on current language
  static String tr({required String ar, required String en}) {
    return isArabic ? ar : en;
  }

  /// Adaptive directional icons
  static IconData get forwardIcon =>
      isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded;

  static IconData get backIcon =>
      isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded;

  static IconData get chevronForward =>
      isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded;

  static IconData get chevronBack =>
      isArabic ? Icons.chevron_right_rounded : Icons.chevron_left_rounded;
}
