import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

void main() {
  final signingAlgorithm = Ed25519();

  test('token signature is valid', () async {
    const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9'
        '.eyJzdWIiOiJnVGwzRHFoOUYxOVdvMVJtdzB4LXpNdU5pcEcwN2plaVhmWVBXNF9KczVRIiwiY25mIjp7Imp3ayI6eyJrdHkiOiJPS1AiLCJ1c2UiOiJzaWciLCJjcnYiOiJFZDI1NTE5IiwieCI6ImdUbDNEcWg5RjE5V28xUm13MHgtek11TmlwRzA3amVpWGZZUFc0X0pzNVEifX0sImV4cCI6MTY1NDE2MTY2MiwiaWF0IjoxNjU0MTU5ODYyLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXX0'
        '.EkKN86RuFa4qBN2Y02LSjoxGl3njkvXAqWW5ki8iMMtmyRecvwcIugZpeHrfkl7crFOacY_JqQDPjDlwRH4dBg==';
    final tokenParts = token.split('.');
    final keyPair = await signingAlgorithm
        .newKeyPairFromSeed(List.generate(32, (index) => 0x02));
    final signingInput = '${tokenParts[0]}.${tokenParts[1]}';
    final sha512 = Sha512();
    final digest = await sha512.hash(utf8.encode(signingInput));
    final signature = Signature(base64Decode(tokenParts[2]),
        publicKey: await keyPair.extractPublicKey());
    final isValid =
        await signingAlgorithm.verify(digest.bytes, signature: signature);
    expect(isValid, isTrue);
  });
}
