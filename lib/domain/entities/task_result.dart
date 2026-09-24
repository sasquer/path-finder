import 'package:equatable/equatable.dart';
import 'package:path_finder/domain/entities/grid_point.dart';
import 'package:path_finder/domain/entities/path_task.dart';

class TaskResult extends Equatable {
  TaskResult({required this.task, required List<GridPoint> steps})
    : steps = List.unmodifiable(steps);

  final PathTask task;
  final List<GridPoint> steps;

  bool get hasPath => steps.isNotEmpty;

  String get path => steps.join('->');

  @override
  List<Object> get props => [task, steps];
}
