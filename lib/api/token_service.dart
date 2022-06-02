import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:get_it/get_it.dart';

class TokenService {
  final Openapi _openApi;
  final SmartCardService _smartCardService;

  TokenService({Openapi? openApi, SmartCardService? smartCardService})
      : _openApi = openApi ?? GetIt.I.get(),
        _smartCardService = smartCardService ?? GetIt.I.get();

  Future<String> getSignedToken(Uint8List signaturePublicKey) async {
    final tokenToSign = await _openApi.tokenGet(
        signaturePublicKey: base64UrlEncode(signaturePublicKey).split('=')[0]);
    return await _sign(tokenToSign.body!.tokenToSign);
  }

  Future<String> _sign(String token) async {
    final signature = await _signWithToken(utf8.encode(token));
    return '$token.${base64UrlEncode(signature).split('=')[0]}';
  }

  Future<Uint8List> _signWithToken(List<int> message) async {
    return await _smartCardService.sign(Uint8List.fromList(message));
  }
}
