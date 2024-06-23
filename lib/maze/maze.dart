import 'package:origin_shift_maze_generator/maze/base_maze_node.dart';
import 'package:origin_shift_maze_generator/maze/maze_node.dart';
import 'package:origin_shift_maze_generator/maze/root_maze_node.dart';

class Maze {
  Maze({
    required this.width,
    required this.height,
  }) {
    MazeNode? stemmRoot;
    for (var x = 0; x < width; x++) {
      if (stemmRoot == null) {
        root = stemmRoot = RootMazeNode(maze: this, x: x, y: 0);
      } else {
        stemmRoot = BaseMazeNode(maze: this, x: x, y: 0, parent: stemmRoot);
      }
      nodes[stemmRoot.position] = stemmRoot;
      var localRoot = stemmRoot;

      for (var y = 1; y < height; y++) {
        localRoot = nodes[(x, y)] =
            BaseMazeNode(maze: this, x: x, y: y, parent: localRoot);
      }
    }
  }

  final int width;
  final int height;

  late RootMazeNode root;
  final Map<(int, int), MazeNode> nodes = {};
  final Map<(int, int), (int, int)> parents = {};

  MazeNode? getNode(int x, int i) => nodes[(x, i)];

  Iterable<MazeNode> getNeighborsWeighted(MazeNode node) sync* {
    if (node.hasBottomWall && node.hasBottom) yield node.bottom!;
    if (node.hasRightWall && node.hasRight) yield node.right!;
    if (node.hasTopWall && node.hasTop) yield node.top!;
    if (node.hasLeftWall && node.hasLeft) yield node.left!;
    yield* getNeighbors(node);
  }

  Iterable<MazeNode> getNeighbors(MazeNode node) sync* {
    if (node.top != null) yield node.top!;
    if (node.right != null) yield node.right!;
    if (node.bottom != null) yield node.bottom!;
    if (node.left != null) yield node.left!;
  }

  void originShift([int steps = 1]) {
    for (var i = 0; i < steps; i++) {
      originShiftStep();
    }
  }

  void originShiftStep() {
    final rootNeighbors = getNeighbors(root).toList()..shuffle();
    if (rootNeighbors.isEmpty) return;

    final newRoot = rootNeighbors.first.asRoot;
    updateNode(root.asBase(newRoot));
    root = updateNode(newRoot);
  }

  T updateNode<T extends MazeNode>(T node) {
    return nodes[node.position] = node;
  }

  void setParent(MazeNode child, MazeNode parent) {
    parents[child.position] = parent.position;
  }

  MazeNode getParent(BaseMazeNode baseMazeNode) =>
      nodes[parents[baseMazeNode.position]!]!;
}