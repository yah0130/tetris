import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class Shake extends StatefulWidget {
  final Widget child;

  ///true to shake screen vertically
  final bool shake;

  const Shake({Key key, @required this.child, @required this.shake})
      : super(key: key);

  @override
  _ShakeState createState() => _ShakeState();
}

///摇晃屏幕
class _ShakeState extends State<Shake> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
    AnimationController(vsync: this, duration: Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  v.Vector3 _getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi) * 1.5;
    return v.Vector3(0, offset, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_getTranslation()),
      child: widget.child,
    );
  }
}