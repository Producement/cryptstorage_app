import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:cryptstorage/api/token_service.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/model/session_model.dart';

import '../injection.dart';

class AuthenticationInterceptor implements RequestInterceptor {
  final jsonBase64 = json.fuse(utf8.fuse(base64Url));
  final SessionModel _sessionModel;
  final KeyModel _keyModel;
  final TokenService _tokenService;

  AuthenticationInterceptor(
      {SessionModel? sessionModel,
      KeyModel? keyModel,
      TokenService? tokenService})
      : _sessionModel = sessionModel ?? getIt(),
        _keyModel = keyModel ?? getIt(),
        _tokenService = tokenService ?? getIt();

  @override
  FutureOr<Request> onRequest(Request request) async {
    var accessToken = _sessionModel.accessToken;
    if (accessToken != null) {
      accessToken = verifiedToken(accessToken);
    }
    accessToken ??=
        await _tokenService.getSignedToken(_keyModel.signaturePublicKey!);
    _sessionModel.accessToken = accessToken;
    return applyHeader(request, 'Authorization', 'Bearer $accessToken');
  }

  String? verifiedToken(String accessToken) {
    final parts = accessToken.split('.');
    final dynamic payload = jsonBase64.decode(_base64Padded(parts[1]));
    final exp = DateTime.fromMillisecondsSinceEpoch(
      payload['exp'] * 1000,
    );
    if (exp.isBefore(DateTime.now())) {
      _sessionModel.accessToken = null;
      return null;
    }
    return accessToken;
  }

  String _base64Padded(String value) {
    final length = value.length;

    switch (length % 4) {
      case 2:
        return value.padRight(length + 2, '=');
      case 3:
        return value.padRight(length + 1, '=');
      default:
        return value;
    }
  }
}
