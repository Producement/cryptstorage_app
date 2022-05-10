import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final String text;

  const Body({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6),
    );
  }
}
