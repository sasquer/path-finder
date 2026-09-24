import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';

abstract interface class TasksRepository {
  Future<List<PathTask>> fetchTasks(Uri url);

  Future<void> sendResults(Uri url, List<TaskResult> results);
}
