import 'package:equatable/equatable.dart';
import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/validation/url_validation.dart';
import 'package:path_finder/domain/entities/path_task.dart';

enum HomeStatus { initial, loading, success, failure }

sealed class HomeFailure extends Equatable {
  const HomeFailure();
}

final class InvalidUrlFailure extends HomeFailure {
  const InvalidUrlFailure(this.error);

  final UrlValidationError error;

  @override
  List<Object> get props => [error];
}

final class RequestFailure extends HomeFailure {
  const RequestFailure(this.exception);

  final AppException exception;

  @override
  List<Object> get props => [exception];
}

final class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.restoredUrl,
    this.tasks = const [],
    this.failure,
  });

  final HomeStatus status;

  final String? restoredUrl;

  final List<PathTask> tasks;

  final HomeFailure? failure;

  bool get isLoading => status == HomeStatus.loading;

  HomeState copyWith({
    HomeStatus? status,
    String? restoredUrl,
    List<PathTask>? tasks,
    HomeFailure? failure,
  }) {
    return HomeState(
      status: status ?? this.status,
      restoredUrl: restoredUrl ?? this.restoredUrl,
      tasks: tasks ?? this.tasks,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, restoredUrl, tasks, failure];
}
