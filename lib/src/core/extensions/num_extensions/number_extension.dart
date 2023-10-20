import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

extension NumExtension on num {
  ///   print('+ wait for 2 seconds');
  ///   await 2.delay();
  ///   print('- 2 seconds completed');
  ///   print('+ callback in 1.2sec');
  ///   1.delay(() => print('- 1.2sec callback called'));
  ///   print('currently running callback 1.2sec');
  Future delay([FutureOr Function()? callback]) async => Future.delayed(
        Duration(milliseconds: (this * 1000).round()),
        callback,
      );

  bool isLowerThan(num b) => this < b;

  bool isGreaterThan(num b) => this > b;

  bool isEqual(num b) => this == b;

  double toRadians() => this * math.pi / 180;
}

extension SizeBoxNumExtension on num {
  Widget get widthBox => SizedBox(width: double.tryParse(toString()));

  Widget get heightBox => SizedBox(height: double.tryParse(toString()));
}
