import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoKeyImage extends StatelessWidget {
  const NoKeyImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset('assets/images/key.svg', semanticsLabel: 'No key'),
        CustomPaint(
          size: const Size(55, 55),
          painter: CrossPainter(),
        ),
      ],
    );
  }
}

class CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(
        size.bottomLeft(Offset.zero), size.topRight(Offset.zero), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
