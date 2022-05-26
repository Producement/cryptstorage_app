import 'package:age_yubikey_pgp/interface.dart';
import 'package:age_yubikey_pgp/plugin.dart';
import 'package:cryptstorage/crypto/key_model.dart';
import 'package:cryptstorage/extensions.dart';
import 'package:cryptstorage/ui/heading.dart';
import 'package:cryptstorage/images/animated_lock.dart';
import 'package:cryptstorage/images/onboarding_image.dart';
import 'package:cryptstorage/pages/generate.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:cryptstorage/pages/remove_token.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import '../ui/button.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchKeys() async {
    final keyModel = context.read<KeyModel>();
    final interface = GetIt.instance.get<YubikitOpenPGP>();
    final signingPublicKey = await interface.getECPublicKey(KeySlot.signature);
    final encryptionKey = await YubikeyPgpX2559AgePlugin.fromCard(
        GetIt.instance.get<AgeYubikeyPGPInterface>());
    if (signingPublicKey != null) {
      keyModel.signingPublicKey = signingPublicKey;
    }
    if (encryptionKey != null) {
      keyModel.addRecipient(encryptionKey);
    }
    if (!mounted) return;
    if (keyModel.isKeyInitialised) {
      await context.goto(() => const RemoveToken());
    } else {
      await context.goto(() => const Generate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const AnimatedLock(visible: false),
          const Heading(title: 'Insert Yubikey'),
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
            const Center(child: OnboardingImage()),
            Center(
              child: Button(
                title: 'Continue',
                onPressed: () async {
                  await fetchKeys();
                },
              ),
            ),
          ]),
        ],
      )),
    );
  }
}
