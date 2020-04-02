import 'package:flutter/material.dart';
// import 'package:firebase/firebase.dart' as firebase;

import './configs/Theme.dart' as theme;
import 'package:flutter_minesweeper/io/io.dart';

import './screens/Home/Home.dart';
import './screens/Game/Game.dart';
import './screens/Download/Download.dart';
import './screens/AboutApp/AboutApp.dart';
import './screens/AboutDeveloper/AboutDeveloper.dart';

bool isAlt = false;

class AppNavigator extends StatelessWidget {
  AppNavigator(this.observers);
  final List<NavigatorObserver> observers;
  final GlobalKey<NavigatorState> navigator = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        final runtime = event.runtimeType.toString();
        final keyName = event.logicalKey.debugName;
        final ctrl = "Unknown Android key code 17";

        if (Platform.isWindows && keyName == ctrl) {
          isAlt = (runtime == 'RawKeyDownEvent');
        }

        if (runtime == 'RawKeyUpEvent' &&
            (keyName == 'Backspace' || keyName == 'Digit 1') &&
            (event.isAltPressed || isAlt) &&
            this.navigator.currentState.canPop()) {
          this.navigator.currentState.pop();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: this.navigator,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: theme.primary,
          accentColor: theme.primary,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: theme.primary,
          accentColor: theme.primary,
        ),
        navigatorObservers: observers,
        home: HomeScreen(),
        routes: <String, WidgetBuilder>{
          "home": (ctx) => new HomeScreen(),
          "about": (ctx) => new AboutAppScreen(),
          "aboutDeveloper": (ctx) => new AboutDeveloperScreen(),
          "download": (ctx) => new DownloadScreen(),
          "game": (ctx) => new GameScreen(),
        },
      ),
    );
  }
}
