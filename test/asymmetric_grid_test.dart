import 'package:flutter_test/flutter_test.dart';

import 'positioned_size_test.dart' as positioned_size_test;
import 'keep_position_on_size_change_test.dart' as keep_position_on_size_change_test;

void main() {
  group('PositionedSize class methods test', positioned_size_test.main);
  group("KeepPositionOnSizeChange tests", keep_position_on_size_change_test.main);
}
