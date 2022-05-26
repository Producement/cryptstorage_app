import 'package:age_yubikey_pgp/interface.dart';
import 'package:cryptstorage/crypto/key_model.dart';
import 'package:cryptstorage/crypto/pin_model.dart';
import 'package:cryptstorage/crypto/pin_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import 'pages/onboarding.dart';

void setup(PinModel pinModel) {
  const session = YubikitFlutterSmartCard();
  GetIt.instance.registerSingleton<YubikitFlutterSmartCard>(session);
  final openPGPInterface = YubikitFlutter.openPGP();
  GetIt.instance.registerSingleton<YubikitOpenPGP>(openPGPInterface);
  final yubikeyPGPInterface =
      AgeYubikeyPGPInterface(openPGPInterface, FlutterPinProvider(pinModel));
  GetIt.instance.registerSingleton<AgeYubikeyPGPInterface>(yubikeyPGPInterface);
}

void main() {
  final pinModel = PinModel();
  setup(pinModel);
  runApp(ChangeNotifierProvider.value(
    value: pinModel,
    child: ChangeNotifierProvider(
      create: (context) => KeyModel(),
      child: const App(),
    ),
  ));
}

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