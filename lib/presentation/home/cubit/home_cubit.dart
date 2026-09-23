import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/validation/url_validation.dart';
import 'package:path_finder/domain/repositories/api_url_repository.dart';
import 'package:path_finder/domain/repositories/tasks_repository.dart';
import 'package:path_finder/presentation/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this._apiUrlRepository,
    required this._tasksRepository,
    required this._urlValidator,
  }) : super(const HomeState());

  final ApiUrlRepository _apiUrlRepository;
  final TasksRepository _tasksRepository;
  final UrlValidator _urlValidator;

  Future<void> loadSavedUrl() async {
    try {
      final url = await _apiUrlRepository.getSavedUrl();
      if (url != null) _emitIfOpen(state.copyWith(restoredUrl: url));
    } on AppException {
      // Nothing to process, url not saved yet
    }
  }

  Future<void> submit(String rawUrl) async {
    if (state.isLoading) return;

    emit(state.copyWith(status: HomeStatus.loading));

    final Uri uri;
    switch (_urlValidator.validate(rawUrl)) {
      case InvalidUrl(:final error):
        emit(state.copyWith(status: HomeStatus.failure, failure: InvalidUrlFailure(error)));
        return;
      case ValidUrl(uri: final validUri):
        uri = validUri;
    }

    try {
      await _apiUrlRepository.saveUrl(uri.toString());
      final tasks = await _tasksRepository.fetchTasks(uri);
      _emitIfOpen(state.copyWith(status: HomeStatus.success, tasks: tasks));
    } on AppException catch (exception) {
      _emitIfOpen(state.copyWith(status: HomeStatus.failure, failure: RequestFailure(exception)));
    }
  }

  void _emitIfOpen(HomeState newState) {
    if (!isClosed) emit(newState);
  }
}
