import 'package:asymmetric_grid/src/model/positioned_size.dart';

void main() {

}

extension on PositionedSize {
  bool positionKept(PositionedSize other) {
    return other.endY == endY || other.endX == endX || other.offset.dy == offset.dy || other.offset.dx == offset.dx;
  }
}
