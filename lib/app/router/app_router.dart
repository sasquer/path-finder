import 'package:flutter/material.dart';
import 'package:path_finder/app/router/app_routes.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/presentation/home/home_screen.dart';
import 'package:path_finder/presentation/process/process_screen.dart';

class AppRouter {
  const AppRouter();

  Route<void> onGenerateRoute(RouteSettings settings) {
    final Widget screen = switch ((settings.name, settings.arguments)) {
      (AppRoutes.process, final List<PathTask> tasks) => ProcessScreen(tasks: tasks),
      _ => const HomeScreen(),
    };
    return MaterialPageRoute(settings: settings, builder: (_) => screen);
  }
}
