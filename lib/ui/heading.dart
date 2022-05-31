import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String title;

  const Heading({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3),
    );
  }
}
