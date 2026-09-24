import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/logging/app_logger.dart';
import 'package:path_finder/core/network/api_client.dart';
import 'package:path_finder/data/dto/api_response_dto.dart';
import 'package:path_finder/data/dto/path_task_dto.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl(this._apiClient, {this._logger = const DefaultLogger()});

  final ApiClient _apiClient;
  final AppLogger _logger;

  @override
  Future<List<PathTask>> fetchTasks(Uri url) async {
    final json = await _apiClient.getJson(url);
    try {
      final data = ApiResponseDto.fromJson(json).requireData();
      final tasks = PathTaskDto.listFromJson(
        data,
      ).map((dto) => dto.toEntity()).toList(growable: false);
      _logger.info(
        'Received ${tasks.length} tasks:${tasks.map((task) => '\n-- ${_describe(task)}').join()}',
      );
      return tasks;
    } on AppException catch (e) {
      _logger.warning('Tasks response rejected', e);
      rethrow;
    }
  }

  static String _describe(PathTask task) =>
      '${task.id}: ${task.field.width}x${task.field.height} field, ${task.start} -> ${task.end}';
}
