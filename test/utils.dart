import 'package:flutter/material.dart';

abstract class TestUtils {
  static Future<void> get future => Future(() {});
  static Future<void> futureDelay(int milliseconds) => Future.delayed(
        Duration(milliseconds: milliseconds),
      );

  static Widget build(Widget widget) => MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      );
}
