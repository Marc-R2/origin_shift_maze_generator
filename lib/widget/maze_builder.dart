import 'package:flutter/material.dart';
import 'package:origin_shift_maze_generator/maze/maze.dart';
import 'package:origin_shift_maze_generator/widget/maze_controller.dart';
import 'package:origin_shift_maze_generator/widget/maze_tile.dart';

class MazeBuild extends StatelessWidget {
  const MazeBuild({
    super.key,
    required this.maze,
  });

  final MazeController maze;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var y = 0; y < maze.height; y++)
          Row(
            children: [
              for (var x = 0; x < maze.width; x++)
                MazeTile(controller: maze, tile: (x, y)),
            ],
          ),
      ],
    );
  }
}
