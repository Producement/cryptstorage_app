import 'package:cryptstorage/images/no_key.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/model/pin_model.dart';
import 'package:cryptstorage/onboarding/service.dart';
import 'package:cryptstorage/ui/input.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import '../navigation.dart';
import '../ui/body.dart';
import '../ui/button.dart';
import '../ui/heading.dart';

class Generate extends StatefulWidget with GetItStatefulWidgetMixin {
  Generate({Key? key}) : super(key: key);

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> with GetItStateMixin<Generate> {
  int _adminPinTries = 0;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    get<YubikitOpenPGP>().getRemainingPinTries().then((tries) {
      debugPrint(
          'Pin tries: pin ${tries.pin}, reset ${tries.reset}, admin ${tries.admin}');
      setState(() {
        _adminPinTries = tries.admin;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyModel = get<KeyModel>();
    var text = 'No keys detected';
    if (keyModel.signingPublicKey != null) {
      text = 'No encryption key detected';
    } else if (keyModel.getRecipients.isNotEmpty) {
      text = 'No signing key detected';
    }
    return PageWidget(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const NoKeyImage(),
                Heading(
                  title: text,
                ),
                const Body(text: 'Generate key(s)'),
                Input(
                    errorText: _errorText,
                    onChanged: (text) {
                      get<PinModel>().adminPin = text;
                    },
                    hintText: 'Admin PIN ($_adminPinTries tries left)'),
              ],
            ),
          ),
          Button(
              title: 'Generate!',
              onPressed: () async {
                try {
                  final initialised = await get<OnboardingService>().generate();
                  if (initialised) {
                    await get<Navigation>().goToRemoveToken();
                  }
                } on SmartCardException catch (e) {
                  setState(() {
                    _errorText = e.getError().name;
                  });
                }
              }),
        ],
      ),
    ));
  }
}
