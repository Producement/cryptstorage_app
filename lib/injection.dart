import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:chopper/chopper.dart';
import 'package:cryptstorage/api/authentication_interceptor.dart';
import 'package:cryptstorage/api/file_service.dart';
import 'package:cryptstorage/api/key_service.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/model/pin_model.dart';
import 'package:cryptstorage/model/session_model.dart';
import 'package:cryptstorage/navigation.dart';
import 'package:cryptstorage/onboarding/service.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:cryptstorage/storage/file_downloader.dart';
import 'package:cryptstorage/storage/file_uploader.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

import 'api/token_service.dart';
import 'generated/openapi.swagger.dart';

const baseUrl = 'https://cryptstorage.fly.dev/api/v1';
final getIt = GetIt.instance;

ChopperClient createClient(
    {http.Client? client, List<RequestInterceptor> interceptors = const []}) {
  return ChopperClient(
    baseUrl: baseUrl,
    client: client,
    interceptors: interceptors,
    converter: $JsonSerializableConverter(),
  );
}

Future<void> setupInjection() async {
  await getIt.reset();
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton(prefs);
  getIt.registerSingleton(PinModel());
  getIt.registerSingleton(KeyModel());
  getIt.registerSingleton(SessionModel());
  getIt.registerSingleton(GlobalKey<NavigatorState>());
  getIt.registerSingleton(Navigation());
  getIt.registerSingleton(SmartCardService(
      interface: YubikitFlutter.smartCard(), pinProvider: getIt<PinModel>()));
  registerPlugin(getIt<SmartCardService>());
  getIt.registerSingleton(
      FileDownloader(http.Client(), getIt<SmartCardService>()));

  // Services
  final publicClient = createClient(interceptors: [HttpLoggingInterceptor()]);
  final tokenService =
      TokenService(openApi: Openapi.create(client: publicClient));
  getIt.registerSingleton(tokenService);
  final authenticatedClient = createClient(
      interceptors: [AuthenticationInterceptor(), HttpLoggingInterceptor()]);
  getIt.registerSingleton(Openapi.create(client: authenticatedClient));
  getIt.registerSingleton(OnboardingService());
  getIt.registerSingleton(KeyService());
  getIt.registerSingleton(FileService());
  getIt.registerSingleton(FileUploader(
      getIt<KeyModel>(), getIt<KeyService>(), getIt<FileService>()));
  await getIt.allReady();
}
