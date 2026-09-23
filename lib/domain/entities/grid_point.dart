import 'package:equatable/equatable.dart';

class GridPoint extends Equatable {
  const GridPoint(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object> get props => [x, y];

  @override
  String toString() => '($x,$y)';
}
