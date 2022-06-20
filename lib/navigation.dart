import 'package:cryptstorage/onboarding/generate.dart';
import 'package:cryptstorage/onboarding/onboarding.dart';
import 'package:cryptstorage/onboarding/remove_token.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'storage/upload.dart';

class Navigation {
  final logger = Logger('Navigation');
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
    logger.info('to Generate');
    await _replaceRoot((_) => Generate());
  }

  Future<void> goToUpload() async {
    if (_state.currentWidget is Upload) {
      return;
    }
    logger.info('to Upload');
    await _replaceRoot((_) => Upload());
  }

  Future<void> backToApp() async {
    if (_state.currentWidget is Onboarding) {
      return;
    }
    logger.info('to Onboarding');
    await _replaceRoot((_) => Onboarding());
  }

  Future<void> goToRemoveToken() async {
    if (_state.currentWidget is RemoveToken) {
      return;
    }
    logger.info('to RemoveToken');
    await _replaceRoot((_) => RemoveToken());
  }
}
