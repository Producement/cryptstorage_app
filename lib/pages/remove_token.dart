import 'package:cryptstorage/images/remove_image.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:cryptstorage/pages/upload.dart';
import 'package:flutter/material.dart';

import '../ui/body.dart';
import '../ui/button.dart';
import '../ui/heading.dart';

class RemoveToken extends StatelessWidget {
  const RemoveToken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const RemoveImage(),
          const Heading(title: 'You may now remove your card'),
          const Body(
              text:
                  'You only need your keys when you want to decrypt data or add new cards'),
          Button(
              title: 'Continue',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Upload()),
                );
              }),
        ],
      ),
    ));
  }
}
