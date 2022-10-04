import 'dart:ui';
import 'package:asymmetric_grid/positioned_size.dart';

class Mocks {
  const Mocks._();

  static const size = Size(50, 50);

  static const centerSize = PositionedSize(offset: Offset(25, 25), size: size);

  static const leftTopSize = PositionedSize(offset: Offset(0, 0), size: size);

  static const rightTopSize = PositionedSize(offset: Offset(75, 0), size: size);

  static const rightBottomSize = PositionedSize(offset: Offset(75, 75), size: size);

  static const leftBottomSize = PositionedSize(offset: Offset(0, 75), size: size);
}
