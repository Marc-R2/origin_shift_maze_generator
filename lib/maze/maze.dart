import 'dart:async';

import 'package:origin_shift_maze_generator/maze/base_maze_node.dart';
import 'package:origin_shift_maze_generator/maze/maze_node.dart';
import 'package:origin_shift_maze_generator/maze/root_maze_node.dart';

class Maze {
  Maze({
    required this.width,
    required this.height,
    int resolution = 3,
  }) {
    MazeNode? stemmRoot;
    for (var x = 0; x < width; x++) {
      if (stemmRoot == null) {
        root = stemmRoot = RootMazeNode(maze: this, x: x, y: 0);
      } else {
        stemmRoot = BaseMazeNode(maze: this, x: x, y: 0, parent: stemmRoot);
      }
      _nodes[stemmRoot.position] = stemmRoot;
      var localRoot = stemmRoot;

      for (var y = 1; y < height; y++) {
        localRoot = _nodes[(x, y)] =
            BaseMazeNode(maze: this, x: x, y: y, parent: localRoot);
      }
    }
    renewUpdateTargets(resolution: resolution);
  }

  final int width;
  final int height;

  late RootMazeNode root;
  final Map<(int, int), MazeNode> _nodes = {};
  final Map<(int, int), (int, int)> _parents = {};

  final List<(int, int)> _updateTargets = [];

  MazeNode? getNode((int, int) pos) => _nodes[pos];

  Iterable<MazeNode> getNeighborsWeighted(MazeNode node) sync* {
    final target = _updateTargets.firstOrNull;
    yield* getNeighbors(node).toList();
    yield* getNeighbors(node).toList();
    if (target == null) return;

    if (target.$2 < node.y) {
      yield node.top!;
      yield node.top!;
      yield node.top!;
    } else if (target.$2 > node.y) {
      yield node.bottom!;
      yield node.bottom!;
      yield node.bottom!;
    }
    if (target.$1 < node.x) {
      yield node.left!;
      yield node.left!;
      yield node.left!;
    } else if (target.$1 > node.x) {
      yield node.right!;
      yield node.right!;
      yield node.right!;
    }

    _updateTargets.remove(node.position);
  }

  Iterable<MazeNode> getNeighbors(MazeNode node) sync* {
    if (node.top != null) yield node.top!;
    if (node.right != null) yield node.right!;
    if (node.bottom != null) yield node.bottom!;
    if (node.left != null) yield node.left!;
  }

  void renewUpdateTargets({int resolution = 3}) {
    _updateTargets.clear();
    // Fill the update targets with positions reduced by the resolution
    // resolution = 1 -> every position
    // resolution = 3 -> 1 target in every 3x3 area
    for (var x = 0; x < width; x += resolution) {
      for (var y = 0; y < height; y += resolution) {
        _updateTargets.add((x, y));
      }
    }

    void addIfNotContains(int x, int y) {
      if (_updateTargets.contains((x, y))) return;
      _updateTargets.add((x, y));
    }

    // Make sure the borders are always in the update targets
    for (var x = 0; x < width; x += resolution) {
      addIfNotContains(x, 0);
      addIfNotContains(x, height - 1);
    }
    for (var y = 0; y < height; y += resolution) {
      addIfNotContains(0, y);
      addIfNotContains(width - 1, y);
    }
    _updateTargets.shuffle();
  }

  void originShift([int steps = 1]) {
    for (var i = 0; i < steps; i++) {
      originShiftStep();
    }
  }

  void originShiftUntilEmpty() {
    while (_updateTargets.isNotEmpty) {
      originShiftStep();
    }
  }

  void originShiftStep() {
    final rootNeighbors = getNeighborsWeighted(root).toList()..shuffle();
    if (rootNeighbors.isEmpty) return;

    final newRoot = rootNeighbors.first.asRoot;
    updateNode(root.asBase(newRoot));
    root = updateNode(newRoot);
  }

  T updateNode<T extends MazeNode>(T node) {
    final newNode = _nodes[node.position] = node;
    _nodeUpdates.add(newNode.position);
    return newNode;
  }

  void setParent(MazeNode child, MazeNode parent) {
    _parents[child.position] = parent.position;
    _parentUpdates.add(child.position);
  }

  MazeNode getParent(BaseMazeNode baseMazeNode) =>
      _nodes[_parents[baseMazeNode.position]!]!;

  final _nodeUpdates = StreamController<(int, int)>.broadcast();

  Stream<(int, int)> get nodeUpdates => _nodeUpdates.stream;

  final _parentUpdates = StreamController<(int, int)>.broadcast();

  Stream<(int, int)> get parentUpdates => _parentUpdates.stream;
}
