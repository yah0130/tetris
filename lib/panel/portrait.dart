import 'package:flutter/material.dart';
import 'package:tetris/main.dart';
import 'package:tetris/widgets/shake.dart';
import 'package:tetris/panel/screen.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/localization/i18n.dart';
import 'package:tetris/panel/leftBand.dart';
import 'package:tetris/panel/rightBand.dart';
import 'package:tetris/panel/controllerPanel.dart';
import 'package:tetris/game/game.dart';

class PagePortrait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerWidth = size.width * 0.8;
    final brikSize = Size.square((centerWidth * 0.35) / 10);
    return SizedBox.expand(
        child: BrikSize(
      size: brikSize,
      child: Container(
        color: BACKGROUND_COLOR,
        padding: MediaQuery.of(context).padding,
        child: Row(
          children: <Widget>[
            LeftBand(),
            Column(
              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(top: 20),
//                  child: Text(
//                    S.of(context).title,
//                    style: TextStyle(fontSize: 25),
//                  ),
//                ),
                Spacer(),
                Shake(
                    shake: GameState.of(context).states ==
                        GameControllerState.drop,
                    child: _ScreenDecoration(
                      child: Screen(width: centerWidth),
                    )),
                Spacer(flex: 2,),
                GameControllerPanel(),
                Center(
                  child: Text('©2019 Y.H.'),
                ),
                Spacer()
              ],
            ),
            RightBand(),
          ],
        ),
      ),
    ));
  }
}

class _ScreenDecoration extends StatelessWidget {
  final Widget child;

  const _ScreenDecoration({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: const Color(0xFF987f0f), width: SCREEN_BORDER_WIDTH),
          left: BorderSide(
              color: const Color(0xFF987f0f), width: SCREEN_BORDER_WIDTH),
          right: BorderSide(
              color: const Color(0xFFfae36c), width: SCREEN_BORDER_WIDTH),
          bottom: BorderSide(
              color: const Color(0xFFfae36c), width: SCREEN_BORDER_WIDTH),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
        child: Container(
          padding: const EdgeInsets.all(3),
          color: SCREEN_BACKGROUND,
          child: child,
        ),
      ),
    );
  }
}
