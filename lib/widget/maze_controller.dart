import 'package:origin_shift_maze_generator/maze/maze.dart';

class MazeController {
  MazeController(this.maze) {
    maze.nodeUpdates.listen(onUpdate);
    maze.parentUpdates.listen(updateWithNeighbors);
  }

  final Maze maze;

  final Map<(int, int), void Function()> _tileUpdateListeners = {};

  int get height => maze.height;

  int get width => maze.width;

  void addTileUpdateListener((int, int) tile, void Function() listener) =>
      _tileUpdateListeners[tile] = listener;

  void removeTileUpdateListener((int, int) tile) =>
      _tileUpdateListeners.remove(tile);

  void updateWithNeighbors((int, int) tile) {
    onUpdate(tile);
    final node = maze.getNode(tile);
    if (node == null) return;
    for (final neighbor in maze.getNeighbors(node)) {
      onUpdate(neighbor.position);
    }
  }

  bool _updatesEnabled = true;

  void onUpdate((int, int) tile) {
    if(_updatesEnabled) _tileUpdateListeners[tile]?.call();
  }

  void enableUpdates() => _updatesEnabled = true;

  void disableUpdates() => _updatesEnabled = false;
}
