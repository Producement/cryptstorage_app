import 'package:cryptstorage/button.dart';
import 'package:cryptstorage/images/exclamation.dart';
import 'package:flutter/material.dart';

import '../body.dart';
import '../heading.dart';

class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    ExclamationImage(),
                    Heading(title: "Folder is Empty"),
                    Body(
                        text:
                        "Secure your files by uploading them here"),
                  ],
                ),
                const Button(title: "Upload"),
              ],
            ),
          )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
