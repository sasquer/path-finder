import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/domain/entities/grid_field.dart';
import 'package:path_finder/domain/entities/grid_point.dart';
import 'package:path_finder/domain/entities/path_task.dart';

class GridPointDto {
  const GridPointDto({required this.x, required this.y});

  factory GridPointDto.fromJson(Object? json) {
    if (json case {'x': final int x, 'y': final int y}) {
      return GridPointDto(x: x, y: y);
    }
    throw InvalidResponseException('Invalid point: $json');
  }

  factory GridPointDto.fromEntity(GridPoint point) => GridPointDto(x: point.x, y: point.y);

  final int x;
  final int y;

  GridPoint toEntity() => GridPoint(x, y);

  Map<String, String> toJson() => {'x': '$x', 'y': '$y'};
}

class PathTaskDto {
  const PathTaskDto({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  final String id;
  final List<String> field;
  final GridPointDto start;
  final GridPointDto end;

  factory PathTaskDto.fromJson(Object? json) {
    if (json case {
      'id': final String id,
      'field': final List<dynamic> field,
      'start': final Object start,
      'end': final Object end,
    } when field.every((row) => row is String)) {
      return PathTaskDto(
        id: id,
        field: field.cast<String>(),
        start: GridPointDto.fromJson(start),
        end: GridPointDto.fromJson(end),
      );
    }
    throw const InvalidResponseException('Invalid task format');
  }

  static List<PathTaskDto> listFromJson(Object? json) {
    if (json is! List) {
      throw const InvalidResponseException('Tasks must be a list');
    }
    return json.map(PathTaskDto.fromJson).toList(growable: false);
  }

  PathTask toEntity() {
    if (!GridField.isValidShape(field)) {
      throw InvalidResponseException('Task $id has a malformed field');
    }
    final height = field.length;
    final width = field.isEmpty ? 0 : field.first.length;
    if (!GridField.isSupportedSize(width: width, height: height)) {
      throw UnsupportedFieldSizeException(taskId: id, width: width, height: height);
    }
    final grid = GridField(field);
    final startPoint = start.toEntity();
    final endPoint = end.toEntity();
    if (!grid.contains(startPoint) || !grid.contains(endPoint)) {
      throw InvalidResponseException('Task $id has start or end outside the field');
    }
    return PathTask(id: id, field: grid, start: startPoint, end: endPoint);
  }
}
