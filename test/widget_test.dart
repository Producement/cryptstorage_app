import 'package:cryptstorage/app.dart';
import 'package:cryptstorage/injection.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    final valueBeforeTest = ErrorWidget.builder;
    // Build our app and trigger a frame.
    getIt.registerSingleton(GlobalKey<NavigatorState>());
    SharedPreferences.setMockInitialValues({});
    getIt.registerSingleton(await SharedPreferences.getInstance());
    getIt.registerSingleton(KeyModel());
    WidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(App());

    expect(find.text('Powered by YubiKey.'), findsOneWidget);
    ErrorWidget.builder = valueBeforeTest;
  });
}
