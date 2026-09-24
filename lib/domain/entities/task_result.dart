import 'package:equatable/equatable.dart';
import 'package:path_finder/domain/entities/cell_type.dart';
import 'package:path_finder/domain/entities/grid_point.dart';
import 'package:path_finder/domain/entities/path_task.dart';

class TaskResult extends Equatable {
  TaskResult({required this.task, required List<GridPoint> steps})
    : steps = List.unmodifiable(steps);

  final PathTask task;
  final List<GridPoint> steps;

  bool get hasPath => steps.isNotEmpty;

  String get path => steps.join('->');

  CellType cellTypeAt(GridPoint point) {
    if (point == task.start) return CellType.start;
    if (point == task.end) return CellType.end;
    if (_pathCells.contains(point)) return CellType.path;
    if (task.field.isBlocked(point)) return CellType.blocked;
    return CellType.empty;
  }

  late final _pathCells = steps.toSet();

  @override
  List<Object> get props => [task, steps];
}
