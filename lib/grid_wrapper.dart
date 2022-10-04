import 'package:asymmetric_grid/grid_controller.dart';
import 'package:flutter/cupertino.dart';

const _animationDuration = Duration(milliseconds: 200);

class WrapElement {
  const WrapElement({
    required this.child,
    this.scaleFactor = 1,
    this.onPressed,
  });

  final Widget child;
  final double scaleFactor;
  final VoidCallback? onPressed;
}

extension ListWrapElementExtension on List<WrapElement> {
  Iterable<Widget> applyConstraints({
    required double width,
    required double height,
    required GridController controller,
  }) sync* {
    final List<Size> sizes = [];

    for (var i = 0; i < length; i++) {
      final element = this[i];

      var scaledHeight = height * element.scaleFactor;
      var scaledWidth = width * element.scaleFactor;

      if (element.scaleFactor.floor() == element.scaleFactor.ceil()) {
        final paddingCount = element.scaleFactor.toInt() - 1;

        scaledHeight += controller.verticalPadding * paddingCount;
        scaledWidth += controller.horizontalPadding * paddingCount;
      }

      sizes.add(Size(scaledWidth, scaledHeight));

      yield _AnimatedContainer(
        i: i,
        element: element,
        scaledHeight: scaledHeight,
        scaledWidth: scaledWidth,
        controller: controller,
      );
    }
    controller.setUpSizes(sizes);
  }
}

class _AnimatedContainer extends StatelessWidget {
  const _AnimatedContainer({
    required this.i,
    required this.element,
    required this.scaledHeight,
    required this.scaledWidth,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final int i;
  final WrapElement element;
  final double scaledHeight;
  final double scaledWidth;
  final GridController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.setUpPrimeIndex(i);
        element.onPressed?.call();
      },
      child: AnimatedContainer(
        height: scaledHeight,
        width: scaledWidth,
        curve: Curves.ease,
        duration: _animationDuration,
        child: element.child,
      ),
    );
  }
}

extension ChildreenWrapExtension on Iterable<Widget> {
  Iterable<Widget> applyPositions({required GridController controller}) sync* {
    final widgetList = toList();

    final positions = controller.calculatePositions().toList();

    for (var i = 0; i < length; i++) {
      final widget = widgetList[i];
      final position = positions.toList()[i];

      yield AnimatedPositioned(
        left: position.offset.dx,
        top: position.offset.dy,
        curve: Curves.ease,
        duration: _animationDuration,
        child: widget,
      );
    }
    final farthestPosition = positions.reduce(
          (value, element) {
        if (value.endX > element.endX) {
          return value;
        } else {
          return element;
        }
      },
    );

    yield SizedBox(
      height: double.infinity,
      width: farthestPosition.endX + controller.horizontalPadding,
    );
  }
}
