import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/model/session_model.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../navigation.dart';

class PageWidget extends StatelessWidget with GetItMixin {
  final Widget child;

  PageWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              itemBuilder: (context) {
                return <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    textStyle: style,
                    value: 0,
                    child: const Text('Reset token'),
                  ),
                  PopupMenuItem<int>(
                    textStyle: style,
                    value: 1,
                    child: const Text('Setup new token'),
                  ),
                  if (kDebugMode) ...[
                    CheckedPopupMenuItem<int>(
                      value: 2,
                      checked: get<SmartCardService>().isMock(),
                      child: Text('Mock token', style: style),
                    )
                  ]
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  await get<SmartCardService>().reset();
                  get<KeyModel>().reset();
                  get<SessionModel>().reset();
                  await get<Navigation>().backToApp();
                } else if (value == 1) {
                  get<KeyModel>().reset();
                  get<SessionModel>().reset();
                  await get<Navigation>().backToApp();
                } else if (value == 2) {
                  await get<SmartCardService>().toggleMock();
                  get<KeyModel>().reset();
                  get<SessionModel>().reset();
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
