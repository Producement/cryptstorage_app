import 'package:cryptstorage/storage/upload.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'model/key_model.dart';
import 'onboarding/onboarding.dart';

class App extends StatelessWidget with GetItMixin {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textTheme = Typography.whiteCupertino;
    final isInitialised =
        watchOnly((KeyModel keyModel) => keyModel.isKeyInitialised);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: get<GlobalKey<NavigatorState>>(),
      title: 'YubiDrive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: textTheme.copyWith(
            headline3: textTheme.headline3?.copyWith(color: Colors.white)),
      ),
      home: isInitialised ? Upload() : Onboarding(),
    );
  }
}
