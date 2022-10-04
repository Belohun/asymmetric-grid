library asymmetric_grid;

import 'package:asymmetric_grid/positioned_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

enum AsymmetricGridDirection {
  ///Left to right
  ltr,

  ///Right to left
  rtl,

  ///Top to bottom
  ttb,

  ///Bottom to top
  btt,
}

class AsymmetricGrid extends MultiChildRenderObjectWidget {
  AsymmetricGrid({
    required super.children,
    super.key,
    this.direction = Axis.horizontal,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.gridDirection = AsymmetricGridDirection.ltr,
  });

  ///Direction that layout will expand to.
  final Axis direction;

  ///Space that takes between children in main axis.
  final double mainAxisSpacing;

  ///Space that takes between children in cross axis.
  final double crossAxisSpacing;

  ///Defines which direction children will take when placing themselves in the layout.
  ///F.e if gridDirection is set to AsymmetricGridDirection.ttb, first child will be set at the top left corner
  ///and the second child will be placed under the first child.
  final AsymmetricGridDirection gridDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAsymmetricGrid(
      direction: direction,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
    );
  }
}

class AsymmetricGridParentData extends ContainerBoxParentData<RenderBox> {}

class RenderAsymmetricGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, AsymmetricGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, AsymmetricGridParentData> {
  RenderAsymmetricGrid({
    required Axis direction,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
  })  : _direction = direction,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing;

  Axis _direction;

  Axis get direction => _direction;

  set direction(Axis value) {
    if (value == _direction) return;
    _direction = value;
    markParentNeedsLayout();
  }

  double _mainAxisSpacing;

  double get mainAxisSpacing => _mainAxisSpacing;

  set mainAxisSpacing(double value) {
    assert(value > 0, 'mainAxisSpacing must be greater than or equal to zero.');
    if (value == _mainAxisSpacing) return;
    _mainAxisSpacing = value;
    markParentNeedsLayout();
  }

  double _crossAxisSpacing;

  double get crossAxisSpacing => _crossAxisSpacing;

  set crossAxisSpacing(double value) {
    assert(value > 0, 'crossAxisSpacing must be greater than or equal to zero.');
    if (value == _crossAxisSpacing) return;
    _crossAxisSpacing = value;
    markParentNeedsLayout();
  }

  late double maxVerticalSize;
  late double maxHorizontalSize;

  final int horizontalLength = 3;
  final int verticalLength = 4;

  List<PositionedSize> positionedSizes = [];

  @override
  OffsetLayer updateCompositedLayer({required covariant OffsetLayer? oldLayer}) {
    // TODO: implement updateCompositedLayer
    return super.updateCompositedLayer(oldLayer: oldLayer);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! AsymmetricGridParentData) {
      child.parentData = AsymmetricGridParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    switch (_direction) {
      case Axis.horizontal:
        // TODO: Handle this case.
        break;
      case Axis.vertical:
        // TODO: Handle this case.
        break;
    }

    maxHorizontalSize = constraints.maxWidth;
    maxVerticalSize = constraints.maxHeight;

    double currentY = 0.0, currentX = 0.0;

    RenderBox? child = firstChild;

    while (child != null) {
      final childParentData = child.parentData as AsymmetricGridParentData;
      var currentPosition = Offset(
        currentX,
        currentY,
      );

      child.layout(
        BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true,
      );

      if (child != firstChild) {
        final positionedSize = PositionedSize(offset: currentPosition, size: child.size);
        currentPosition = _getPositionInGrid(positionedSize);
      }

      childParentData.offset = currentPosition;

      currentX = currentPosition.dx + child.size.width + _crossAxisSpacing;
      currentY = currentPosition.dy;

      final positionedSize = PositionedSize(
        offset: currentPosition,
        size: child.size,
      );
      positionedSizes.add(positionedSize);

      child = childParentData.nextSibling;
    }

    final height = positionedSizes.reduce(
      (value, element) {
        if (value.endY >= element.endY) {
          return value;
        } else {
          return element;
        }
      },
    ).endY;

    final width = positionedSizes.reduce(
      (value, element) {
        if (value.endX >= element.endX) {
          return value;
        } else {
          return element;
        }
      },
    ).endX;

    size = Size(constraints.maxWidth, constraints.maxHeight);
    positionedSizes = [];

/*
      child = firstChild;
      while (child != null) {
      final childParentData = child.parentData as AsymmetricGridParentData;
      //TODO setup offsets
      childParentData.offset = Offset(0, 0);

      child = childParentData.nextSibling;
    }*/
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

  Offset _getPositionInGrid(PositionedSize current) {
    var x = current.offset.dx;

    var y = current.offset.dy;

    var positionedSize = current;

    if (current.endX > maxHorizontalSize) {
      y = 0;
      x = 0;
      positionedSize = positionedSize.updatePosition(
        y: y,
        x: x,
      );
    }

    if ((positionedSizes.length) % (horizontalLength * verticalLength) == 0) {
      y = 0;
      x += maxHorizontalSize;
      positionedSize = positionedSize.updatePosition(y: y, x: x);
    }

    y = _getYBasedOnOthersInSameColumn(positionedSize);
    positionedSize = positionedSize.updatePosition(y: y);

    if (positionedSize.endY > maxVerticalSize) {
      y = maxVerticalSize - positionedSize.size.height;
      positionedSize = positionedSize.updatePosition(y: y);
    }

    x = _getXBasedOnOtherPositionsInSameRow(positionedSize);
    positionedSize = positionedSize.updatePosition(x: x);

    y = _getYBasedOnOthersInSameColumn(positionedSize);
    positionedSize = positionedSize.updatePosition(y: y);

    return positionedSize.offset;
  }

  double _getXBasedOnOtherPositionsInSameRow(PositionedSize current) {
    try {
      final listWithPrimePosition = List.of(positionedSizes);
      /*    if (primePositionedSize != null) {
        listWithPrimePosition.add(primePositionedSize!);
      }*/
      final othersInSameRow = listWithPrimePosition.where((element) => current.conflictingYTo(element)).toList();
      final closestWidget = _getClosestAvailableXPosition(othersInSameRow, current);

      return closestWidget.offset.dx;
    } catch (_) {
      return 0;
    }
  }

  double _getYBasedOnOthersInSameColumn(PositionedSize current) {
    try {
      final listWithPrimePosition = List.of(positionedSizes);
/*      if (primePositionedSize != null) {
        listWithPrimePosition.add(primePositionedSize!);
      }*/

      final othersInSameColumn = listWithPrimePosition.where((element) => current.conflictingXTo(element)).toList();
      final closestTopPosition = _getClosestAvailableYPosition(othersInSameColumn, current);

      return closestTopPosition.offset.dy;
    } catch (_) {
      return 0;
    }
  }

  PositionedSize _getClosestAvailableXPosition(List<PositionedSize> othersInSameRow, PositionedSize current) {
    final sortedList = List.of(othersInSameRow)..sort((a, b) => a.endX.compareTo(b.endX));

    if (sortedList.where((element) => current.isConflictTo(element)).isEmpty) {
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

  PositionedSize _getClosestAvailableYPosition(List<PositionedSize> othersInSameColumn, PositionedSize current) {
    final sortedList = List.of(othersInSameColumn)..sort((a, b) => a.endY.compareTo(b.endY));

    if (sortedList.where((element) => current.isConflictTo(element)).isEmpty) {
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
