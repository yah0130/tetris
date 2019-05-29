import 'package:flutter/material.dart';
import 'package:tetris/game/game.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/localization/i18n.dart';
import 'package:tetris/material/images.dart';

class PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: GameState.of(context).data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1
                ? const Brik.normal()
                : b == 2 ? const Brik.highlight() : const Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (GameState.of(context).states == GameControllerState.none) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconDragon(animate: true),
            SizedBox(height: 16),
            Text(
              S.of(context).title,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}