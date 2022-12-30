import 'dart:async';

import 'dart:ui' as ui show FontFeature;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'digital_clock.dart';

var rainbow = const <Color>[
  Color.fromRGBO(244, 67, 54, 1),
  Color.fromRGBO(255, 152, 0, 1),
  Color.fromRGBO(255, 235, 59, 1),
  Color.fromRGBO(76, 175, 80, 1),
  Color.fromRGBO(33, 150, 243, 1),
  Color.fromRGBO(63, 81, 181, 1),
  Color.fromRGBO(124, 77, 255, 1)
];

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
  // ignore: no_logic_in_create_state
  State<_Clock> createState() {
    var digitalClock = DigitalClock(rainbow, DateTime.now());
    return _ClockState(digitalClock);
  }
}

class _ClockState extends State<_Clock> {
  _ClockState(this.digitalClock) {
    if (kDebugMode) {
      print('creating time!');
    }

    const tickInterval = Duration(milliseconds: 7);
    _timer = Timer.periodic(
      tickInterval,
      (timer) {
        setState(() {
          digitalClock.tick(tickDuration: tickInterval);
        });
      },
    );
  }

  // TODO: look into using vsync or something
  late Timer _timer;
  DigitalClock digitalClock;

  @override
  Widget build(BuildContext context) {
    var stops = List<double>.generate(
      digitalClock.length,
      (int index) => index * (1.0 / (digitalClock.length - 1)), // 0
      growable: false,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: digitalClock.colors,
          stops: stops,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            digitalClock.friendlyTime,
            textAlign: TextAlign.center,
            style: clockifyStyle(Theme.of(context).textTheme.headline2!),
          ),
          Text(
            digitalClock.friendlyDate,
            textAlign: TextAlign.center,
            style: clockifyStyle(Theme.of(context).textTheme.headline4!),
          ),
        ],
      ),
    );
  }

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
