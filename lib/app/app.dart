
import 'package:flutter/material.dart';
import 'package:path_finder/app/router/app_router.dart';
import 'package:path_finder/app/router/app_routes.dart';
import 'package:path_finder/presentation/theme/app_theme.dart';

class PathFinderApp extends StatelessWidget {
  const PathFinderApp({super.key});

  static const _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Finder',
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}