import 'package:cryptstorage/pages/remove_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yubikit_flutter/openpgp/curve.dart';
import 'package:yubikit_flutter/openpgp/keyslot.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import '../pages/generate.dart';

class AnimatedLock extends StatelessWidget {
  const AnimatedLock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<YubikitEvent>(
        stream: YubikitFlutter.eventStream(),
        builder: (context, snapshot) {
          var visible = snapshot.connectionState == ConnectionState.active &&
              snapshot.data == YubikitEvent.deviceConnected;
          if (visible) {
            Future.delayed(const Duration(seconds: 1), () async {
              var session = YubikitFlutter.openPGPSession();
              try {
                await session.getECPublicKey(
                    KeySlot.signature, ECCurve.ed25519);
                await session.getECPublicKey(
                    KeySlot.encryption, ECCurve.ed25519);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RemoveToken()),
                );
              } catch (e) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Generate()),
                );
              } finally {
                session.stop();
              }
            });
          }
          return AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset('assets/images/keyok.svg',
                semanticsLabel: 'Card inserted OK'),
          );
        });
  }
}
