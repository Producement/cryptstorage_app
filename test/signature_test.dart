import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
// ignore: depend_on_referenced_packages
import 'package:pointycastle/export.dart' as pc;
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

  test('token rsa signature is valid', () async {
    const token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJtYnpnNkl2TnBiNTI0SGlSQVZOZlAwLW1xUzF5UnhyRkRHX2ZRdTA5amhvIiwiY25mIjp7Imp3ayI6eyJrdHkiOiJSU0EiLCJlIjoiQVFBQiIsIm4iOiJ4SlBpelFjdlFyeWh5cmRyT0hLVzQ1UHhnR2dDQ05SMGZNZmlsOUZ3VWQ3UmtRZHB1cWlkeWhES1RPc3RUNXR1UG9Lb043cXNqVUF5TGhzSkdCVVJNNk9lcVdEd3huOUxSY0x4WHlUY0l0cU45VVR5ckpEZkVqWHphNTNnMVJBZk5fRUpZVzJlY2VXalFTLTAtSzhRZjlXUGpBZ2FsX3hXbzRuWGk5Nmg0bkJsczk0dWVIN1BLam9nWHBrTWpBZWJSZWFSUHBNNjRJQVU4UU0wUXk1THFYUjZCTVgzZWstaUJteHVNakxoWHU0dTRmOGlrbHVHMkNmNENSNklWSlNJQlI5enhta3RVNHJaSzd4QWQ2U1JHWGRlWXQwUkUyNk12czlJYmRwT2lPUXkxTnhEWHdrQzQ2UGZtX1ZJQjVCUGpXRVAxZXhuRFpGSzBJeFFFd2xzOTNIdzlVNWVQdz09In19LCJleHAiOjE2NTUyMjU0OTAsImlhdCI6MTY1NTIyMzY5MCwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl19.pZpM20zUB6EA-pWUe4t0rEtPURtQbBlbyJepKsXHxyQzn-IWDK0mmYKO-Aq4YC8IOb_OaiKMHIkf0FIHDV9YYoaSn0vy1JR3jW-34bnYjzyHI_4axcDJUYt9R8VkwGrjaPmflrKnBa35bY8fdC9Ti6Tt0QNkP3rgRpoMTOkhsjqfWewydiBvoazoMXsNCxakLPTphvmaAmz1zY4nvUQQVJYs9lbIUv09e0gBuL1Xx0IzP3grwimfQoBl08A6lse6lu4R-w7xc_2k8mtZGzwWPbt_BBl-oVx4wtHuS318_C56v24EpMvDyX0raOO4ig5NEnV1lxH-dHsCO8PrgTscTvpqTzOCYg==';
    final tokenParts = token.split('.');
    final signer = pc.RSASigner(pc.SHA512Digest(), '0609608648016503040203');
    final signingInput = '${tokenParts[0]}.${tokenParts[1]}';
    final exponent = base64.decode('AQAB');
    final modulus = base64.decode(
        'xJPizQcvQryhyrdrOHKW45PxgGgCCNR0fMfil9FwUd7RkQdpuqidyhDKTOstT5tuPoKoN7qsjUAyLhsJGBURM6OeqWDwxn9LRcLxXyTcItqN9UTyrJDfEjXza53g1RAfN_EJYW2eceWjQS-0-K8Qf9WPjAgal_xWo4nXi96h4nBls94ueH7PKjogXpkMjAebReaRPpM64IAU8QM0Qy5LqXR6BMX3ek-iBmxuMjLhXu4u4f8ikluG2Cf4CR6IVJSIBR9zxmktU4rZK7xAd6SRGXdeYt0RE26Mvs9IbdpOiOQy1NxDXwkC46Pfm_VIB5BPjWEP1exnDZFK0IxQEwls93Hw9U5ePw==');

    final signature = pc.RSASignature(base64Url.decode(tokenParts[2]));
    final pubKey = pc.RSAPublicKey(BigInt.parse(hex.encode(modulus), radix: 16),
        BigInt.parse(hex.encode(exponent), radix: 16));
    pc.AsymmetricKeyParameter<pc.RSAPublicKey> param =
        pc.PublicKeyParameter(pubKey);
    signer.init(false, param);
    final isValid = signer.verifySignature(
        Uint8List.fromList(utf8.encode(signingInput)), signature);
    expect(isValid, isTrue);
  });
}
