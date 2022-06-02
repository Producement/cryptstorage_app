import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const Error({Key? key, required this.error, this.stackTrace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
    return ErrorWidget(error);
  }
}
