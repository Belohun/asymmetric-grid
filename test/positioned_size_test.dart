import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

void main() {
  test('Checks position conflicts', () {
    expect(Mocks.centerSize.isConflictTo(Mocks.leftBottomSize), true);
    expect(Mocks.centerSize.isConflictTo(Mocks.leftTopSize), true);
    expect(Mocks.centerSize.isConflictTo(Mocks.rightTopSize), true);
    expect(Mocks.centerSize.isConflictTo(Mocks.rightBottomSize), true);
  });

  test('Checks non conflicting positions', () {
    expect(Mocks.leftTopSize.isConflictTo(Mocks.rightTopSize), false);
    expect(Mocks.leftTopSize.isConflictTo(Mocks.rightBottomSize), false);
    expect(Mocks.leftTopSize.isConflictTo(Mocks.leftBottomSize), false);

    expect(Mocks.leftBottomSize.isConflictTo(Mocks.rightTopSize), false);
    expect(Mocks.leftBottomSize.isConflictTo(Mocks.rightBottomSize), false);
    expect(Mocks.leftBottomSize.isConflictTo(Mocks.leftTopSize), false);

    expect(Mocks.rightTopSize.isConflictTo(Mocks.leftBottomSize), false);
    expect(Mocks.rightTopSize.isConflictTo(Mocks.rightBottomSize), false);
    expect(Mocks.rightTopSize.isConflictTo(Mocks.leftTopSize), false);

    expect(Mocks.rightBottomSize.isConflictTo(Mocks.rightTopSize), false);
    expect(Mocks.rightBottomSize.isConflictTo(Mocks.leftBottomSize), false);
    expect(Mocks.rightBottomSize.isConflictTo(Mocks.leftTopSize), false);

    expect(Mocks.belowCenterSize.isConflictTo(Mocks.centerSize), false);
    expect(Mocks.centerSize.isConflictTo(Mocks.belowCenterSize), false);

    expect(Mocks.belowCenterSizeBig.isConflictTo(Mocks.centerSize), false);
    expect(Mocks.centerSize.isConflictTo(Mocks.belowCenterSizeBig), false);
  });

  test('Checks if positions are in same column', () {
    expect(Mocks.leftTopSize.conflictingXTo(Mocks.leftBottomSize), true);
    expect(Mocks.leftTopSize.conflictingXTo(Mocks.rightTopSize), false);
    expect(Mocks.leftTopSize.conflictingXTo(Mocks.rightBottomSize), false);

    expect(Mocks.rightTopSize.conflictingXTo(Mocks.rightBottomSize), true);
    expect(Mocks.rightTopSize.conflictingXTo(Mocks.leftTopSize), false);
    expect(Mocks.rightTopSize.conflictingXTo(Mocks.leftBottomSize), false);

    expect(Mocks.belowCenterSize.conflictingXTo(Mocks.centerSize), true);
    expect(Mocks.centerSize.conflictingXTo(Mocks.belowCenterSize), true);

  });

  test('Checks if positions are in same row', () {
    expect(Mocks.leftTopSize.conflictingYTo(Mocks.rightTopSize), true);
    expect(Mocks.leftTopSize.conflictingYTo(Mocks.leftBottomSize), false);
    expect(Mocks.leftTopSize.conflictingYTo(Mocks.rightBottomSize), false);

    expect(Mocks.leftBottomSize.conflictingYTo(Mocks.rightBottomSize), true);
    expect(Mocks.leftBottomSize.conflictingYTo(Mocks.leftTopSize), false);
    expect(Mocks.leftBottomSize.conflictingYTo(Mocks.rightTopSize), false);

    expect(Mocks.belowCenterSize.conflictingYTo(Mocks.centerSize), false);
    expect(Mocks.centerSize.conflictingYTo(Mocks.belowCenterSize), false);
  });


}
