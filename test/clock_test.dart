import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hello_clock/digital_clock.dart';
import 'package:hello_clock/main.dart';
import 'package:flutter/foundation.dart';

void main() {
  test('Clock starts with the provided time', () {
    // arrange
    DateTime now = DateTime(1);
    // act
    var clock = DigitalClock(rainbow, now);
    // assert
    assert(clock.time == now);
  });

  test('Clock starts in the ROYGBIV position', () {
    // arrange
    DateTime now = DateTime(1);
    // act
    var clock = DigitalClock(rainbow, now);
    // assert
    assert(listEquals(clock.colors, rainbow) == true);
  });

  test('Clock advances by tick duration', () {
    // arrange
    DateTime now = DateTime(1);
    var clock = DigitalClock(rainbow, now);
    const duration = Duration(days: 1);
    // act
    clock.tick(duration);
    // assert
    assert(clock.time == now.add(duration));
  });

  test('After 1s clock is in the OYGBIVR position', () {
    // arrange
    DateTime now = DateTime(1);
    var clock = DigitalClock(rainbow, now);
    const duration = Duration(seconds: 1);
    var oygbivr = <Color>[
      rainbow[1],
      rainbow[2],
      rainbow[3],
      rainbow[4],
      rainbow[5],
      rainbow[6],
      rainbow[0],
    ];
    // act
    clock.tick(duration);
    // assert
    assert(listEquals(clock.colors, oygbivr) == true);
  });

  test('After 2s clock is in the YGBIVR) position', () {
    // arrange
    DateTime now = DateTime(1);
    var clock = DigitalClock(rainbow, now);
    const duration = Duration(seconds: 2);
    var ygbivro = <Color>[
      rainbow[2],
      rainbow[3],
      rainbow[4],
      rainbow[5],
      rainbow[6],
      rainbow[0],
      rainbow[1],
    ];
    // act
    clock.tick(duration);
    // assert
    assert(listEquals(clock.colors, ygbivro) == true);
  });

  test('After 6s clock is in the VROYGBI position', () {
    // arrange
    DateTime now = DateTime(1);
    var clock = DigitalClock(rainbow, now);
    const duration = Duration(seconds: 6);
    var vroygbi = <Color>[
      rainbow[6],
      rainbow[0],
      rainbow[1],
      rainbow[2],
      rainbow[3],
      rainbow[4],
      rainbow[5],
    ];
    // act
    clock.tick(duration);
    // assert
    assert(listEquals(clock.colors, vroygbi) == true);
  });

  test('After 7s clock is in the ROYGBIV position', () {
    // arrange
    DateTime now = DateTime(1);
    var clock = DigitalClock(rainbow, now);
    const duration = Duration(seconds: 7);
    // act
    clock.tick(duration);
    // assert
    assert(listEquals(clock.colors, rainbow) == true);
  });
}
