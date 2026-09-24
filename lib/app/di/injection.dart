import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:path_finder/core/network/api_client.dart';
import 'package:path_finder/core/network/http_api_client.dart';
import 'package:path_finder/core/storage/key_value_storage.dart';
import 'package:path_finder/core/storage/shared_preferences_storage.dart';
import 'package:path_finder/core/ui/toaster.dart';
import 'package:path_finder/core/validation/url_validation.dart';
import 'package:path_finder/data/repositories/api_url_repository_impl.dart';
import 'package:path_finder/data/repositories/tasks_repository_impl.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/repositories/api_url_repository.dart';
import 'package:path_finder/domain/repositories/tasks_repository.dart';
import 'package:path_finder/domain/services/isolate_path_solver.dart';
import 'package:path_finder/domain/services/path_solver.dart';
import 'package:path_finder/presentation/home/cubit/home_cubit.dart';
import 'package:path_finder/presentation/process/cubit/process_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<http.Client>(http.Client.new, dispose: (client) => client.close())
    ..registerLazySingleton<ApiClient>(() => HttpApiClient(getIt()))
    ..registerLazySingleton<KeyValueStorage>(
      () => SharedPreferencesStorage(SharedPreferencesAsync()),
    )
    ..registerLazySingleton<UrlValidator>(() => const UrlValidator())
    ..registerLazySingleton<Toaster>(() => const FlutterToastToaster())
    ..registerLazySingleton<ApiUrlRepository>(() => ApiUrlRepositoryImpl(getIt()))
    ..registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl(getIt()))
    ..registerLazySingleton<PathSolver>(() => const IsolatePathSolver())
    ..registerFactory<HomeCubit>(
      () => HomeCubit(apiUrlRepository: getIt(), tasksRepository: getIt(), urlValidator: getIt()),
    )
    ..registerFactoryParam<ProcessCubit, List<PathTask>, void>(
      (tasks, _) => ProcessCubit(tasks: tasks, pathSolver: getIt()),
    );
}
