import 'package:cryptstorage/model/key_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import '../navigation.dart';

class PageWidget extends StatelessWidget with GetItMixin {
  final Widget child;

  PageWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Reset token'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Use other token'),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  await get<YubikitOpenPGP>().reset();
                } else if (value == 1) {
                  get<KeyModel>().reset();
                  await get<Navigation>().backToApp();
                }
              }),
        ],
      ),
      body: SafeArea(
          child:
              child), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
