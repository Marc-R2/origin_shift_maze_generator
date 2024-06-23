import 'package:origin_shift_maze_generator/maze/direction.dart';
import 'package:origin_shift_maze_generator/maze/maze_node.dart';

class BaseMazeNode extends MazeNode {
  BaseMazeNode({
    required super.maze,
    required super.x,
    required super.y,
    required MazeNode parent,
  }) {
    maze.setParent(this, parent);
  }

  MazeNode get parent => maze.getParent(this);

  @override
  bool hasConnectionTo(MazeNode node) {
    if (node is BaseMazeNode && this == node.parent) return true;
    return node == parent;
  }

  @override
  Direction get pointingDirection {
    if (parent.x == x) {
      if (parent.y < y) return Direction.top;
      if (parent.y > y) return Direction.bottom;
    } else if (parent.y == y) {
      if (parent.x < x) return Direction.left;
      if (parent.x > x) return Direction.right;
    }
    return Direction.none;
  }

  @override
  String toString() => 'BaseMazeNode(x: $x, y: $y, parent: ${parent.position})';
}
