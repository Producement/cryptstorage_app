import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptstorage/api/token_service.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/injection.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwk/jwk.dart' as jwk;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mock_client.dart';
import 'token_service.mocks.dart';

@GenerateMocks([SmartCardService])
void main() {
  final interfaceMock = MockSmartCardService();
  final key = jwk.Jwk.fromJson({
    'kty': 'OKP',
    'crv': 'Ed25519',
    'x': utf8.encode('some-key'),
  });
  final tokenService = TokenService(
      smartCardService: interfaceMock,
      openApi: Openapi.create(client: createClient(client: mockClient)));

  test('signs token', () async {
    final signatureBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
    when(interfaceMock.ecSign(any)).thenAnswer((_) async => signatureBytes);
    expect(
        await tokenService.getSignedToken(key),
        equals(
            'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJleHAiOjE2NTM5ODM3NDQsImlhdCI6MTY1Mzk4MTk0NCwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl19.${base64Url.encode(signatureBytes).split('=')[0]}'));
  });
}
