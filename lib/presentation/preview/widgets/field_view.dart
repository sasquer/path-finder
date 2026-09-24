import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/presentation/preview/widgets/field_painters.dart';

class FieldView extends StatefulWidget {
  const FieldView({super.key, required this.result});

  final TaskResult result;

  @override
  State<FieldView> createState() => _FieldViewState();
}

class _FieldViewState extends State<FieldView> {
  final _transformation = TransformationController();

  static const _readableCellSize = 64.0;

  @override
  void dispose() {
    _transformation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.result.task.field;
    return AspectRatio(
      aspectRatio: field.width / field.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth / field.width;
          return Stack(
            fit: StackFit.expand,
            children: [
              InteractiveViewer(
                transformationController: _transformation,
                maxScale: math.max(1, _readableCellSize / cellSize),
                child: RepaintBoundary(
                  child: CustomPaint(painter: FieldCellsPainter(widget.result)),
                ),
              ),
              IgnorePointer(
                child: CustomPaint(
                  painter: CellCoordinatesPainter(
                    result: widget.result,
                    transformation: _transformation,
                    style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
