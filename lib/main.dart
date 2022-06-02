import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'injection.dart';

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint(record.toString());
    debugPrint(record.stackTrace.toString());
  });
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (!isProduction) {
      FlutterError.dumpErrorToConsole(details);
      return;
    }
    // turn to Zone
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  await runZonedGuarded<Future<void>>(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://2bc7de22342d4602b81ee881a47f12e2@o223876.ingest.sentry.io/6446813';
        options.tracesSampleRate = 1.0;
      },
      appRunner: () => runApp(App()),
    );
  }, (Object error, StackTrace stackTrace) async {
    if (!isProduction) {
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      return;
    }
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  });
}
