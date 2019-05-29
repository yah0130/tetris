import 'package:flutter/material.dart';
import 'package:tetris/localization/i18n.dart';
import 'package:tetris/game/game.dart';
import 'package:tetris/material/audios.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tetris/panel/land.dart';
import 'package:tetris/panel/portrait.dart';

void main() {
  _disableDebugPrint();
  runApp(MyApp());
}

void _disableDebugPrint() {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (!debug) {
    debugPrint = (String message, {int wrapWidth}) {};
  }
}

const SCREEN_BORDER_WIDTH = 3.0;

const BACKGROUND_COLOR = const Color(0xffefcc19);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '俄罗斯方块',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Sound(
          child: Material(
              color: BACKGROUND_COLOR, child: Game(child: _MainPage()))),
    );
  }
}

class _MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PagePortrait();
  }
}
