import 'package:flutter/material.dart';
import 'package:path_finder/domain/entities/task_result.dart';

class PathText extends StatelessWidget {
  const PathText({super.key, required this.result, this.style});

  final TaskResult result;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (result.hasPath) {
      return Text(result.path, textAlign: TextAlign.center, style: style);
    }
    return Text(
      'No path found',
      textAlign: TextAlign.center,
      style: (style ?? const TextStyle()).copyWith(color: Theme.of(context).colorScheme.error),
    );
  }
}
