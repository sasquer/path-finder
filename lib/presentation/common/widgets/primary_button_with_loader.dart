import 'package:flutter/material.dart';
import 'package:path_finder/presentation/theme/app_theme.dart';

class PrimaryButtonWithLoader extends StatelessWidget {
  const PrimaryButtonWithLoader({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  static const _height = 56.0;
  static const _loaderSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _height,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox.square(
                dimension: _loaderSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.buttonForeground,
                ),
              )
            : Text(label),
      ),
    );
  }
}
