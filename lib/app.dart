import 'package:flutter/material.dart';

import 'pages/onboarding.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Typography.whiteCupertino;
    return MaterialApp(
      title: 'Yubidrive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: textTheme.copyWith(
            headline3: textTheme.headline3?.copyWith(color: Colors.white)),
      ),
      home: const Onboarding(),
    );
  }
}
