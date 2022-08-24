import 'package:cryptstorage/storage/upload.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'model/key_model.dart';
import 'model/session_model.dart';
import 'navigation.dart';
import 'onboarding/onboarding.dart';
import 'ui/body.dart';
import 'ui/button.dart';

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
      title: 'SecDrive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: textTheme.copyWith(
            headline3: textTheme.headline3?.copyWith(color: Colors.white)),
      ),
      builder: (context, widget) {
        Widget error = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Body(
                text:
                    'Oops, something went wrong! Please try again or contact support for help.'),
            Button(
              title: 'Try again',
              onPressed: () async {
                get<KeyModel>().reset();
                get<SessionModel>().reset();
                await get<Navigation>().backToApp();
              },
            )
          ],
        );
        if (widget is Scaffold || widget is Navigator) {
          error = PageWidget(child: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw ('widget is null');
      },
      home: isInitialised ? Upload() : Onboarding(),
    );
  }
}
