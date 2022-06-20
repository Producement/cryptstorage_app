import 'package:cryptstorage/images/animated_lock.dart';
import 'package:cryptstorage/images/onboarding_image.dart';
import 'package:cryptstorage/onboarding/service.dart';
import 'package:cryptstorage/ui/heading.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../navigation.dart';
import '../ui/button.dart';
import '../ui/sub_heading.dart';

class Onboarding extends StatelessWidget with GetItMixin {
  Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const AnimatedLock(visible: false),
      Expanded(
          child: Stack(alignment: AlignmentDirectional.topStart, children: [
        Column(children: const [
          Heading(title: 'Put a lock on your files.'),
          SubHeading(title: 'Powered by YubiKey.')
        ]),
        const Center(child: OnboardingImage()),
      ])),
      Button(
        icon: SvgPicture.asset('assets/images/yk-yubikey.svg',
            semanticsLabel: 'YubiKey', height: 18),
        title: 'Insert YubiKey',
        onPressed: _handlePress,
      ),
      Button(
        icon: SvgPicture.asset('assets/images/contactless_indicator.svg',
            semanticsLabel: 'NFC', height: 16),
        title: 'Use NFC',
        onPressed: _handlePress,
      ),
    ]));
  }

  void _handlePress() async {
    debugPrint('Continuing');
    final isKeyInitialized = await get<OnboardingService>().fetchKeyInfo();
    if (isKeyInitialized) {
      await get<Navigation>().goToRemoveToken();
    } else {
      await get<Navigation>().goToGenerate();
    }
  }
}
