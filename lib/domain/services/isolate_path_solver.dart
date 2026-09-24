import 'dart:isolate';

import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/domain/services/path_solver.dart';
import 'package:path_finder/domain/services/shortest_path_finder.dart';

class IsolatePathSolver implements PathSolver {
  const IsolatePathSolver({this._pathFinder = const ShortestPathFinder()});

  final ShortestPathFinder _pathFinder;

  @override
  Future<TaskResult> solve(PathTask task) async {
    final pathFinder = _pathFinder;
    final steps = await Isolate.run(() => pathFinder.findPath(task.field, task.start, task.end));
    return TaskResult(task: task, steps: steps ?? const []);
  }
}
