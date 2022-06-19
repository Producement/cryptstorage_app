import 'package:cryptstorage/api/token_service.dart';
import 'package:cryptstorage/images/remove_image.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/model/session_model.dart';
import 'package:cryptstorage/ui/loader.dart';
import 'package:cryptstorage/ui/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../navigation.dart';
import '../ui/body.dart';
import '../ui/button.dart';
import '../ui/heading.dart';

class RemoveToken extends StatefulWidget with GetItStatefulWidgetMixin {
  RemoveToken({Key? key}) : super(key: key);

  @override
  State<RemoveToken> createState() => _RemoveTokenState();
}

class _RemoveTokenState extends State<RemoveToken> with GetItStateMixin {
  String _statusTitle = 'Using your token to authenticate';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    get<TokenService>()
        .getSignedToken(get<KeyModel>().signaturePublicKey!)
        .then((accessToken) {
      get<SessionModel>().accessToken = accessToken;
      setState(() {
        _statusTitle = 'You may now remove your token';
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const RemoveImage(),
          Heading(title: _statusTitle),
          ...(_loading
              ? [const Loader()]
              : [
                  const Body(
                      text:
                          'You only need your token when you want to decrypt data or add new tokens'),
                  Button(
                      title: 'Continue',
                      onPressed: () async {
                        await get<Navigation>().goToUpload();
                      }),
                ]),
        ],
      ),
    ));
  }
}
