import 'package:origin_shift_maze_generator/maze/direction.dart';
import 'package:origin_shift_maze_generator/maze/maze.dart';
import 'package:origin_shift_maze_generator/maze/maze_tile_info.dart';
import 'package:origin_shift_maze_generator/maze/root_maze_node.dart';

abstract class MazeNode {
  MazeNode({
    required this.maze,
    required this.x,
    required this.y,
  });

  final Maze maze;
  final int x;
  final int y;

  (int, int) get position => (x, y);

  MazeNode? getNodeRelative(int x, int y) =>
      maze.getNode(this.x + x, this.y + y);

  MazeNode? get top => getNodeRelative(0, -1);

  bool get hasTop => top != null;

  bool get hasTopWall => !(top?.hasConnectionTo(this) ?? false);

  MazeNode? get right => getNodeRelative(1, 0);

  bool get hasRight => right != null;

  bool get hasRightWall => !(right?.hasConnectionTo(this) ?? false);

  MazeNode? get bottom => getNodeRelative(0, 1);

  bool get hasBottom => bottom != null;

  bool get hasBottomWall => !(bottom?.hasConnectionTo(this) ?? false);

  MazeNode? get left => getNodeRelative(-1, 0);

  bool get hasLeft => left != null;

  bool get hasLeftWall => !(left?.hasConnectionTo(this) ?? false);

  bool hasConnectionTo(MazeNode node);

  Direction get pointingDirection;

  RootMazeNode get asRoot => RootMazeNode(maze: maze, x: x, y: y);

  MazeTileInfo get tileInfo => MazeTileInfo(
        hasTopWall: hasTopWall,
        hasRightWall: hasRightWall,
        hasBottomWall: hasBottomWall,
        hasLeftWall: hasLeftWall,
        isRoot: this is RootMazeNode,
        pointingDirection: pointingDirection,
      );
}
