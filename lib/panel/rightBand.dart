import 'package:flutter/material.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/game/block.dart';

class RightBand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        children: () {
          List<Widget> widgets = List<Widget>();
          widgets.add(Spacer(flex: 3,));
          widgets.addAll(
              Block.fromType(BlockType.S).rotate().shape.map((list) {
                return Row(
                  children: list.map((b) {
                    return b == 1 ? const Brik.normal() : const Brik.nil();
                  }).toList(),
                );
              }).toList());
          widgets.add(Spacer());
          widgets.addAll(Block.fromType(BlockType.T)
              .rotate()
              .rotate()
              .rotate()
              .shape
              .map((list) {
            return Row(
              children: list.map((b) {
                return b == 1 ? const Brik.normal() : const Brik.nil();
              }).toList(),
            );
          }).toList());
          widgets.add(Spacer());
          widgets.addAll(Block.fromType(BlockType.O).shape.map((list) {
            return Row(
              children: list.map((b) {
                return b == 1 ? const Brik.normal() : const Brik.nil();
              }).toList(),
            );
          }).toList());
          widgets.add(Spacer());
          widgets.addAll(
              Block.fromType(BlockType.T).rotate().shape.map((list) {
                return Row(
                  children: list.map((b) {
                    return b == 1 ? const Brik.normal() : const Brik.nil();
                  }).toList(),
                );
              }).toList());
          widgets.add(Spacer());
          widgets.addAll(
              Block.fromType(BlockType.J).rotate().shape.map((list) {
                return Row(
                  children: list.map((b) {
                    return b == 1 ? const Brik.normal() : const Brik.nil();
                  }).toList(),
                );
              }).toList());
          widgets.add(Spacer());
          widgets.addAll(
              Block.fromType(BlockType.I).rotate().shape.map((list) {
                return Row(
                  children: list.map((b) {
                    return b == 1 ? const Brik.normal() : const Brik.nil();
                  }).toList(),
                );
              }).toList());
          widgets.add(Spacer(
            flex: 10,
          ));
          return widgets;
        }(),
      ),
    );
  }
}
