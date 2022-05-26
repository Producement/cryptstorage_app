import 'package:cryptstorage/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    expect(find.text('Insert Yubikey'), findsOneWidget);
  });
}
