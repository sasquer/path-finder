import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/domain/services/path_solver.dart';
import 'package:path_finder/presentation/process/cubit/process_state.dart';

class ProcessCubit extends Cubit<ProcessState> {
  ProcessCubit({required List<PathTask> tasks, required this._pathSolver})
    : _tasks = List.unmodifiable(tasks),
      super(ProcessInProgress(processed: 0, total: tasks.length));

  final List<PathTask> _tasks;
  final PathSolver _pathSolver;

  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    final results = <TaskResult>[];
    try {
      for (final task in _tasks) {
        final result = await _pathSolver.solve(task);
        if (isClosed) return;
        results.add(result);
        emit(ProcessInProgress(processed: results.length, total: _tasks.length));
      }
      emit(ProcessCompleted(results));
    } on Exception catch (error) {
      if (isClosed) return;
      emit(ProcessFailed(processed: results.length, total: _tasks.length, error: error));
    }
  }
}
