import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';

abstract interface class PathSolver {
  Future<TaskResult> solve(PathTask task);
}
