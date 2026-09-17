// ignore_for_file: file_names
import 'package:flutter/material.dart';

/// Centralized Language Manager for bilingual support (Arabic / English)
class AppLanguage {
  static final ValueNotifier<String> currentLanguage = ValueNotifier<String>('ar');

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
}
