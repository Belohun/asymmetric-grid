import 'package:asymmetric_grid/asymmetric_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

const colorList = const [
  Colors.blue,
  Colors.red,
  Colors.yellow,
];

const childrenCount = 40;

const _animationDuration = Duration(milliseconds: 200);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'asymmetric_grid demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var enlargedContainersIndexes = <int>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: AsymmetricGridView(
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: generateChildren().toList(),
          ),
        ),
      ),
    );
  }

  _changeSize(int i) {
    final isEnlarged = enlargedContainersIndexes.contains(i);
    if (isEnlarged) {
      enlargedContainersIndexes.remove(i);
    } else {
      enlargedContainersIndexes.add(i);
    }
    setState(() {});
  }

  Iterable<Widget> generateChildren() sync* {
    var k = 0;

    for (var i = 0; i < childrenCount; i++) {
      final size = _getSize(i);

      yield _Item(
        dimension: size,
        onPressed: () => _changeSize(i),
        i: i,
        k: k,
      );

      k++;
      if (k >= colorList.length) {
        k = 0;
      }
    }
  }

  double _getSize(int i) {
    final isEnlarged = enlargedContainersIndexes.contains(i);
    if (isEnlarged) {
      return 100.0;
    } else {
      return 70.0;
    }
  }
}

class _Item extends StatelessWidget with KeepPositionOnSizeChangeMixin {
  _Item({
    Key? key,
    required this.dimension,
    required this.onPressed,
    required this.i,
    required this.k,
  }) : super(key: key);

  final double dimension;
  final VoidCallback onPressed;
  final int i;
  final int k;

  @override
  Size get size => Size(dimension, dimension);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
      /*  curve: Curves.ease,
        duration: _animationDuration,*/
        color: colorList[k],
        height: dimension,
        width: dimension,
        child: Center(
          child: Text('$i', style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
