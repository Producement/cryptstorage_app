import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:jwk/jwk.dart' as jwk;
import 'package:logging/logging.dart';

import '../generated/openapi.swagger.dart';

class KeyService {
  final logger = Logger('KeyService');
  final Openapi _openApi;

  KeyService({
    Openapi? openApi,
  }) : _openApi = openApi ?? GetIt.I.get();

  Future<List<Jwk>> getKeys() async {
    logger.info('Getting keys');
    final response = await _openApi.keysGet();
    return response.body!.map((e) => e.content).toList();
  }

  Future<ApiKey> addEncryptionPublicKey(jwk.Jwk encryptionPublicKey) async {
    logger.info('Adding new encryption key: $encryptionPublicKey');
    final jwk = _encryptionPublicKeyToJwk(encryptionPublicKey);
    final response =
        await _openApi.keysPost(body: ApiAddKeyRequest(content: jwk));
    return response.body!;
  }

  Jwk _encryptionPublicKeyToJwk(jwk.Jwk encryptionPublicKey) {
    if (encryptionPublicKey.kty == 'RSA') {
      return RsaJwk(
          kty: encryptionPublicKey.kty!,
          n: base64UrlEncode(encryptionPublicKey.n!),
          e: base64UrlEncode(encryptionPublicKey.e!),
          use: JwkUse.enc);
    }
    return EllipticJwk(
        kty: 'OKP',
        crv: 'x25519',
        x: base64UrlEncode(encryptionPublicKey.x!),
        use: JwkUse.enc);
  }

  Future<void> addEncryptionPublicKeyIfMissing(
      jwk.Jwk encryptionPublicKey) async {
    final keys = await getKeys();
    final encryptionJwk = _encryptionPublicKeyToJwk(encryptionPublicKey);
    if (!keys.contains(encryptionJwk)) {
      await addEncryptionPublicKey(encryptionPublicKey);
    }
  }
}
