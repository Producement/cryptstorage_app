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

  void addSignaturePublicKey(List<int> signaturePublicKey) {
    final key = Jwk(
        kty: 'OKP',
        crv: 'Ed25519',
        x: base64Encode(signaturePublicKey),
        use: JwkUse.sig);
    _openApi.keysPost(body: ApiAddKeyRequest(content: key));
  }

  void addEncryptionPublicKey(List<int> encryptionPublicKey) {
    final key = Jwk(
        kty: 'OKP',
        crv: 'x25519',
        x: base64Encode(encryptionPublicKey),
        use: JwkUse.enc);
    _openApi.keysPost(body: ApiAddKeyRequest(content: key));
  }
}
