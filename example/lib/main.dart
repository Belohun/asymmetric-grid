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
          child: AsymmetricGrid(
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            keepPositionOnChildSizeChange: true,
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

      yield CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _changeSize(i),
        child: AnimatedContainer(
          curve: Curves.ease,
          duration: _animationDuration,
          color: colorList[k],
          height: size,
          width: size,
          child: Center(
            child: Text('$i', style: TextStyle(color: Colors.black)),
          ),
        ),
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
