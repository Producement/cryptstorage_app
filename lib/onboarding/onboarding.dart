import 'package:cryptstorage/images/animated_lock.dart';
import 'package:cryptstorage/images/onboarding_image.dart';
import 'package:cryptstorage/onboarding/service.dart';
import 'package:cryptstorage/ui/heading.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../navigation.dart';
import '../ui/button.dart';

class Onboarding extends StatelessWidget with GetItMixin {
  Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onboardingService = get<OnboardingService>();
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
                  final initialised = await onboardingService.fetchKeyInfo();
                  if (initialised) {
                    await get<Navigation>().goToRemoveToken();
                  } else {
                    await get<Navigation>().goToGenerate();
                  }
                },
              ),
            ),
          ]),
        ],
      )),
    );
  }
}