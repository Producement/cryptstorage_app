import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final String text;

  const Body({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Text(text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1),
    );
  }
}
