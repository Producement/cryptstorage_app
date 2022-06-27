import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:get_it/get_it.dart';
import 'package:jwk/jwk.dart' as jwk;
import 'package:logging/logging.dart';

class TokenService {
  final logger = Logger('TokenService');
  final Openapi _openApi;
  final SmartCardService _smartCardService;

  TokenService({Openapi? openApi, SmartCardService? smartCardService})
      : _openApi = openApi ?? GetIt.I.get(),
        _smartCardService = smartCardService ?? GetIt.I.get();

  Future<String> getSignedToken(jwk.Jwk signaturePublicKey) async {
    logger.info('Getting signed token with ${signaturePublicKey.toJson()}');
    final response = await _openApi.tokenGet(
        signaturePublicKey:
            base64UrlEncode(signaturePublicKey.toUtf8()).split('=')[0]);
    if (!response.isSuccessful) {
      throw Exception(
          'Getting the token to sign failed: ${response.statusCode} ${response.error}');
    }
    return await _sign(
        response.body!.tokenToSign, signaturePublicKey.kty == 'RSA');
  }

  Future<String> _sign(String token, bool rsa) async {
    logger.info('Signing token: rsa=$rsa');
    final signature = await _signWithToken(utf8.encode(token), rsa);
    return '$token.${base64UrlEncode(signature).split('=')[0]}';
  }

  Future<Uint8List> _signWithToken(List<int> message, bool rsa) async {
    if (rsa) {
      return await _smartCardService.rsaSign(message);
    } else {
      return await _smartCardService.ecSign(message);
    }
  }
}
