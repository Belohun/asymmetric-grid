import 'package:asymmetric_grid/asymmetric_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class AsymmetricGridView extends MultiChildRenderObjectWidget {
  ///Creates array of children that will position themselves in closest available position.
  AsymmetricGridView({
    required super.children,
    this.gridDirection = Axis.vertical,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    super.key,
  })  : alignmentDirection = gridDirection == Axis.vertical ? Axis.horizontal : Axis.vertical,
        crossAxisWidgetCount = 1;

  AsymmetricGridView.sameDirectionAlignment({
    required super.children,
    required this.crossAxisWidgetCount,
    this.gridDirection = Axis.vertical,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    super.key,
  }) : alignmentDirection = gridDirection;

  ///Direction that layout will expand to.
  final Axis gridDirection;

  ///Space that takes between children in main axis.
  final double mainAxisSpacing;

  ///Space that takes between children in cross axis.
  final double crossAxisSpacing;

  ///Defines which direction children will take when placing themselves in the layout.
  ///F.e if [gridDirection] is set to [Axis.vertical], first child will be set at the top left corner
  ///and the second child will be placed under the first child.
  final Axis alignmentDirection;

  ///Widget count in crossAxis direction to [gridDirection]. This only affects when [gridDirection] is in same direction as [alignmentDirection].
  final int crossAxisWidgetCount;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAsymmetricGrid(
      widgetList: children,
      gridDirection: gridDirection,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      alignmentDirection: alignmentDirection,
      crossAxisWidgetCount: crossAxisWidgetCount,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderAsymmetricGrid renderObject) {
    renderObject
      ..gridDirection = gridDirection
      ..crossAxisSpacing = crossAxisSpacing
      ..mainAxisSpacing = mainAxisSpacing
      ..alignmentDirection = alignmentDirection
      ..crossAxisWidgetCount = crossAxisWidgetCount;
  }
}

class AsymmetricGridParentData extends ContainerBoxParentData<RenderBox> {}

class RenderAsymmetricGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, AsymmetricGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, AsymmetricGridParentData> {
  RenderAsymmetricGrid({
    required Axis gridDirection,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
    required Axis alignmentDirection,
    required int crossAxisWidgetCount,
    required this.widgetList,
  })  : _gridDirection = gridDirection,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing,
        _alignmentDirection = alignmentDirection,
        _crossAxisWidgetCount = crossAxisWidgetCount;

  final List<Widget> widgetList;

  Axis _gridDirection;

  Axis get gridDirection => _gridDirection;

  set gridDirection(Axis value) {
    if (value == _gridDirection) return;
    _gridDirection = value;
    markParentNeedsLayout();
  }

  Axis _alignmentDirection;

  Axis get alignmentDirection => _alignmentDirection;

  set alignmentDirection(Axis value) {
    if (value == _alignmentDirection) return;
    _alignmentDirection = value;
    markParentNeedsLayout();
  }

  double _mainAxisSpacing;

  double get mainAxisSpacing => _mainAxisSpacing;

  set mainAxisSpacing(double value) {
    assert(value >= 0, 'mainAxisSpacing must be greater than or equal to zero.');
    if (value == _mainAxisSpacing) return;
    _mainAxisSpacing = value;
    markParentNeedsLayout();
  }

  double _crossAxisSpacing;

  double get crossAxisSpacing => _crossAxisSpacing;

  set crossAxisSpacing(double value) {
    assert(value >= 0, 'crossAxisSpacing must be greater than or equal to zero.');
    if (value == _crossAxisSpacing) return;
    _crossAxisSpacing = value;
    markParentNeedsLayout();
  }

  int _crossAxisWidgetCount;

  int get crossAxisWidgetCount => _crossAxisWidgetCount;

  set crossAxisWidgetCount(int value) {
    assert(value > 0, 'CrossAxisWidgetCount must be greater than zero.');
    if (value == _crossAxisWidgetCount) return;
    _crossAxisWidgetCount = value;
    markParentNeedsLayout();
  }

  late double maxVerticalSize;
  late double maxHorizontalSize;

  List<PositionedSize> positionedSizes = [];

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! AsymmetricGridParentData) {
      child.parentData = AsymmetricGridParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    maxHorizontalSize = constraints.maxWidth;
    maxVerticalSize = constraints.maxHeight;

    double currentY = 0.0, currentX = 0.0;

    if (firstChild == null) {
      size = constraints.constrain(Size.zero);
      return;
    }
    final childrenToPosition = generateChildrenToPosition().toList();

    for (var i = 0; i < childrenToPosition.length; i++) {
      final child = childrenToPosition[i];
      final widget = widgetList[i];

      final childParentData = child.parentData as AsymmetricGridParentData;

      var currentPosition = Offset(
        currentX,
        currentY,
      );
      child.layout(
        _getInnerConstraints(constraints),
        parentUsesSize: true,
      );

      if (child != firstChild) {
        final positionedSize = PositionedSize(
          offset: currentPosition,
          size: child.size,
          widgetHashCode: child.hashCode,
        );

        switch (_alignmentDirection) {
          case Axis.horizontal:
            currentPosition = _getPositionInGridLTR(positionedSize);
            break;
          case Axis.vertical:
            currentPosition = _getPositionInGridTTB(positionedSize);
            break;
        }
      }

      childParentData.offset = currentPosition;

      switch (alignmentDirection) {
        case Axis.horizontal:
          currentX = currentPosition.dx + child.size.width + _crossAxisSpacing;
          currentY = currentPosition.dy;
          break;
        case Axis.vertical:
          currentX = currentPosition.dx;
          currentY = currentPosition.dy + child.size.height + _crossAxisSpacing;
          break;
      }

      final positionedSize = PositionedSize(
        offset: currentPosition,
        size: child.size,
        widgetHashCode: child.hashCode,
      );
      if (child is KeepPositionOnSizeChangeMixin) {
        (child as KeepPositionOnSizeChangeMixin).positionedSize = positionedSize;
      }

      if (widget is KeepPositionOnSizeChangeMixin) {
        widget.positionedSize = positionedSize;
      }

      positionedSizes.add(positionedSize);
    }

    _setUpSize(constraints);

    positionedSizes = [];
  }

  Iterable<RenderBox> generateChildrenToPosition() sync* {
    final childrenList = getChildrenAsList();

    for (var i = 0; i < childrenList.length; i++) {
      final child = childrenList[i];
      final widget = widgetList[i];

      if (widget is KeepPositionOnSizeChangeMixin && widget.positionChanged) {
        final childParentData = child.parentData as AsymmetricGridParentData;
        childrenList.remove(child);

        if (widget.positionedSize != null) {
          positionedSizes.add(widget.positionedSize!);
        }
        childParentData.offset = widget.positionedSize?.offset ?? Offset.zero;
        child.layout(_getInnerConstraints(constraints), parentUsesSize: true);
        final positionedSize = PositionedSize(
          offset: childParentData.offset,
          size: child.size,
          widgetHashCode: child.hashCode,
        );
        positionedSizes.add(positionedSize);
        widget.positionChanged = false;
      } else {
        yield child;
      }
    }
  }

  void _setUpSize(BoxConstraints constraints) {
    switch (gridDirection) {
      case Axis.horizontal:
        final width = positionedSizes.reduce(
          (value, element) {
            if (value.endX >= element.endX) {
              return value;
            } else {
              return element;
            }
          },
        ).endX;
        size = Size(width, constraints.maxHeight);
        break;

      case Axis.vertical:
        final height = positionedSizes.reduce(
          (value, element) {
            if (value.endY >= element.endY) {
              return value;
            } else {
              return element;
            }
          },
        ).endY;
        size = Size(constraints.maxWidth, height);
        break;
    }
  }

  BoxConstraints _getInnerConstraints(BoxConstraints constraints) {
    switch (gridDirection) {
      case Axis.horizontal:
        return constraints.heightConstraints();
      case Axis.vertical:
        return constraints.widthConstraints();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  double getMinIntrinsicHeight(double width) {
    // TODO: implement getMinIntrinsicHeight
    return super.getMinIntrinsicHeight(width);
  }

  @override
  double getMaxIntrinsicHeight(double width) {
    // TODO: implement getMaxIntrinsicHeight
    return super.getMaxIntrinsicHeight(width);
  }

  @override
  double getMinIntrinsicWidth(double height) {
    // TODO: implement getMinIntrinsicWidth
    return super.getMinIntrinsicWidth(height);
  }

  @override
  double getMaxIntrinsicWidth(double height) {
    // TODO: implement getMaxIntrinsicWidth
    return super.getMaxIntrinsicWidth(height);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  Offset _getPositionInGridLTR(PositionedSize current) {
    var x = current.offset.dx, y = current.offset.dy, positionedSize = current;

    if ((gridDirection == Axis.horizontal && positionedSizes.length % crossAxisWidgetCount == 0) ||
        positionedSize.endX > maxHorizontalSize) {
      y = 0;
      x = 0;
      positionedSize = positionedSize.updatePosition(
        y: y,
        x: x,
      );
    }

    y = _getYBasedOnOthersInSameColumn(positionedSize);
    positionedSize = positionedSize.updatePosition(y: y);

    if (gridDirection == Axis.horizontal && positionedSize.endY > maxVerticalSize) {
      y = 0;
      positionedSize = positionedSize.updatePosition(y: y);
    }

    x = _getXBasedOnOtherPositionsInSameRow(positionedSize);
    positionedSize = positionedSize.updatePosition(x: x);

    y = _getYBasedOnOthersInSameColumn(
      positionedSize,
      positionCorrection: true,
    );
    positionedSize = positionedSize.updatePosition(y: y);

    return positionedSize.offset;
  }

  Offset _getPositionInGridTTB(PositionedSize current) {
    var x = current.offset.dx, y = current.offset.dy, positionedSize = current;

    y = _getYBasedOnOthersInSameColumn(positionedSize);
    positionedSize = positionedSize.updatePosition(y: y);

    if ((gridDirection == Axis.vertical && positionedSizes.length % crossAxisWidgetCount == 0)) {
      y = 0;
      x += crossAxisSpacing + positionedSize.size.width;
      positionedSize = positionedSize.updatePosition(
        y: y,
        x: x,
      );
      y = _getYBasedOnOthersInSameColumn(positionedSize);
      positionedSize = positionedSize.updatePosition(y: y);
    }

    if (positionedSize.endY > maxVerticalSize) {
      y -= crossAxisSpacing + positionedSize.size.height;
      positionedSize = positionedSize.updatePosition(y: y);
    }

    x = _getXBasedOnOtherPositionsInSameRow(positionedSize);
    positionedSize = positionedSize.updatePosition(x: x);

    if (positionedSize.endX > maxHorizontalSize) {
      y = 0;
      x = 0;
      positionedSize = positionedSize.updatePosition(
        y: y,
        x: x,
      );
      y = _getYBasedOnOthersInSameColumn(positionedSize);
      positionedSize = positionedSize.updatePosition(y: y);
    }
    y = _getYBasedOnOthersInSameColumn(positionedSize, positionCorrection: true);
    positionedSize = positionedSize.updatePosition(y: y);
    x = _getXBasedOnOtherPositionsInSameRow(
      positionedSize,
      positionCorrection: true,
    );
    positionedSize = positionedSize.updatePosition(x: x);

    return positionedSize.offset;
  }

  double _getXBasedOnOtherPositionsInSameRow(PositionedSize current, {bool positionCorrection = false}) {
    try {
      final othersInSameRow = positionedSizes.where((element) => current.conflictingYTo(element)).toList();
      if (othersInSameRow.isEmpty) {
        return 0;
      }
      final closestWidget = _getClosestAvailableXPosition(
        othersInSameRow,
        current,
        positionCorrection,
      );

      return closestWidget.offset.dx;
    } catch (_) {
      return 0;
    }
  }

  double _getYBasedOnOthersInSameColumn(PositionedSize current, {bool positionCorrection = false}) {
    try {
      final othersInSameColumn = positionedSizes.where((element) => current.conflictingXTo(element)).toList();
      if (othersInSameColumn.isEmpty) {
        return 0;
      }
      final closestTopPosition = _getClosestAvailableYPosition(
        othersInSameColumn,
        current,
        positionCorrection,
      );

      return closestTopPosition.offset.dy;
    } catch (_) {
      return 0;
    }
  }

  PositionedSize _getClosestAvailableXPosition(
      List<PositionedSize> othersInSameRow, PositionedSize current, bool positionCorrection) {
    final sortedList = List.of(othersInSameRow)..sort((a, b) => a.endX.compareTo(b.endX));

    if (!positionCorrection && sortedList.where((element) => current.isConflictTo(element)).isEmpty) {
      return current;
    }
    var tempPosition = current;

    for (final leftWidget in sortedList) {
      tempPosition = current.updatePosition(x: leftWidget.offset.dx);

      tempPosition = tempPosition.updatePosition(x: leftWidget.endX + _mainAxisSpacing);

      if (othersInSameRow.where((element) => tempPosition.isConflictTo(element)).isEmpty) {
        return tempPosition;
      }
    }
    return tempPosition;
  }

  PositionedSize _getClosestAvailableYPosition(
      List<PositionedSize> othersInSameColumn, PositionedSize current, bool positionCorrection) {
    final sortedList = List.of(othersInSameColumn)..sort((a, b) => a.endY.compareTo(b.endY));

    if (!positionCorrection && sortedList.where((element) => current.isConflictTo(element)).isEmpty) {
      return current;
    }

    var tempPosition = current;

    for (final other in sortedList) {
      tempPosition = current.updatePosition(y: other.offset.dy);

      tempPosition = tempPosition.updatePosition(y: other.endY + _crossAxisSpacing);

      if (othersInSameColumn.where((element) => tempPosition.isConflictTo(element)).isEmpty) {
        return tempPosition;
      }
    }
    return tempPosition;
  }
}
