import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DigitalClock {
  final List<Color> _originalColors;
  late List<Color> _currentColors;
  DateTime _time;

  DigitalClock(this._originalColors, this._time) {
    assert(_originalColors.length > 1, 'We need at least two colors');
    _currentColors = List<Color>.from(_originalColors);
  }

  @visibleForTesting
  DateTime get time => _time;
  int get length => _originalColors.length;
  List<Color> get colors => _currentColors;
  String get friendlyDate =>
      '${_format(_time.day)}/${_format(_time.month)}/${_time.year}';
  String get friendlyTime =>
      '${_format(_time.hour)}:${_format(_time.minute)}:${_format(_time.second)}.${_format(_time.millisecond, digits: 3)}'; //${format(_time.microsecond, digits: 3)}

  /// Advances the digital clock by [tickDuration] and will shift the
  /// background appropriately
  /// After each second [_originalColors] will shift to the left by 1.
  /// e.g. If the original colors passed in are ROYGBIV then after 1s
  /// the current colors will be OYGBIVR. Further, every
  void tick({Duration tickDuration = const Duration(seconds: 1)}) {
    _time = _time.add(tickDuration);
    const millisPerSecond = 1000;

    final index = _time.second % length;
    final t = _time.millisecond / millisPerSecond;
    _currentColors = _shiftColors(index, t, _originalColors);
  }

  /// Returns a list of colors which linearly interpolate postions
  /// from the [originalColors] based on the [index] and parameter [t]
  List<Color> _shiftColors(int index, double t, List<Color> originalColors) {
    if (kDebugMode) {
      print('shifting colors with index: $index and t: $t');
    }
    var shiftedRainbow = <Color>[];
    for (int i = 0; i < originalColors.length; i++) {
      if (index == originalColors.length - 1) {
        shiftedRainbow
            .add(Color.lerp(originalColors[index], originalColors[0], t)!);
        index = 0;
      } else {
        shiftedRainbow.add(
            Color.lerp(originalColors[index], originalColors[++index], t)!);
      }
    }
    return shiftedRainbow;
  }

  String _format(int num, {int digits = 2}) =>
      num.toString().padLeft(digits, '0');
}
