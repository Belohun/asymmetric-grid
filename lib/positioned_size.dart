import 'dart:ui';

class PositionedSize {
  const PositionedSize({
    required this.offset,
    required this.size,
  });

  final Offset offset;
  final Size size;

  double get endY => offset.dy + size.height;

  double get endX => offset.dx + size.width;

  PositionedSize copyWith({
    Offset? offset,
    Size? size,
  }) =>
      PositionedSize(
        offset: offset ?? this.offset,
        size: size ?? this.size,
      );

  PositionedSize updatePosition({
    double? y,
    double? x,
  }) =>
      PositionedSize(
        offset: Offset(
          x ?? offset.dx,
          y ?? offset.dy,
        ),
        size: size,
      );

  bool isConflictTo(PositionedSize other) => conflictingXTo(other) && conflictingYTo(other);

  bool conflictingXTo(PositionedSize other) =>
      (other.offset.dx <= offset.dx && offset.dx <= other.endX) || (other.offset.dx <= endX && endX <= other.endX);

  bool conflictingYTo(PositionedSize other) =>
      (other.offset.dy <= offset.dy && offset.dy <= other.endY) || (other.offset.dy <= endY && endY <= other.endY);
}