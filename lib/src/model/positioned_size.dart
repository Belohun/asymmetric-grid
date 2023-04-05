import 'dart:ui';

class PositionedSize {
  const PositionedSize({
    required this.offset,
    required this.size,
    required this.widgetHashCode,
  });

  final Offset offset;
  final Size size;
  final int widgetHashCode;

  double get endY => offset.dy + size.height;

  double get endX => offset.dx + size.width;

  PositionedSize copyWith({
    Offset? offset,
    Size? size,
  }) =>
      PositionedSize(
        offset: offset ?? this.offset,
        size: size ?? this.size,
        widgetHashCode: widgetHashCode,
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
        widgetHashCode: widgetHashCode,
      );

  bool isConflictTo(PositionedSize other) => conflictingXTo(other) && conflictingYTo(other);

  bool conflictingXTo(PositionedSize other) => (offset.dx < other.endX && endX > other.offset.dx);

  bool conflictingYTo(PositionedSize other) => (offset.dy < other.endY && endY > other.offset.dy);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PositionedSize &&
        other.offset == offset &&
        other.size == size &&
        other.widgetHashCode == widgetHashCode;
  }

  @override
  int get hashCode => offset.hashCode ^ size.hashCode ^ widgetHashCode.hashCode;
}
