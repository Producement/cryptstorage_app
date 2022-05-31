import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:get_it/get_it.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class TokenService {
  final Openapi _openApi;
  final YubikitOpenPGP _interface;

  TokenService({Openapi? openApi, YubikitOpenPGP? interface})
      : _openApi = openApi ?? GetIt.I.get(),
        _interface = interface ?? GetIt.I.get();

  Future<String> getSignedToken(Uint8List signaturePublicKey) async {
    final tokenToSign = await _openApi.tokenGet(
        signaturePublicKey: base64Encode(signaturePublicKey));
    return await _sign(tokenToSign.body!.tokenToSign);
  }

  Future<String> _sign(String token) async {
    final signature = await _signWithToken(utf8.encode(token));
    return '$token.${base64Url.encode(signature).split('=')[0]}';
  }

  Future<Uint8List> _signWithToken(List<int> message) async {
    return await _interface.sign(Uint8List.fromList(message));
  }
}
