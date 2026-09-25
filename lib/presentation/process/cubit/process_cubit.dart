import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/logging/app_logger.dart';
import 'package:path_finder/core/validation/url_validation.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/domain/repositories/api_url_repository.dart';
import 'package:path_finder/domain/repositories/tasks_repository.dart';
import 'package:path_finder/domain/services/path_solver.dart';
import 'package:path_finder/presentation/process/cubit/process_state.dart';

class ProcessCubit extends Cubit<ProcessState> {
  ProcessCubit({
    required List<PathTask> tasks,
    required this._pathSolver,
    required this._tasksRepository,
    required this._apiUrlRepository,
    required this._urlValidator,
    this._logger = const DefaultLogger(),
  }) : _tasks = List.unmodifiable(tasks),
       super(ProcessInProgress(processed: 0, total: tasks.length));

  final List<PathTask> _tasks;
  final PathSolver _pathSolver;
  final TasksRepository _tasksRepository;
  final ApiUrlRepository _apiUrlRepository;
  final UrlValidator _urlValidator;
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

  Future<void> sendResults() async {
    final current = state;
    if (current is! ProcessCompleted || current.isSending || current.isSent) return;
    final results = current.results;

    emit(ProcessCompleted(results, sendStatus: SendStatus.sending));
    try {
      final url = await _savedUrl();
      await _tasksRepository.sendResults(url, results);
      _emitIfOpen(ProcessCompleted(results, sendStatus: SendStatus.success));
    } on AppException catch (error) {
      _emitIfOpen(ProcessCompleted(results, sendStatus: SendStatus.failure, sendError: error));
    }
  }

  Future<Uri> _savedUrl() async {
    final String? savedUrl;
    try {
      savedUrl = await _apiUrlRepository.getSavedUrl();
    } on StorageException catch (e) {
      _logger.warning('Failed to read the saved API URL', e);
      throw const MissingApiUrlException();
    }
    switch (_urlValidator.validate(savedUrl ?? '')) {
      case ValidUrl(:final uri):
        return uri;
      case InvalidUrl(:final error):
        _logger.warning('No valid API URL is saved: $error');
        throw const MissingApiUrlException();
    }
  }

  void _emitIfOpen(ProcessState newState) {
    if (!isClosed) emit(newState);
  }
}
