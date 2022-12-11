import 'dart:async';

import 'dart:ui' as ui show FontFeature;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What time is it?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _Clock(),
    );
  }
}

class _Clock extends StatefulWidget {
  @override
  State<_Clock> createState() => _ClockState();
}

class _ClockState extends State<_Clock> {
  _ClockState() {
    if (kDebugMode) {
      print('creating time!');
    }
    _timer = Timer.periodic(const Duration(milliseconds: 73), (timer) {
      setState(() {
        _time = DateTime.now();
      });
    });
  }
  late Timer _timer;
  var _time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var colors = const <Color>[
      Color(0xFFFF0000), // red
      Color(0xFFFFA500), // orange
      Color(0xFFFFFF00), // orange
      Color(0xFF00FF00), // green
      Color(0xFF0000FF), // blue
      Color(0xFF4B0082), // indigo
      Color(0xFF9400D3), // violet
    ];
    var stops = List<double>.generate(
      colors.length,
      (int index) => index * (1.0 / (colors.length - 1)), // 0
      growable: false,
    );
    if (kDebugMode) {
      print(stops);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          stops: stops,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            getTime(),
            textAlign: TextAlign.center,
            style: clockifyStyle(Theme.of(context).textTheme.headline2!),
          ),
          Text(
            '${_time.day}/${_time.month}/${_time.year}',
            textAlign: TextAlign.center,
            style: clockifyStyle(Theme.of(context).textTheme.headline4!),
          ),
        ],
      ),
    );
  }

  String getTime() =>
      '${format(_time.hour)}:${format(_time.minute)}:${format(_time.second)}.${format(_time.millisecond, digits: 3)}${format(_time.microsecond, digits: 3)}';

  String format(int num, {int digits = 2}) =>
      num.toString().padLeft(digits, '0');

  TextStyle clockifyStyle(TextStyle incoming) {
    return incoming.copyWith(
      color: Colors.white,
      // https://github.com/flutter/flutter/issues/24108
      shadows: [
        const Shadow(
            // bottomLeft
            offset: Offset(-1.5, -1.5),
            color: Colors.black),
        const Shadow(
            // bottomRight
            offset: Offset(1.5, -1.5),
            color: Colors.black),
        const Shadow(
            // topRight
            offset: Offset(1.5, 1.5),
            color: Colors.black),
        const Shadow(
            // topLeft
            offset: Offset(-1.5, 1.5),
            color: Colors.black)
      ],
      fontFeatures: <ui.FontFeature>[
        const ui.FontFeature.tabularFigures(),
      ],
    );
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('closing clock');
    }
    super.dispose();
    _timer.cancel();
  }
}
