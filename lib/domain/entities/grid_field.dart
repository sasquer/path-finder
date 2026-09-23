import 'package:equatable/equatable.dart';
import 'package:path_finder/domain/entities/grid_point.dart';

class GridField extends Equatable {
  GridField(List<String> rows)
    : assert(isValidShape(rows), 'Rows must form a non-empty rectangle'),
      rows = List.unmodifiable(rows);

  static const blockedCell = 'X';

  final List<String> rows;

  int get height => rows.length;

  int get width => rows.first.length;

  static bool isValidShape(List<String> rows) =>
      rows.isNotEmpty &&
      rows.first.isNotEmpty &&
      rows.every((row) => row.length == rows.first.length);

  bool contains(GridPoint point) =>
      point.x >= 0 && point.x < width && point.y >= 0 && point.y < height;

  bool isBlocked(GridPoint point) => rows[point.y][point.x] == blockedCell;

  @override
  List<Object> get props => [rows];
}
