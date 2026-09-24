import 'package:flutter/material.dart';
import 'package:path_finder/app/router/app_routes.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/presentation/home/home_screen.dart';
import 'package:path_finder/presentation/preview/preview_screen.dart';
import 'package:path_finder/presentation/process/process_screen.dart';
import 'package:path_finder/presentation/result_list/result_list_screen.dart';

class AppRouter {
  const AppRouter();

  Route<void> onGenerateRoute(RouteSettings settings) {
    final Widget screen = switch ((settings.name, settings.arguments)) {
      (AppRoutes.process, final List<PathTask> tasks) => ProcessScreen(tasks: tasks),
      (AppRoutes.resultList, final List<TaskResult> results) => ResultListScreen(results: results),
      (AppRoutes.preview, final TaskResult result) => PreviewScreen(result: result),
      _ => const HomeScreen(),
    };
    return MaterialPageRoute(settings: settings, builder: (_) => screen);
  }
}
