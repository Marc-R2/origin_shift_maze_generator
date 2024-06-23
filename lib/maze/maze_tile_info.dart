import 'package:origin_shift_maze_generator/maze/direction.dart';

class MazeTileInfo {
  MazeTileInfo({
    required this.hasTopWall,
    required this.hasRightWall,
    required this.hasBottomWall,
    required this.hasLeftWall,
    required this.isRoot,
    required this.pointingDirection,
  });

  final bool hasTopWall;
  final bool hasRightWall;
  final bool hasBottomWall;
  final bool hasLeftWall;
  final bool isRoot;
  final Direction pointingDirection;
}
