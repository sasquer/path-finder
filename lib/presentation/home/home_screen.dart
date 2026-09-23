import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/app/di/injection.dart';
import 'package:path_finder/app/router/app_routes.dart';
import 'package:path_finder/core/ui/toaster.dart';
import 'package:path_finder/presentation/common/error_messages.dart';
import 'package:path_finder/presentation/common/widgets/primary_button_with_loader.dart';
import 'package:path_finder/presentation/home/cubit/home_cubit.dart';
import 'package:path_finder/presentation/home/cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadSavedUrl(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) => previous.restoredUrl != current.restoredUrl,
          listener: _onUrlRestored,
        ),
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onStatusChanged,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Home screen')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set valid API base URL in order to continue',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      BlocSelector<HomeCubit, HomeState, bool>(
                        selector: (state) => state.isLoading,
                        builder: (context, isLoading) => _UrlField(
                          controller: _urlController,
                          enabled: !isLoading,
                          onSubmitted: _submit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: BlocSelector<HomeCubit, HomeState, bool>(
                  selector: (state) => state.isLoading,
                  builder: (context, isLoading) => PrimaryButtonWithLoader(
                    label: 'Start counting process',
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<HomeCubit>().submit(_urlController.text);
  }

  void _onUrlRestored(BuildContext context, HomeState state) {
    final url = state.restoredUrl;
    if (url == null || _urlController.text.isNotEmpty) return;
    _urlController.value = TextEditingValue(
      text: url,
      selection: TextSelection.collapsed(offset: url.length),
    );
  }

  void _onStatusChanged(BuildContext context, HomeState state) {
    switch (state.status) {
      case HomeStatus.failure:
        if (state.failure case final failure?) {
          getIt<Toaster>().show(_messageFor(failure));
        }
      case HomeStatus.success:
        Navigator.of(context).pushNamed(AppRoutes.process, arguments: state.tasks);
      case HomeStatus.initial || HomeStatus.loading:
        break;
    }
  }

  String _messageFor(HomeFailure failure) => switch (failure) {
    InvalidUrlFailure(:final error) => error.userMessage,
    RequestFailure(:final exception) => exception.userMessage,
  };
}

class _UrlField extends StatelessWidget {
  const _UrlField({required this.controller, required this.enabled, required this.onSubmitted});

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      enableSuggestions: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.compare_arrows),
        hintText: 'e.g. https://example.com/api',
      ),
      onSubmitted: (_) => onSubmitted(),
    );
  }
}
