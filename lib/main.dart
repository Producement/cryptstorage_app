import 'package:cryptstorage/crypto/key_model.dart';
import 'package:cryptstorage/crypto/pin_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import 'app.dart';

void setup(PinModel pinModel) {
  final openPGPInterface = YubikitFlutter.openPGP(pinProvider: pinModel);
  GetIt.instance.registerSingleton<YubikitOpenPGP>(openPGPInterface);
}

void main() async {
  final pinModel = PinModel();
  setup(pinModel);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://2bc7de22342d4602b81ee881a47f12e2@o223876.ingest.sentry.io/6446813';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(ChangeNotifierProvider.value(
      value: pinModel,
      child: ChangeNotifierProvider(
        create: (context) => KeyModel(),
        child: const App(),
      ),
    )),
  );
}
