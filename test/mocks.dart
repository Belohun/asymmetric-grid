import 'dart:ui';
import 'package:asymmetric_grid/src/model/positioned_size.dart';

class PositionedSizeMock extends PositionedSize {
  const PositionedSizeMock({
    required super.offset,
    required super.size,
    super.widgetHashCode = 0,
  });
}

class Mocks {
  const Mocks._();

  static const sideSize = 50.0;
  static const sideSizeBig = 75.0;
  static const centerPosition = 25.0;

  static const size = Size(
    sideSize,
    sideSize,
  );

  static const sizeBig = Size(
    sideSizeBig,
    sideSizeBig,
  );

  static const centerSize = PositionedSizeMock(
    offset: Offset(
      centerPosition,
      centerPosition,
    ),
    size: size,
  );

  static const leftTopSize = PositionedSizeMock(
    offset: Offset(
      0,
      0,
    ),
    size: size,
  );

  static const rightTopSize = PositionedSizeMock(
    offset: Offset(
      sideSize,
      0,
    ),
    size: size,
  );

  static const rightBottomSize = PositionedSizeMock(
    offset: Offset(
      sideSize,
      sideSize,
    ),
    size: size,
  );

  static const leftBottomSize = PositionedSizeMock(
    offset: Offset(
      0,
      sideSize,
    ),
    size: size,
  );

  static const belowCenterSize = PositionedSizeMock(
    offset: Offset(
      centerPosition,
      sideSize + sideSize,
    ),
    size: size,
  );

  static const belowCenterSizeBig = PositionedSizeMock(
    offset: Offset(
      centerPosition,
      sideSize + sideSize,
    ),
    size: sizeBig,
  );
}
