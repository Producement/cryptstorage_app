import 'package:cryptstorage/images/remove_image.dart';
import 'package:cryptstorage/pages/upload.dart';
import 'package:flutter/material.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import '../body.dart';
import '../heading.dart';

class RemoveToken extends StatelessWidget {
  const RemoveToken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: StreamBuilder<YubikitEvent>(
            stream: YubikitFlutter.eventStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.data == YubikitEvent.deviceDisconnected) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Upload()),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  RemoveImage(),
                  Heading(title: "You may now remove your card"),
                  Body(
                      text:
                          "You only need your keys when you want to decrypt data or add new cards"),
                ],
              );
            }),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
