import 'package:cryptstorage/onboarding/generate.dart';
import 'package:cryptstorage/onboarding/onboarding.dart';
import 'package:cryptstorage/onboarding/remove_token.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'storage/upload.dart';

class Navigation {
  final GlobalKey<NavigatorState> _state;

  Navigation({GlobalKey<NavigatorState>? state})
      : _state = state ?? GetIt.I.get();

  Future<void> _replaceRoot(WidgetBuilder newRoot) async {
    await _state.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: newRoot), (route) => false);
  }

  Future<void> goToGenerate() async {
    if (_state.currentWidget is Generate) {
      return;
    }
    await _replaceRoot((_) => Generate());
  }

  Future<void> goToUpload() async {
    if (_state.currentWidget is Upload) {
      return;
    }
    await _replaceRoot((_) => Upload());
  }

  Future<void> backToApp() async {
    if (_state.currentWidget is Onboarding) {
      return;
    }
    await _replaceRoot((_) => Onboarding());
  }

  Future<void> goToRemoveToken() async {
    if (_state.currentWidget is RemoveToken) {
      return;
    }
    await _replaceRoot((_) => RemoveToken());
  }
}
