import 'package:path_finder/domain/entities/path_task.dart';

abstract interface class TasksRepository {
  Future<List<PathTask>> fetchTasks(Uri url);
}
