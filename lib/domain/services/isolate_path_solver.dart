import 'dart:isolate';

import 'package:path_finder/core/logging/app_logger.dart';
import 'package:path_finder/domain/entities/grid_field.dart';
import 'package:path_finder/domain/entities/grid_point.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/domain/services/path_solver.dart';
import 'package:path_finder/domain/services/shortest_path_finder.dart';

class IsolatePathSolver implements PathSolver {
  const IsolatePathSolver({
    this._pathFinder = const ShortestPathFinder(),
    this._logger = const DefaultLogger(),
  });

  final ShortestPathFinder _pathFinder;
  final AppLogger _logger;

  @override
  Future<TaskResult> solve(PathTask task) async {
    final field = task.field;
    _logger.debug(
      'Task ${task.id}: searching ${field.width}x${field.height} field '
      'from ${task.start} to ${task.end}',
    );

    final pathFinder = _pathFinder;
    final stopwatch = Stopwatch()..start();
    final steps = await Isolate.run(() => pathFinder.findPath(task.field, task.start, task.end));
    final elapsed = stopwatch.elapsed;
    final taskResult = TaskResult(task: task, steps: steps ?? const []);
    _logger.info(
      'Task ${taskResult.task.id}: for finding path finished in $elapsed: ${taskResult.path}',
    );
    return taskResult;
  }

}
