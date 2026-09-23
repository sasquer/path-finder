import 'package:flutter/material.dart';
import 'package:path_finder/app/app.dart';
import 'package:path_finder/app/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const PathFinderApp());
}
