import 'package:cryptstorage/pages/remove_token.dart';
import 'package:cryptstorage/pages/upload.dart';
import 'package:flutter/material.dart';

import 'pages/generate.dart';
import 'pages/onboarding.dart';

void main() {
  runApp(MaterialApp(
    title: 'Cryptstorage',
    theme: ThemeData(
    ),
    home: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Typography.whiteCupertino;
    return MaterialApp(
      title: 'Cryptstorage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: textTheme.copyWith(
            headline3: textTheme.headline3?.copyWith(color: Colors.white)),
      ),
      home: const Onboarding(),
    );
  }
}
