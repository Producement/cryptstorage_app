import 'package:cryptstorage/images/remove_image.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../navigation.dart';
import '../ui/body.dart';
import '../ui/button.dart';
import '../ui/heading.dart';

class RemoveToken extends StatelessWidget with GetItMixin {
  RemoveToken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const RemoveImage(),
          const Heading(title: 'You may now remove your token'),
          const Body(
              text:
                  'You only need your token when you want to decrypt data or add new tokens'),
          Button(
              title: 'Continue',
              onPressed: () async {
                await get<Navigation>().goToUpload();
              }),
        ],
      ),
    ));
  }
}