import 'package:asymmetric_grid/positioned_size.dart';
import 'package:flutter/material.dart';

class GridController {
  GridController({
    required this.maxHorizontalSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.baseSize,
    required this.maxVerticalSize,
    required this.horizontalLength,
    required this.verticalLength,
  });

  final Size baseSize;
  final double maxVerticalSize;
  final double maxHorizontalSize;
  final double horizontalPadding;
  final double verticalPadding;
  final int horizontalLength;
  final int verticalLength;

  List<Size> sizes = [];


  List<PositionedSize> positionedSizes = [];

  List<PositionedSize> oldPositionedSizes = [];

  int? primeSizeIndex;

  PositionedSize? primePositionedSize;

  void setUpSizes(List<Size> sizes) {
    this.sizes = sizes;
  }

  void setUpPrimeIndex(int primeSizeIndex) {
    this.primeSizeIndex = primeSizeIndex;
  }

  Iterable<PositionedSize> calculatePositions() sync* {
    var currentY = 0.0;
    var currentX = 0.0;

    if (primeSizeIndex != null) {
      primePositionedSize = _getPrimePositionedSize(primeSizeIndex!, sizes);

      if (primePositionedSize!.size == baseSize) {
        primePositionedSize = null;
        primeSizeIndex = null;
      }
    }

    for (var i = 0; i < sizes.length; i++) {
      final size = sizes[i];
      var currentPosition = Offset(
        currentX,
        currentY,
      );

      if (i != 0 && i != primeSizeIndex) {
        final positionedSize = PositionedSize(offset: currentPosition, size: size);

        currentPosition = _getPositionInGrid(positionedSize);
      } else if (i == primeSizeIndex && primePositionedSize != null) {
        currentPosition = primePositionedSize!.offset;
        primePositionedSize = null;
        primeSizeIndex = null;
      }

      currentX = currentPosition.dx + size.width + verticalPadding;
      currentY = currentPosition.dy;

      final positionedSize = PositionedSize(
        offset: currentPosition,
        size: size,
      );
      positionedSizes.add(positionedSize);

      yield positionedSize;
    }

    oldPositionedSizes = positionedSizes;
    positionedSizes = [];
  }

  PositionedSize _getPrimePositionedSize(int primeSizeIndex, List<Size> sizes) {
    final oldPositionedSize = oldPositionedSizes[primeSizeIndex];
    var newPositionedSize = oldPositionedSize.copyWith(size: sizes[primeSizeIndex]);

    if (newPositionedSize.endY > maxVerticalSize) {
      final y = newPositionedSize.offset.dy - (newPositionedSize.endY - maxVerticalSize);
      newPositionedSize = newPositionedSize.updatePosition(y: y);
    }

    return newPositionedSize;
  }

  Offset _getPositionInGrid(PositionedSize current) {
    var x = current.offset.dx;

    var y = current.offset.dy;

    var positionedSize = current;

    if ((positionedSizes.length) % horizontalLength == 0) {
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
      if (primePositionedSize != null) {
        listWithPrimePosition.add(primePositionedSize!);
      }
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
      if (primePositionedSize != null) {
        listWithPrimePosition.add(primePositionedSize!);
      }

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

      tempPosition = tempPosition.updatePosition(x: leftWidget.endX + horizontalPadding);

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

      tempPosition = tempPosition.updatePosition(y: other.endY + verticalPadding);

      if (othersInSameColumn.where((element) => tempPosition.isConflictTo(element)).isEmpty) {
        return tempPosition;
      }
    }
    return tempPosition;
  }
}