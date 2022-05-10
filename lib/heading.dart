import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String title;

  const Heading({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, top: 30, left: 20, right: 20),
      child: Text(title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3),
    );
  }
}
