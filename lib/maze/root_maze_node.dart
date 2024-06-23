import 'package:origin_shift_maze_generator/maze/base_maze_node.dart';
import 'package:origin_shift_maze_generator/maze/direction.dart';
import 'package:origin_shift_maze_generator/maze/maze_node.dart';

class RootMazeNode extends MazeNode {
  RootMazeNode({
    required super.maze,
    required super.x,
    required super.y,
  });

  @override
  bool hasConnectionTo(MazeNode node) {
    if (node is BaseMazeNode) return node.parent == this;
    return false;
  }

  @override
  Direction get pointingDirection => Direction.none;

  BaseMazeNode asBase(MazeNode parent) =>
      BaseMazeNode(maze: maze, x: x, y: y, parent: parent);

  @override
  String toString() => 'RootMazeNode(x: $x, y: $y)';
}
