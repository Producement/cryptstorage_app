import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Future<Object?> goto(Widget Function() creator) async {
    return await Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => creator()),
    );
  }
}
