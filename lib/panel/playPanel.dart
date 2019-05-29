import 'package:flutter/material.dart';
import 'package:tetris/game/game.dart';
import 'playPad.dart';

const _PLAY_PANEL_PADDING = 6.0;

Size getBrikSizeForScreenWidth(double width) {
  return Size.square((width - _PLAY_PANEL_PADDING) / GAME_PAD_W);
}

class PlayPanel extends StatelessWidget {
  final Size size;

  PlayPanel({Key key, @required double width})
      : size = Size(width, width * 2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Stack(
          children: <Widget>[PlayerPad(), GameUninitialized()],
        ),
      ),
    );
  }
}
