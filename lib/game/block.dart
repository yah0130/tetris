import 'game.dart';
import 'dart:math' as math;

const BLOCK_SHAPES = {
  BlockType.I: [
    [1, 1, 1, 1]
  ],
  BlockType.L: [
    [0, 0, 1],
    [1, 1, 1],
  ],
  BlockType.J: [
    [1, 0, 0],
    [1, 1, 1],
  ],
  BlockType.Z: [
    [1, 1, 0],
    [0, 1, 1]
  ],
  BlockType.S: [
    [0, 1, 1],
    [1, 1, 0]
  ],
  BlockType.O: [
    [1, 1],
    [1, 1]
  ],
  BlockType.T: [
    [0, 1, 0],
    [1, 1, 1]
  ]
};
const START_XY = {
  BlockType.I: [3, 0],
  BlockType.L: [4, -1],
  BlockType.J: [4, -1],
  BlockType.Z: [4, -1],
  BlockType.S: [4, -1],
  BlockType.O: [4, -1],
  BlockType.T: [4, -1],
};
//方块每一次变换时XY的增量变化
const ROTATE_XY = {
  BlockType.I: [
    [1, -1], //第一次，XY起始点X+1,Y-1
    [-1, 1], //第二次，接着就继续到第一次循环
  ],
  BlockType.L: [
    [0, 0]
  ],
  BlockType.J: [
    [0, 0]
  ],
  BlockType.Z: [
    [0, 0]
  ],
  BlockType.S: [
    [0, 0]
  ],
  BlockType.O: [
    [0, 0]
  ],
  BlockType.T: [
    [0, 0],
    [0, 1],
    [1, -1],
    [-1, 0]
  ],
};
enum BlockType { I, L, J, Z, S, O, T }

class Block {
  final BlockType type;
  final List<List<int>> shape;
  final List<int> xy;
  final int rotateIndex;

  Block(this.type, this.shape, this.xy, this.rotateIndex);

  Block fall({int step = 1}) {
    return Block(type, shape, [xy[0], xy[1] + step], rotateIndex);
  }

  Block left() {
    return Block(type, shape, [xy[0] - 1, xy[1]], rotateIndex);
  }

  Block right() {
    return Block(type, shape, [xy[0] + 1, xy[1]], rotateIndex);
  }

  Block rotate() {
    List<List<int>> result = List.filled(shape[0].length, null);
    for (int r = 0; r < shape.length; r++) {
      for (int c = 0; c < shape[r].length; c++) {
        if (result[c] == null) {
          result[c] = List.filled(shape.length, 0);
        }
        result[c][r] = shape[shape.length - 1 - r][c];
      }
    }
    final newXY = [
      this.xy[0] + ROTATE_XY[type][rotateIndex][0],
      this.xy[1] + ROTATE_XY[type][rotateIndex][1]
    ];
    final newIndex =
        rotateIndex + 1 >= ROTATE_XY[type].length ? 0 : rotateIndex + 1;
    return Block(type, result, newXY, newIndex);
  }

  bool isValidBlock(List<List<int>> data) {
    if (xy[0] < 0 ||
        xy[1] + shape.length > GAME_PAD_H ||
        xy[0] + shape[0].length > GAME_PAD_W) {
      return false;
    }
    for (int i = 0; i < data.length; i++) {
      final line = data[i];
      for (int j = 0; j < line.length; j++) {
        if (line[j] == 1 && get(j, i) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  static Block fromType(BlockType type) {
    return Block(type, BLOCK_SHAPES[type], START_XY[type], 0);
  }

  static Block getRandom() {
    final index = math.Random().nextInt(BlockType.values.length);
    return fromType(BlockType.values[index]);
  }

  int get(int x, int y) {
    x -= xy[0];
    y -= xy[1];
    if (x < 0 || y < 0 || x >= shape[0].length || y >= shape.length) {
      return null;
    }
    return shape[y][x] == 1 ? 1 : null;
  }
}
