import 'package:flutter/material.dart';
import 'package:path_finder/app/router/app_routes.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/presentation/common/widgets/path_text.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({super.key, required this.results});

  final List<TaskResult> results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result list screen')),
      body: SafeArea(
        child: results.isEmpty
            ? const _EmptyView()
            : ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, index) => _ResultTile(result: results[index]),
              ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'There are no tasks to show',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result});

  final TaskResult result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: PathText(result: result),
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.preview, arguments: result),
    );
  }
}
