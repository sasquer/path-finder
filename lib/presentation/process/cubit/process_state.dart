import 'package:equatable/equatable.dart';
import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/domain/entities/task_result.dart';

sealed class ProcessState extends Equatable {
  const ProcessState({required this.processed, required this.total});

  final int processed;

  final int total;

  double get progress => total == 0 ? 1 : processed / total;

  int get percent => total == 0 ? 100 : processed * 100 ~/ total;

  @override
  List<Object?> get props => [processed, total];
}

final class ProcessInProgress extends ProcessState {
  const ProcessInProgress({required super.processed, required super.total});
}

enum SendStatus { idle, sending, success, failure }

final class ProcessCompleted extends ProcessState {
  ProcessCompleted(List<TaskResult> results, {this.sendStatus = SendStatus.idle, this.sendError,})
      : results = List.unmodifiable(results),
        super(processed: results.length, total: results.length);


  final List<TaskResult> results;
  final SendStatus sendStatus;
  final AppException? sendError;

  bool get isSending => sendStatus == SendStatus.sending;

  bool get isSent => sendStatus == SendStatus.success;

  @override
  List<Object?> get props => [...super.props, results, sendStatus, sendError];
}

final class ProcessFailed extends ProcessState {
  const ProcessFailed({required super.processed, required super.total, required this.error});

  final Object error;

  @override
  List<Object?> get props => [...super.props, error];
}
