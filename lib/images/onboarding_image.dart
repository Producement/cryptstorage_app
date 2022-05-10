import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        SvgPicture.asset('assets/images/bg3.svg',
            semanticsLabel: 'Background image 3'),
        SvgPicture.asset('assets/images/bg2.svg',
            semanticsLabel: 'Background image 2'),
        SvgPicture.asset('assets/images/bg1.svg',
            semanticsLabel: 'Background image 1'),
      ],
    );
  }
}
