import 'dart:convert';

import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

final mockClient = MockClient((request) async {
  if (request.url == Uri.parse('https://s3/filename.txt')) {
    return Response('file content', 200,
        headers: {'content-type': 'text/plain'});
  }

  if (request.url.path != '/api/v1/token') {
    return Response('', 404);
  }

  if (!request.url.queryParameters.containsKey('signaturePublicKey')) {
    return Response('', 400);
  }

  return Response(
      jsonEncode(ApiTokenToSign(
          tokenToSign:
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJleHAiOjE2NTM5ODM3NDQsImlhdCI6MTY1Mzk4MTk0NCwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl19')),
      200,
      headers: {'content-type': 'application/json'});
});
