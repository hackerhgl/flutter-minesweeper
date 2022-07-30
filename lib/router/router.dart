import 'package:flutter/material.dart';
import 'package:minesweeper/ui/screens/splash/splash.dart';

part 'paths.dart';

class AppRouter {
  static const initialRoute = RouterPaths.splash;

  static Map<String, Widget Function(BuildContext)> router() {
    return {
      RouterPaths.splash: (ctx) => const SplashScreen(),
    };
  }
}
