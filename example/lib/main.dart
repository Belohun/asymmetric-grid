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

const childrenCount = 12;

const _animationDuration = Duration(milliseconds: 200);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
        child: SizedBox(
          width: double.infinity,
          child: AsymmetricGrid(
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

      yield CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _changeSize(i),
        child: AnimatedContainer(
          curve: Curves.ease,
          duration: _animationDuration,
          color: colorList[k],
          height: size,
          width: size,
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
