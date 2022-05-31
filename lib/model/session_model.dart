import 'package:flutter/foundation.dart';

class SessionModel extends ChangeNotifier {
  String? _accessToken;

  set accessToken(String? accessToken) {
    _accessToken = accessToken;
    notifyListeners();
  }

  String? get accessToken {
    return _accessToken;
  }
}
