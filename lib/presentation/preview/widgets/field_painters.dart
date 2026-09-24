import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_finder/domain/entities/cell_type.dart';
import 'package:path_finder/domain/entities/grid_point.dart';
import 'package:path_finder/domain/entities/task_result.dart';
import 'package:path_finder/presentation/theme/app_theme.dart';

class FieldCellsPainter extends CustomPainter {
  const FieldCellsPainter(this.result);

  final TaskResult result;

  static const _lineWidthFactor = 0.01;

  @override
  void paint(Canvas canvas, Size size) {
    final field = result.task.field;
    final cellSize = size.width / field.width;

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.emptyCell);
    final cellPaint = Paint()..isAntiAlias = false;
    for (var y = 0; y < field.height; y++) {
      for (var x = 0; x < field.width; x++) {
        final type = result.cellTypeAt(GridPoint(x, y));
        if (type == CellType.empty) continue;
        cellPaint.color = _colorOf(type);
        canvas.drawRect(Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize), cellPaint);
      }
    }

    final linePaint = Paint()
      ..color = AppColors.cellBorder
      ..strokeWidth = cellSize * _lineWidthFactor;
    for (var x = 0; x <= field.width; x++) {
      final dx = x * cellSize;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), linePaint);
    }
    for (var y = 0; y <= field.height; y++) {
      final dy = y * cellSize;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), linePaint);
    }
  }

  static Color _colorOf(CellType type) => switch (type) {
    CellType.start => AppColors.startCell,
    CellType.end => AppColors.endCell,
    CellType.path => AppColors.pathCell,
    CellType.blocked => AppColors.blockedCell,
    CellType.empty => AppColors.emptyCell,
  };

  @override
  bool shouldRepaint(FieldCellsPainter oldDelegate) => oldDelegate.result != result;
}

typedef CellLabel = ({GridPoint point, Offset center, double fontSize, Color color});

class CellCoordinatesPainter extends CustomPainter {
  CellCoordinatesPainter({required this.result, required this.transformation, required this.style})
    : super(repaint: transformation);

  final TaskResult result;
  final TransformationController transformation;
  final TextStyle style;

  static const _fontSize = 14.0;

  static const _minFontSize = 8.0;

  static const _maxTextWidthFactor = 0.8;

  late final double _longestLabelWidth = _measure(
    GridPoint(result.task.field.width - 1, result.task.field.height - 1),
  );

  @visibleForTesting
  List<CellLabel> labels(Size size) {
    final field = result.task.field;
    final matrix = transformation.value;
    final cellSize = size.width / field.width;
    final fontSize =
        _fontSize *
        math.min(1, cellSize * _maxTextWidthFactor / _longestLabelWidth) *
        matrix.getMaxScaleOnAxis();
    if (fontSize < _minFontSize) return const [];

    final visible = MatrixUtils.inverseTransformRect(matrix, Offset.zero & size);
    final firstX = math.max(0, (visible.left / cellSize).floor());
    final lastX = math.min(field.width, (visible.right / cellSize).ceil());
    final firstY = math.max(0, (visible.top / cellSize).floor());
    final lastY = math.min(field.height, (visible.bottom / cellSize).ceil());

    return [
      for (var y = firstY; y < lastY; y++)
        for (var x = firstX; x < lastX; x++)
          (
            point: GridPoint(x, y),
            center: MatrixUtils.transformPoint(
              matrix,
              Offset((x + 0.5) * cellSize, (y + 0.5) * cellSize),
            ),
            fontSize: fontSize,
            color: result.cellTypeAt(GridPoint(x, y)) == CellType.blocked
                ? AppColors.blockedCellText
                : AppColors.cellText,
          ),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    for (final label in labels(size)) {
      final painter = _layout(
        label.point,
        style.copyWith(fontSize: label.fontSize, color: label.color),
      );
      painter.paint(canvas, label.center - Offset(painter.width / 2, painter.height / 2));
      painter.dispose();
    }
  }

  double _measure(GridPoint point) {
    final painter = _layout(point, style.copyWith(fontSize: _fontSize));
    final width = painter.width;
    painter.dispose();
    return width;
  }

  static TextPainter _layout(GridPoint point, TextStyle style) => TextPainter(
    text: TextSpan(text: '$point', style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  @override
  bool shouldRepaint(CellCoordinatesPainter oldDelegate) =>
      oldDelegate.result != result ||
      oldDelegate.transformation != transformation ||
      oldDelegate.style != style;
}
