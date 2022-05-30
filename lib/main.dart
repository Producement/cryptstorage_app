import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/model/pin_model.dart';
import 'package:cryptstorage/navigation.dart';
import 'package:cryptstorage/onboarding/service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import 'app.dart';

Future<void> setup() async {
  final getIt = GetIt.instance;
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton(prefs);
  final pinModel = PinModel();
  getIt.registerSingleton(pinModel);
  final keyModel = KeyModel(prefs);
  getIt.registerSingleton(keyModel);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  getIt.registerSingleton(navigatorKey);
  final navigation = Navigation(navigatorKey);
  getIt.registerSingleton(navigation);
  final openPGPInterface = YubikitFlutter.openPGP(pinProvider: pinModel);
  getIt.registerSingleton(openPGPInterface);
  final onboardingService = OnboardingService(openPGPInterface, keyModel);
  getIt.registerSingleton(onboardingService);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://2bc7de22342d4602b81ee881a47f12e2@o223876.ingest.sentry.io/6446813';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(App()),
  );
}