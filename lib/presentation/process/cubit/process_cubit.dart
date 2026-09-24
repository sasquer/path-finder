import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/logging/app_logger.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/domain/services/path_solver.dart';
import 'package:path_finder/presentation/process/cubit/process_state.dart';

class ProcessCubit extends Cubit<ProcessState> {
  ProcessCubit({
    required List<PathTask> tasks,
    required this._pathSolver,
    this._logger = const DefaultLogger(),
  }) : _tasks = List.unmodifiable(tasks),
       super(ProcessInProgress(processed: 0, total: tasks.length));

  final List<PathTask> _tasks;
  final PathSolver _pathSolver;
  final AppLogger _logger;

  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    final results = <TaskResult>[];
    try {
      for (final task in _tasks) {
        _logger.info('Calculating ${_tasks.length} tasks');
        final result = await _pathSolver.solve(task);
        if (isClosed) {
          _logger.info(
            'Calculation stopped after ${results.length + 1} of ${_tasks.length} tasks: the screen was closed',
          );
          return;
        }
        results.add(result);
        emit(ProcessInProgress(processed: results.length, total: _tasks.length));
      }
      emit(ProcessCompleted(results));
    } on Exception catch (error, stackTrace) {
      _logger.error(
        'Calculation failed after ${results.length} of ${_tasks.length} tasks',
        error,
        stackTrace,
      );
      if (isClosed) return;
      emit(ProcessFailed(processed: results.length, total: _tasks.length, error: error));
    }
  }
}
