import 'package:flutter/material.dart';
import 'package:tetris/game/block.dart';
import 'dart:async';
import 'package:tetris/material/audios.dart';

//游戏区域高度
const GAME_PAD_H = 20;
//游戏区域宽度
const GAME_PAD_W = 10;

//重置每一行的间隔时间
const _REST_LINE_DURATION = const Duration(milliseconds: 50);

//最高级别
const _LEVEL_MAX = 6;

//最小级别
const _LEVEL_MIN = 1;

//方块下落速度，分6个级别
const _SPEED = [
  const Duration(milliseconds: 800),
  const Duration(milliseconds: 650),
  const Duration(milliseconds: 500),
  const Duration(milliseconds: 370),
  const Duration(milliseconds: 250),
  const Duration(milliseconds: 160),
];

///状态
enum GameControllerState {
  none, //初始状态
  paused, //暂停，不能操作
  running, //游戏运行中，方块正常下落
  reset, //游戏重置中，重置后状态变为
  mixing, //方块已到达底部，正在固定中。固定成功后会立即产生下一个方块
  clear, //方块消除中，消除完成后立即产生下一个方块
  drop //方块快速下落中
}

class Game extends StatefulWidget {
  final Widget child;

  Game({Key key, @required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GameController();
  }

  static GameController of(BuildContext context) {
    final state = context.ancestorStateOfType(TypeMatcher<GameController>());
    return state;
  }
}

class GameController extends State<Game> {
  final List<List<int>> _data = [];
  final List<List<int>> _mask = [];
  int _points = 0;
  int _cleared = 0;
  int _level = 1;

  SoundState get _sound => Sound.of(context);
  Block _currentBlock;
  Block _next = Block.getRandom();
  GameControllerState _state = GameControllerState.none;
  Timer _autoFallTimer;

  GameController() {
    //inflate game pad data
    for (int i = 0; i < GAME_PAD_H; i++) {
      _data.add(List.filled(GAME_PAD_W, 0));
      _mask.add(List.filled(GAME_PAD_W, 0));
    }
  }

  void _startGame() {
    if (_state == GameControllerState.running &&
        _autoFallTimer?.isActive == false) {
      return;
    }
    _state = GameControllerState.running;
    _autoFall(true);
    setState(() {});
  }

  void _autoFall(bool enable) {
    if (!enable && _autoFallTimer != null) {
      _autoFallTimer.cancel();
      _autoFallTimer = null;
    } else if (enable) {
      _autoFallTimer?.cancel();
      _currentBlock = _currentBlock ?? _getNext();
      _autoFallTimer = Timer.periodic(_SPEED[_level - 1], (t) {
        down(enableMusic: false);
      });
    }
  }

  Block _getNext() {
    final next = _next;
    _next = Block.getRandom();
    return next;
  }

  void rotate() {
    if (_state == GameControllerState.running && _currentBlock != null) {
      final next = _currentBlock.rotate();
      if (next.isValidBlock(_data)) {
        _currentBlock = next;
        _sound.rotate();
      }
    }
    setState(() {});
  }

  void left() {
    if (_state == GameControllerState.running && _currentBlock != null) {
      final next = _currentBlock.left();
      if (next.isValidBlock(_data)) {
        _currentBlock = next;
        _sound.move();
      }
    }
    setState(() {});
  }

  void right() {
    if (_state == GameControllerState.running && _currentBlock != null) {
      final next = _currentBlock.right();
      if (next.isValidBlock(_data)) {
        _currentBlock = next;
        _sound.move();
      }
    }
    setState(() {});
  }

  void drop() async {
    if (_state == GameControllerState.running && _currentBlock != null) {
      for (int i = 0; i < GAME_PAD_H; i++) {
        final fall = _currentBlock.fall(step: i + 1);
        if (!fall.isValidBlock(_data)) {
          _currentBlock = _currentBlock.fall(step: i);
          _state = GameControllerState.drop;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
          _mixCurrentBlockToData(mixSound: _sound.fall);
          break;
        }
      }
      setState(() {});
    } else if (_state == GameControllerState.none ||
        _state == GameControllerState.paused) {
      _startGame();
    }
  }

  void pause() {
    if (_state == GameControllerState.running) {
      _state = GameControllerState.paused;
    }
    setState(() {});
  }

  void pauseOrResume() {
    if (_state == GameControllerState.running) {
      pause();
    } else if (_state == GameControllerState.paused ||
        _state == GameControllerState.none) {
      _startGame();
    }
  }

  Future<void> _mixCurrentBlockToData({void mixSound()}) async {
    if (_currentBlock == null) {
      return;
    }
    _autoFall(false);
    _forTable((i, j) => _data[i][j] = _currentBlock.get(j, i) ?? _data[i][j]);
    final clearLines = [];
    for (int i = 0; i < GAME_PAD_H; i++) {
      if (_data[i].every((line) => line == 1)) {
        clearLines.add(i);
      }
    }
    if (clearLines.isNotEmpty) {
      setState(() {
        _state = GameControllerState.clear;
      });
      _sound.clear();
      for (int i = 0; i < 5; i++) {
        clearLines.forEach((line) {
          _mask[line].fillRange(0, GAME_PAD_W, i % 2 == 0 ? -1 : 1);
        });
        setState(() {});
        await Future.delayed(Duration(milliseconds: 100));
      }
      clearLines.forEach((line) {
        _mask[line].fillRange(0, GAME_PAD_W, 0);
      });
      clearLines.forEach((line) {
        _data.setRange(1, line + 1, _data);
        _data[0] = List.filled(GAME_PAD_W, 0);
      });
      debugPrint("clear lines : $clearLines");
      _points += clearLines.length * _level * 5;
      _cleared += clearLines.length;
      int level = (_cleared ~/ 20) + _LEVEL_MIN;
      _level = level > _LEVEL_MAX ? _level : level;
    } else {
      _state = GameControllerState.mixing;
      if (mixSound != null) mixSound();
      _forTable((i, j) => _mask[i][j] = _currentBlock.get(j, i) ?? _mask[i][j]);
      setState(() {});
      await Future.delayed(Duration(milliseconds: 100));
      _forTable((i, j) => _mask[i][j] = 0);
      setState(() {});
    }
    _currentBlock = null;
    if (_data[0].contains(1)) {
      reset();
    } else {
      _startGame();
    }
  }

  void reset() {
    if (_state == GameControllerState.none) {
      _startGame();
      return;
    }
    if (_state == GameControllerState.reset) {
      return;
    }
    _sound.start();
    _state = GameControllerState.reset;
    () async {
      int line = GAME_PAD_H;
      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < GAME_PAD_W; i++) {
          _data[line][i] = 1;
        }
        setState(() {});
        await Future.delayed(_REST_LINE_DURATION);
        return line != 0;
      });
      _currentBlock = null;
      _getNext();
      _points = 0;
      _cleared = 0;
      await Future.doWhile(() async {
        for (int i = 0; i < GAME_PAD_W; i++) {
          _data[line][i] = 0;
        }
        line++;
        setState(() {});
        await Future.delayed(_REST_LINE_DURATION);
        return line != GAME_PAD_H;
      });
      setState(() {
        _state = GameControllerState.none;
      });
    }();
  }

  static void _forTable(dynamic function(int r, int c)) {
    for (int i = 0; i < GAME_PAD_H; i++) {
      for (int j = 0; j < GAME_PAD_W; j++) {
        function(i, j);
      }
    }
  }

  void down({bool enableMusic = true}) {
    if (_state == GameControllerState.running && _currentBlock != null) {
      final next = _currentBlock.fall();
      if (next.isValidBlock(_data)) {
        _currentBlock = next;
        if (enableMusic) {
          _sound.move();
        }
      } else {
        _mixCurrentBlockToData();
      }
    }
    setState(() {});
  }

  void soundSwitch() {
    setState(() {
      _sound.mute = !_sound.mute;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<int>> mixed = [];
    for (var i = 0; i < GAME_PAD_H; i++) {
      mixed.add(List.filled(GAME_PAD_W, 0));
      for (var j = 0; j < GAME_PAD_W; j++) {
        int value = _currentBlock?.get(j, i) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1) {
          value = 2;
        }
        mixed[i][j] = value;
      }
    }
    debugPrint("game states : $_state");
    return GameState(
        mixed, _state, _level, _sound.mute, _points, _cleared, _next,
        child: widget.child);
  }
}

class GameState extends InheritedWidget {
  GameState(this.data, this.states, this.level, this.muted, this.points,
      this.cleared, this.next,
      {Key key, this.child})
      : super(key: key, child: child);

  final Widget child;

  ///屏幕展示数据
  ///0: 空砖块
  ///1: 普通砖块
  ///2: 高亮砖块
  final List<List<int>> data;

  final GameControllerState states;

  final int level;

  final bool muted;

  final int points;

  final int cleared;

  final Block next;

  static GameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GameState) as GameState);
  }

  @override
  bool updateShouldNotify(GameState oldWidget) {
    return true;
  }
}
