import 'package:path_finder/data/dto/path_task_dto.dart';
import 'package:path_finder/domain/entities/task_result.dart';

class TaskResultDto {
  const TaskResultDto({
    required this.id,
    required this.steps,
    required this.path,
  });

  factory TaskResultDto.fromEntity(TaskResult result) => TaskResultDto(
    id: result.task.id,
    steps: result.steps.map(GridPointDto.fromEntity).toList(growable: false),
    path: result.path,
  );

  final String id;
  final List<GridPointDto> steps;
  final String path;

  Map<String, Object> toJson() => {
    'id': id,
    'result': {
      'steps': [for (final step in steps) step.toJson()],
      'path': path,
    },
  };
}