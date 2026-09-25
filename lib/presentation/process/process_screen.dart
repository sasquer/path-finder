import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/app/di/injection.dart';
import 'package:path_finder/app/router/app_routes.dart';
import 'package:path_finder/core/ui/toaster.dart';
import 'package:path_finder/domain/entities/path_task.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/presentation/common/error_messages.dart';
import 'package:path_finder/presentation/common/widgets/primary_button_with_loader.dart';
import 'package:path_finder/presentation/process/cubit/process_cubit.dart';
import 'package:path_finder/presentation/process/cubit/process_state.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key, required this.tasks});

  final List<PathTask> tasks;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProcessCubit>(param1: tasks)..start(),
      child: const _ProcessView(),
    );
  }
}

class _ProcessView extends StatelessWidget {
  const _ProcessView();

  static SendStatus? _sendStatusOf(ProcessState state) =>
      state is ProcessCompleted ? state.sendStatus : null;

  void _onSendStatusChanged(BuildContext context, ProcessState state) {
    switch (state) {
      case ProcessCompleted(sendStatus: SendStatus.success, :final results):
        _showResults(context, results);
      case ProcessCompleted(sendStatus: SendStatus.failure, :final sendError?):
        getIt<Toaster>().show(sendError.userMessage);
      default:
        break;
    }
  }

  static void _showResults(BuildContext context, List<TaskResult> results) {
    Navigator.of(context).pushNamed(AppRoutes.resultList, arguments: results);
  }

  static Widget _actionButton(BuildContext context, ProcessCompleted state) {
    if (state.isSent) {
      return PrimaryButtonWithLoader(
        label: 'Show results',
        onPressed: () => _showResults(context, state.results),
      );
    }
    return PrimaryButtonWithLoader(
      label: 'Send results to server',
      isLoading: state.isSending,
      onPressed: context.read<ProcessCubit>().sendResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProcessCubit, ProcessState>(
      listenWhen: (previous, current) => _sendStatusOf(previous) != _sendStatusOf(current),
      listener: _onSendStatusChanged,
      child: Scaffold(
        appBar: AppBar(title: const Text('Process screen')),
        body: SafeArea(
          child: BlocBuilder<ProcessCubit, ProcessState>(
            builder: (context, state) => Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _ProgressView(state: state),
                    ),
                  ),
                ),
                if (state is ProcessCompleted)
                  Padding(padding: const EdgeInsets.all(16), child: _actionButton(context, state)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView({required this.state});

  final ProcessState state;

  static const _indicatorSize = 120.0;

  String get _message => switch (state) {
    ProcessInProgress() => 'Calculating the shortest paths, please wait',
    ProcessCompleted(isSent: true) => 'The results have been sent to the server',
    ProcessCompleted() => 'All calculations has finished, you can send your results to server',
    ProcessFailed() => 'Failed to calculate the paths. Go back and try again',
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_message, textAlign: TextAlign.center, style: textTheme.titleMedium),
        const SizedBox(height: 16),
        Text('${state.percent}%', style: textTheme.headlineSmall),
        const Divider(height: 24),
        SizedBox.square(
          dimension: _indicatorSize,
          child: CircularProgressIndicator(
            value: state.progress,
            strokeWidth: 4,
            color: state is ProcessFailed ? Theme.of(context).colorScheme.error : null,
          ),
        ),
      ],
    );
  }
}
