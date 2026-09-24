import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_finder/domain/entities/cell_type.dart';
import 'package:path_finder/domain/entities/grid_point.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/presentation/common/widgets/path_text.dart';
import 'package:path_finder/presentation/preview/widgets/field_view.dart';
import 'package:path_finder/presentation/theme/app_theme.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.result});

  final TaskResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview screen')),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(flex: 3, child: FieldView(result: result)),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: PathText(result: result, style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldGrid extends StatelessWidget {
  const _FieldGrid({required this.result});

  final TaskResult result;

  static const _readableCellSize = 64.0;

  @override
  Widget build(BuildContext context) {
    final field = result.task.field;
    return AspectRatio(
      aspectRatio: field.width / field.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth / field.width;
          return InteractiveViewer(
            maxScale: math.max(1, _readableCellSize / cellSize),
            child: Table(
              border: TableBorder.all(color: AppColors.cellBorder),
              children: [
                for (var y = 0; y < field.height; y++)
                  TableRow(
                    children: [
                      for (var x = 0; x < field.width; x++)
                        _Cell(result: result, point: GridPoint(x, y)),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.result, required this.point});

  final TaskResult result;
  final GridPoint point;

  @override
  Widget build(BuildContext context) {
    final type = result.cellTypeAt(point);
    return AspectRatio(
      aspectRatio: 1,
      child: ColoredBox(
        color: switch (type) {
          CellType.start => AppColors.startCell,
          CellType.end => AppColors.endCell,
          CellType.path => AppColors.pathCell,
          CellType.blocked => AppColors.blockedCell,
          CellType.empty => AppColors.emptyCell,
        },
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$point',
              style: TextStyle(
                color: type == CellType.blocked ? AppColors.blockedCellText : AppColors.cellText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
