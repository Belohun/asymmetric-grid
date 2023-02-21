import 'package:asymmetric_grid/src/model/positioned_size.dart';
import 'package:flutter/cupertino.dart';

///When size of certain children changes they will keep theirs position if possible.
///This can be useful when child changes its size f.e. when being pressed on, so that widget doesn't jump from the position that have been clicked on.
mixin KeepPositionOnSizeChangeMixin on Widget {
  bool positionChanged = false;

  PositionedSize? _positionedSize;

  PositionedSize? get positionedSize => _positionedSize;

  set positionedSize(PositionedSize? newSize) {
    if (newSize == positionedSize) return;
    positionChanged = true;
    _positionedSize = newSize;
  }
}
