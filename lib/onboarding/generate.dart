import 'package:cryptstorage/images/no_key.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/model/pin_model.dart';
import 'package:cryptstorage/onboarding/service.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:cryptstorage/ui/input.dart';
import 'package:cryptstorage/ui/loader.dart';
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
  bool _showPin = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    get<SmartCardService>().getRemainingPinTries().then((tries) {
      debugPrint(
          'Pin tries: pin ${tries.pin}, reset ${tries.reset}, admin ${tries.admin}');
      setState(() {
        _adminPinTries = tries.admin;
      });
    });
    _showPin = false;
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final keyModel = get<KeyModel>();
    var text = 'No keys detected';
    if (keyModel.signaturePublicKey != null) {
      text = 'No encryption key detected';
    } else if (keyModel.encryptionPublicKey != null) {
      text = 'No signing key detected';
    }
    return PageWidget(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const NoKeyImage(),
              Heading(
                title: text,
              ),
              Body(
                  text:
                      'Generate new keys using ${_showPin ? 'custom' : 'default'} Admin PIN'),
              ...(_showPin
                  ? [
                      Input(
                          errorText: _errorText,
                          onChanged: (text) {
                            get<PinModel>().adminPin = text;
                          },
                          labelText: 'Admin PIN ($_adminPinTries tries left)')
                    ]
                  : []),
              ...(_loading
                  ? [const Loader()]
                  : [
                      Button(
                          title: 'Generate!',
                          onPressed: () async {
                            try {
                              setState(() {
                                _loading = true;
                              });
                              final initialised =
                                  await get<OnboardingService>().generate();
                              if (initialised) {
                                await get<Navigation>().goToRemoveToken();
                              }
                            } on SmartCardException catch (e) {
                              setState(() {
                                _errorText = e.error.name;
                              });
                              final tries = await get<SmartCardService>()
                                  .getRemainingPinTries();
                              setState(() {
                                _adminPinTries = tries.admin;
                              });
                            } finally {
                              setState(() {
                                _loading = false;
                              });
                            }
                          })
                    ]),
              ...(_showPin
                  ? []
                  : [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPin = true;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Body(text: 'I have a custom Admin PIN'),
                        ),
                      )
                    ]),
            ],
          ),
        ],
      ),
    ));
  }
}
