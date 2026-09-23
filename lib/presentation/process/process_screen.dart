import 'package:flutter/material.dart';
import 'package:path_finder/domain/entities/path_task.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key, required this.tasks});

  final List<PathTask> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process screen')),
      body: const SizedBox.shrink(),
    );
  }
}
