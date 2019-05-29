import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class Sound extends StatefulWidget {
  final Widget child;

  const Sound({Key key, this.child}) : super(key: key);

  static SoundState of(BuildContext context) {
    final state = context.ancestorStateOfType(const TypeMatcher<SoundState>());
    return state;
  }

  @override
  SoundState createState() => SoundState();
}

const _SOUNDS = [
  'clean.mp3',
  'drop.mp3',
  'explosion.mp3',
  'move.mp3',
  'rotate.mp3',
  'start.mp3'
];

class SoundState extends State<Sound> {
  Soundpool _pool;
  Map<String, int> _soundIds;
  bool mute = false;

  void _play(String name) {
    final soundId = _soundIds[name];
    if (soundId != null && !mute) {
      _pool.play(soundId);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pool = Soundpool(streamType: StreamType.music);
    _soundIds = Map();
    for (var value in _SOUNDS) {
      scheduleMicrotask(() async {
        final data = await rootBundle.load("assets/audios/$value");
        _soundIds[value] = await _pool.load(data);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pool.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void start() {
    _play('start.mp3');
  }

  void clear() {
    _play('clean.mp3');
  }

  void fall() {
    _play('drop.mp3');
  }

  void rotate() {
    _play('rotate.mp3');
  }

  void move() {
    _play('move.mp3');
  }
}
