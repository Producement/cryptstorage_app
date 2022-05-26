import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedLock extends StatelessWidget {
  final bool visible;

  const AnimatedLock({Key? key, required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: SvgPicture.asset('assets/images/keyok.svg',
          semanticsLabel: 'Card inserted OK'),
    );
  }
}
