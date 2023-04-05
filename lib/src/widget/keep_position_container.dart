import 'package:flutter/widgets.dart';

class KeepPositionContainer extends StatelessWidget {
  const KeepPositionContainer({
    required this.child,
    required this.keepSize,
    super.key,
  });

  final Widget child;
  final bool keepSize;

  @override
  Widget build(BuildContext context) => child;
}
