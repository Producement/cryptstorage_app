import 'package:age_yubikey_pgp/interface.dart';
import 'package:age_yubikey_pgp/plugin.dart';
import 'package:cryptstorage/crypto/key_model.dart';
import 'package:cryptstorage/crypto/pin_model.dart';
import 'package:cryptstorage/images/no_key.dart';
import 'package:cryptstorage/ui/input.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import '../ui/body.dart';
import '../ui/button.dart';
import '../ui/heading.dart';

class Generate extends StatelessWidget {
  const Generate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyModel = context.read<KeyModel>();
    var text = 'No keys detected';
    if (keyModel.signingPublicKey == null) {
      text = 'No signing key detected';
    } else if (keyModel.getRecipients.isEmpty) {
      text = 'No encryption key detected';
    }
    final pinModel = context.read<PinModel>();
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
                    onChanged: (text) {
                      pinModel.adminPin = text;
                    },
                    hintText: 'Admin PIN'),
              ],
            ),
          ),
          Button(
              title: 'Yes',
              onPressed: () async {
                final interface = GetIt.instance.get<AgeYubikeyPGPInterface>();
                if (keyModel.signingPublicKey == null) {
                  final signingPublicKey = await interface.generateECKey(
                      KeySlot.signature, ECCurve.ed25519);
                  keyModel.signingPublicKey = signingPublicKey;
                }
                if (keyModel.getRecipients.isEmpty) {
                  final encryptionPublicKey =
                      await YubikeyPgpX2559AgePlugin.generate(
                          GetIt.instance.get<AgeYubikeyPGPInterface>());
                  keyModel.addRecipient(encryptionPublicKey);
                }
              }),
        ],
      ),
    ));
  }
}
