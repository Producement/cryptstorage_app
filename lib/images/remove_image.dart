import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemoveImage extends StatelessWidget {
  const RemoveImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        SvgPicture.asset('assets/images/top3.svg',
            semanticsLabel: 'Top image 3'),
        SvgPicture.asset('assets/images/top2.svg',
            semanticsLabel: 'Top image 2'),
        SvgPicture.asset('assets/images/top1.svg',
            semanticsLabel: 'Top image 1'),
      ],
    );
  }
}
