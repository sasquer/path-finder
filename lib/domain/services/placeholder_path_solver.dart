import 'package:path_finder/domain/entities/grid_point.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/domain/services/path_solver.dart';

class PlaceholderPathSolver implements PathSolver {
  const PlaceholderPathSolver({this._delay = const Duration(milliseconds: 800)});

  final Duration _delay;

  @override
  Future<TaskResult> solve(PathTask task) async {
    await Future<void>.delayed(_delay);
    return TaskResult(task: task, steps: _stepsFor(task.start, task.end));
  }

  List<GridPoint> _stepsFor(GridPoint start, GridPoint end) =>
      start == end ? [start] : [start, end];
}
