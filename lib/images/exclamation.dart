import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExclamationImage extends StatelessWidget {
  const ExclamationImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/exclamation.svg',
        semanticsLabel: 'Exclamation');
  }
}
