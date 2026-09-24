import 'package:equatable/equatable.dart';
import 'package:path_finder/domain/entities/grid_point.dart';

class GridField extends Equatable {
  GridField(List<String> rows)
    : assert(isValidShape(rows), 'All rows must have the same length'),
      assert(
        isSupportedSize(width: rows.isEmpty ? 0 : rows.first.length, height: rows.length),
        'Field size must be within $minSize..$maxSize in both dimensions',
      ),
      assert(_hasOnlyKnownMarks(rows), 'Every cell must be either "$freeCell" or "$blockedCell"'),
      rows = List.unmodifiable(rows);

  static const freeCell = '.';
  static const blockedCell = 'X';

  static const minSize = 1;
  static const maxSize = 100;

  final List<String> rows;

  int get height => rows.length;

  int get width => rows.first.length;

  static bool isValidShape(List<String> rows) =>
      rows.isNotEmpty &&
      rows.first.isNotEmpty &&
      rows.every((row) => row.length == rows.first.length);

  static bool isSupportedSize({required int width, required int height}) =>
      _isSupportedDimension(width) && _isSupportedDimension(height);

  static bool _isSupportedDimension(int size) => size >= minSize && size <= maxSize;

  static bool _hasOnlyKnownMarks(List<String> rows) =>
      rows.every((row) => row.split('').every((cell) => cell == freeCell || cell == blockedCell));

  bool contains(GridPoint point) =>
      point.x >= 0 && point.x < width && point.y >= 0 && point.y < height;

  bool isBlocked(GridPoint point) => rows[point.y][point.x] == blockedCell;

  @override
  List<Object> get props => [rows];
}
