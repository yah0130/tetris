import 'package:flutter/material.dart';
import 'package:tetris/material/material.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/panel/playPanel.dart';
import 'package:tetris/panel/statusPanel.dart';

const Color SCREEN_BACKGROUND = Color(0xff9ead86);

class Screen extends StatelessWidget {
  final double width;

  const Screen({Key key, @required this.width}) : super(key: key);

  Screen.fromHeight(double height) : this(width: ((height - 6) / 2 + 6) / 0.6);

  @override
  Widget build(BuildContext context) {
    final playerPanelWidth = (width - 6) * 0.6;
    return Material(
      color: SCREEN_BACKGROUND,
      child: SizedBox(
        height: (playerPanelWidth - 6) * 2 + 6,
        width: width - 6,
        child: Container(
          color: SCREEN_BACKGROUND,
          child: GameMaterial(
            child: BrikSize(
                size: getBrikSizeForScreenWidth(playerPanelWidth),
                child: Row(
                  children: <Widget>[
                    PlayPanel(width: playerPanelWidth),
                    SizedBox(
                      width: width - 6 - playerPanelWidth,
                      child: StatusPanel(),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
