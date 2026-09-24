import 'dart:typed_data';

import 'package:path_finder/domain/entities/grid_field.dart';
import 'package:path_finder/domain/entities/grid_point.dart';

class ShortestPathFinder {
  const ShortestPathFinder();

  static const _directions = [
    (dx: 0, dy: -1), // up
    (dx: 1, dy: 0), // right
    (dx: 0, dy: 1), // down
    (dx: -1, dy: 0), // left
    (dx: 1, dy: -1), // up-right
    (dx: 1, dy: 1), // down-right
    (dx: -1, dy: 1), // down-left
    (dx: -1, dy: -1), // up-left
  ];

  static const _unvisited = -1;

  List<GridPoint>? findPath(GridField field, GridPoint start, GridPoint end) {
    if (!_isWalkable(field, start) || !_isWalkable(field, end)) return null;
    final width = field.width;
    final cellCount = width * field.height;
    final startIndex = start.y * width + start.x;
    final endIndex = end.y * width + end.x;

    final cameFrom = Int32List(cellCount)..fillRange(0, cellCount, _unvisited);
    final queue = Int32List(cellCount);
    var head = 0;
    var tail = 0;

    cameFrom[startIndex] = startIndex;
    queue[tail++] = startIndex;

    while (head < tail) {
      final current = queue[head++];
      if (current == endIndex) break;

      final x = current % width;
      final y = current ~/ width;
      for (final (:dx, :dy) in _directions) {
        final next = GridPoint(x + dx, y + dy);
        if (!_isWalkable(field, next)) continue;

        final nextIndex = next.y * width + next.x;
        if (cameFrom[nextIndex] != _unvisited) continue;
        cameFrom[nextIndex] = current;
        queue[tail++] = nextIndex;
      }
    }

    if (cameFrom[endIndex] == _unvisited) return null;
    return _tracePath(cameFrom, startIndex, endIndex, width);
  }

  bool _isWalkable(GridField field, GridPoint point) =>
      field.contains(point) && !field.isBlocked(point);

  List<GridPoint> _tracePath(Int32List cameFrom, int startIndex, int endIndex, int width) {
    final path = <GridPoint>[];
    for (var index = endIndex; ; index = cameFrom[index]) {
      path.add(GridPoint(index % width, index ~/ width));
      if (index == startIndex) break;
    }
    return path.reversed.toList(growable: false);
  }
}
