import 'dart:ui';
import 'package:asymmetric_grid/positioned_size.dart';

class PositionedSizeMock extends PositionedSize {
  const PositionedSizeMock({
    required super.offset,
    required super.size,
    super.widgetHashCode = 0,
  });
}

class Mocks {
  const Mocks._();

  static const size = Size(50, 50);

  static const centerSize = PositionedSizeMock(offset: Offset(25, 25), size: size);

  static const leftTopSize = PositionedSizeMock(offset: Offset(0, 0), size: size);

  static const rightTopSize = PositionedSizeMock(offset: Offset(75, 0), size: size);

  static const rightBottomSize = PositionedSizeMock(offset: Offset(75, 75), size: size);

  static const leftBottomSize = PositionedSizeMock(offset: Offset(0, 75), size: size);
}
