import 'package:cryptstorage/images/animated_lock.dart';
import 'package:cryptstorage/heading.dart';
import 'package:cryptstorage/images/onboarding_image.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            AnimatedLock(),
            Heading(title: "Insert Yubikey"),
            OnboardingImage(),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
