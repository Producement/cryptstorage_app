import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../generated/openapi.swagger.dart';

class KeyService {
  final Openapi _openApi;

  KeyService({
    Openapi? openApi,
  }) : _openApi = openApi ?? GetIt.I.get();

  Future<List<Jwk>> getKeys() async {
    final response = await _openApi.keysGet();
    return response.body!.map((e) => e.content).toList();
  }

  Future<ApiKey> addSignaturePublicKey(List<int> signaturePublicKey) async {
    final jwk = _signaturePublicKeyToJwk(signaturePublicKey);
    var response = await _openApi.keysPost(body: ApiAddKeyRequest(content: jwk));
    return response.body!;
  }

  Jwk _signaturePublicKeyToJwk(List<int> signaturePublicKey) {
    return Jwk(
      kty: 'OKP',
      crv: 'Ed25519',
      x: base64Encode(signaturePublicKey),
      use: JwkUse.sig);
  }

  Future<ApiKey> addEncryptionPublicKey(List<int> encryptionPublicKey) async {
    final jwk = _encryptionPublicKeyToJwk(encryptionPublicKey);
    var response = await _openApi.keysPost(body: ApiAddKeyRequest(content: jwk));
    return response.body!;
  }

  Jwk _encryptionPublicKeyToJwk(List<int> encryptionPublicKey) {
    return Jwk(
      kty: 'OKP',
      crv: 'x25519',
      x: base64Encode(encryptionPublicKey),
      use: JwkUse.enc);
  }

  Future<void> addEncryptionPublicKeyIfMissing(List<int> encryptionPublicKey) async {
    var keys = await getKeys();
    var encryptionJwk = _encryptionPublicKeyToJwk(encryptionPublicKey);
    if (!keys.contains(encryptionJwk)) {
      await addEncryptionPublicKey(encryptionPublicKey);
    }
  }

}
