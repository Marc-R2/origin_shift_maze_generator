import 'package:flutter/material.dart';
import 'package:origin_shift_maze_generator/maze/maze.dart';
import 'package:origin_shift_maze_generator/widget/maze_builder.dart';
import 'package:origin_shift_maze_generator/widget/maze_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Maze maze = Maze(width: 80, height: 42, resolution: 2);

  late MazeController mazeController = MazeController(maze);

  void _regenMaze() async {
    maze.renewUpdateTargets(resolution: 4);
    final t1 = DateTime.now();
    mazeController.disableUpdates();
    maze.originShiftUntilEmpty();
    mazeController.enableUpdates();
    final t2 = DateTime.now();
    print('Took: ${t2.difference(t1).inMilliseconds}ms');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: MazeBuild(maze: mazeController)),
      floatingActionButton: FloatingActionButton(
        onPressed: _regenMaze,
        tooltip: 'Re-Generate Maze',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
