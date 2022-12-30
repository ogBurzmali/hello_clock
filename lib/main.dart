import 'dart:async';

import 'dart:ui' as ui show FontFeature;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var rainbow = const <Color>[
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.deepPurpleAccent
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

class DigitalClock {
  final List<Color> _originalColors;
  late List<Color> _currentColors;

  DateTime _time;
  var _ticks = 0;
  var indexTracker = 0;

  DigitalClock(this._originalColors, this._time) {
    assert(_originalColors.length > 1, 'We need at least two colors');
    _currentColors = List<Color>.from(_originalColors);
  }

  DateTime get time => _time;
  int get length => _originalColors.length;
  List<Color> get colors => _currentColors;
  String get friendlyDate =>
      '${_format(_time.day)}/${_format(_time.month)}/${_time.year}';
  String get friendlyTime =>
      '${_format(_time.hour)}:${_format(_time.minute)}:${_format(_time.second)}.${_format(_time.millisecond, digits: 3)}'; //${format(_time.microsecond, digits: 3)}

  void tick({Duration tickDuration = const Duration(seconds: 1)}) {
    _time = _time.add(tickDuration);
    if (_ticks % (_originalColors.length) == 0) {
      _shiftColors(_originalColors);
    }
    _ticks++;
  }

  // kinda wanna stick this with the colors
  // rainbow object?
  var t = 0.0;

  void _shiftColors(List<Color> rainbow) {
    var shiftedRainbow = <Color>[];
    if (kDebugMode) {
      // print('shifting colors');
    }
    if (t >= 1.0) {
      t = 0;
      indexTracker = (++indexTracker).clamp(0, rainbow.length - 1);
    } else {
      t = t += 0.1;
    }
    var ci = indexTracker;
    for (int i = 0; i < _currentColors.length; i++) {
      if (ci == _currentColors.length - 1) {
        shiftedRainbow.add(Color.lerp(rainbow[ci], rainbow[0], t)!);
        ci = 0;
      } else {
        shiftedRainbow.add(Color.lerp(rainbow[ci], rainbow[++ci], t)!);
      }
    }
    _currentColors = shiftedRainbow;
    if (kDebugMode) {
      // print('index: $indexTracker, t: $t, colors: $_currentColors');
    }
  }

  String _format(int num, {int digits = 2}) =>
      num.toString().padLeft(digits, '0');
}

// class _Clock2 extends StatefulWidget {
//   @override
//   State<_Clock> createState() {
//     return _Clock2State();
//   }
// }

// class _Clock2State extends State<_Clock> {
//   @override
//   Widget build(BuildContext context) {
//     throw UnimplementedError();
//   }
// }
// for (var i = 1; i <= rainbow.length; i++) {
//   if (i == rainbow.length) {
//     shiftedRainbow.add(Color.lerp(rainbow[i - 1], color1, t)!);
//   } else {
//     var a = rainbow[i - 1];
//     var b = rainbow[i];
//     shiftedRainbow.add(Color.lerp(a, b, t)!);
//   }
// }
// The goal is to shift through the entire rainbow forever
// If the rainbow is defined as a list of colors with Red at position 0,
// then over a period of time Red will shift to Orange, Orange to Yellow, etc.
// That period can be defined as a parameter T and passed to a linear
// interpolation function. When Color.lerp(Red, Orange, 0) we get Red.
// Wehn we Color.lerp(Red, Orange, 1), we get Orange.
// T can be updated at an arbitrary interval that "feels" right.

// The tricky bit is when we need Color.lerp(Orange, Yellow, t) because
// it's not simple to just use a for loop. With a for loop we could do something like:
// ```
//  for (var i = 1; i <= rainbow.length; i++) {
//    if (i == rainbow.length) {
//      shiftedRainbow.add(Color.lerp(color1, rainbow[i - 1], t)!);
//    } else {
//      shiftedRainbow.add(Color.lerp(rainbow[i - 1], rainbow[i], t)!);
//    }
// }
// ```
// but that only works when we start with an index of 0.

// So let's write out some numbers and see if we can find a pattern.

// Index 0
// (0,1), (1,2), (2,3), (3,4), (4,5), (5,6), (6,0)
// Index 1
// (1,2), (2,3), (3,4), (4,5), (5,6), (6,0), (0,1)
// Index 2
// (2,3), (3,4), (4,5), (5,6), (6,0), (0,1), (1,2)
// Index 3
// (3,4), (4,5), (5,6), (6,0), (0,1), (1,2), (2,3),
// Index 4
// (4,5), (5,6), (6,0), (0,1), (1,2), (2,3), (3,4),
// Index 5
// (5,6), (6,0), (0,1), (1,2), (2,3), (3,4), (4,5),
// Index 6
// (6,0), (0,1), (1,2), (2,3), (3,4), (4,5), (5,6),

// One thing we could probably do is just keep a list of pairs, which represent the indices we'll pass to lerp, then
// we could just use a do/while loop

// another thing would be to use a for loop but we notice that the current index maps the index we start from
// so we could probably do something like...
