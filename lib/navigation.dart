import 'package:cryptstorage/onboarding/generate.dart';
import 'package:cryptstorage/onboarding/onboarding.dart';
import 'package:cryptstorage/onboarding/remove_token.dart';
import 'package:flutter/material.dart';

import 'storage/upload.dart';

class Navigation {
  final GlobalKey<NavigatorState> _state;

  const Navigation(this._state);

  Future<Object?> _push(WidgetBuilder builder) async =>
      await _state.currentState?.push(MaterialPageRoute(builder: builder));

  Future<void> _replaceRoot(WidgetBuilder newRoot) async =>
      _state.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: newRoot), (route) => false);

  Future<void> goToGenerate() async {
    await _push((_) => Generate());
  }

  Future<void> goToUpload() async {
    await _replaceRoot((_) => Upload());
  }

  Future<void> backToApp() async {
    await _replaceRoot((_) => Onboarding());
  }

  Future<void> goToRemoveToken() async {
    await _push((_) => RemoveToken());
  }
}