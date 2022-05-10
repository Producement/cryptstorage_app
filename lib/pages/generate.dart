import 'package:cryptstorage/button.dart';
import 'package:cryptstorage/images/no_key.dart';
import 'package:flutter/material.dart';

import '../body.dart';
import '../heading.dart';

class Generate extends StatelessWidget {
  const Generate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  NoKeyImage(),
                  Heading(
                    title: "No Key Detected",
                  ),
                  Body(text: "Would you like to generate a new key?")
                ],
              ),
            ),
            const Button(title: "Yes"),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
