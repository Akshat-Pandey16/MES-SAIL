import 'package:flutter/material.dart';
import 'package:mes_app/presentation/login_screen.dart';
import 'package:mes_app/presentation/landing_page_screen.dart';
import 'package:mes_app/presentation/qr_code_screen.dart';
import 'package:mes_app/presentation/mills_screen.dart';
import 'package:mes_app/presentation/call_sms_screen.dart';
import 'package:mes_app/presentation/report_screen.dart';
import 'package:mes_app/presentation/app_navigation_screen.dart';
import 'package:mes_app/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';

  static const String millsScreen = '/mills_screen';

  static const String loginScreen = '/login_screen';

  static const String qrCodeScreen = '/qr_code_screen';

  static const String landingPageScreen = '/landing_page_screen';

  static const String callSmsScreen = '/call_sms_screen';

  static const String reportScreen = '/report_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    millsScreen: (context) => const MillScreen(),
    qrCodeScreen: (context) => const QrCodeScreen(),
    landingPageScreen: (context) => const LandingPageScreen(),
    callSmsScreen: (context) => const CallSmsScreen(),
    reportScreen: (context) => const ReportScreen(),
    appNavigationScreen: (context) => const AppNavigationScreen()
  };
}
