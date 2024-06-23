import 'package:flutter/material.dart';
import 'package:origin_shift_maze_generator/maze/direction.dart';
import 'package:origin_shift_maze_generator/widget/maze_controller.dart';

class MazeTile extends StatefulWidget {
  const MazeTile({
    super.key,
    required this.controller,
    required this.tile,
  });

  final MazeController controller;
  final (int, int) tile;

  @override
  State<MazeTile> createState() => _MazeTileState();
}

class _MazeTileState extends State<MazeTile> {
  @override
  void initState() {
    widget.controller.addTileUpdateListener(widget.tile, update);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeTileUpdateListener(widget.tile);
    super.dispose();
  }

  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(color: Colors.black);

    final tileInfo = widget.controller.maze.getNode(widget.tile)?.tileInfo;
    if (tileInfo == null) return const SizedBox(width: 16, height: 16);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 64),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: tileInfo.isRoot ? Colors.green : Colors.white,
        border: Border(
          top: tileInfo.hasTopWall ? borderSide : BorderSide.none,
          right: tileInfo.hasRightWall ? borderSide : BorderSide.none,
          bottom: tileInfo.hasBottomWall ? borderSide : BorderSide.none,
          left: tileInfo.hasLeftWall ? borderSide : BorderSide.none,
        ),
      ),
      child: drawArrow(tileInfo.pointingDirection),
    );
  }

  Widget drawArrow(Direction direction) {
    switch (direction) {
      case Direction.top:
        return const Icon(Icons.arrow_drop_up, size: 8);
      case Direction.right:
        return const Icon(Icons.arrow_right, size: 8);
      case Direction.bottom:
        return const Icon(Icons.arrow_drop_down, size: 8);
      case Direction.left:
        return const Icon(Icons.arrow_left, size: 8);
      default:
        return const SizedBox();
    }
  }
}
