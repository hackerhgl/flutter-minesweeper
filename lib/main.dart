import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'package:flutter_minesweeper/Navigator.dart';
import 'package:flutter_minesweeper/io/io.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  FlutterError.onError = (FlutterErrorDetails err) {};
  runApp(AppNavigator([]));
}
