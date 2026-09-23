import 'package:path_finder/core/network/api_client.dart';
import 'package:path_finder/data/dto/api_response_dto.dart';
import 'package:path_finder/data/dto/path_task_dto.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<PathTask>> fetchTasks(Uri url) async {
    final json = await _apiClient.getJson(url);
    final data = ApiResponseDto.fromJson(json).requireData();
    return PathTaskDto.listFromJson(data).map((dto) => dto.toEntity()).toList(growable: false);
  }
}
