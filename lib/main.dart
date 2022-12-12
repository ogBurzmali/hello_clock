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
    var rainbow = const <Color>[
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.red,
      Colors.orange,
    ];
    _currentColors = List<Color>.from(rainbow);
    double t = 0;
    assert(_currentColors.length > 1, 'We need at least two colors');
    const tickInterval = 7;
    _timer = Timer.periodic(
      const Duration(milliseconds: tickInterval),
      (timer) {
        setState(() {
          _time = DateTime.now();
          var shiftedRainbow = <Color>[];
          if (timer.tick % (5 * rainbow.length) == 0) {
            if (kDebugMode) {
              print('shifting colors');
            }
            var color1 = rainbow[0];
            t = (t >= 0.9) ? 0 : t += 0.1;
            for (var i = 1; i <= rainbow.length; i++) {
              if (i == rainbow.length) {
                shiftedRainbow.add(Color.lerp(color1, rainbow[i - 1], t)!);
              } else {
                var a = rainbow[i - 1];
                var b = rainbow[i];
                shiftedRainbow.add(Color.lerp(a, b, t)!);
              }
            }
            _currentColors = shiftedRainbow;
            if (kDebugMode) {
              print('$t, /n$_currentColors');
            }
          }
        });
      },
    );
  }

  late Timer _timer;
  late List<Color> _currentColors;
  var _time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var stops = List<double>.generate(
      _currentColors.length,
      (int index) => index * (1.0 / (_currentColors.length - 1)), // 0
      growable: false,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _currentColors,
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
      '${format(_time.hour)}:${format(_time.minute)}:${format(_time.second)}.${format(_time.millisecond, digits: 3)}'; //${format(_time.microsecond, digits: 3)}

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
