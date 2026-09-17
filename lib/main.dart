import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import 'app_language.dart';
import 'page_transitions.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, langCode, child) {
        final bool isAr = langCode == 'ar';

        return MaterialApp(
          title: isAr ? 'غاز الأردن - توصيل الغاز المنزلي' : 'Jordan Gas - Domestic Delivery',
          debugShowCheckedModeBanner: false,
          locale: Locale(langCode),
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF8F9FF),
            textTheme: isAr
                ? GoogleFonts.ibmPlexSansArabicTextTheme(
                    Theme.of(context).textTheme,
                  )
                : GoogleFonts.ibmPlexSansTextTheme(
                    Theme.of(context).textTheme,
                  ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: AppSmoothPageTransitionsBuilder(),
                TargetPlatform.iOS: AppSmoothPageTransitionsBuilder(),
                TargetPlatform.windows: AppSmoothPageTransitionsBuilder(),
                TargetPlatform.macOS: AppSmoothPageTransitionsBuilder(),
                TargetPlatform.linux: AppSmoothPageTransitionsBuilder(),
              },
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFD651E),
              primary: const Color(0xFFFD651E),
              surface: const Color(0xFFF8F9FF),
            ),
          ),
          builder: (context, child) {
            return Directionality(
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
