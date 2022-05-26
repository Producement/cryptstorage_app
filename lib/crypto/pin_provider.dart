import 'package:age_yubikey_pgp/pin_provider.dart';
import 'package:cryptstorage/crypto/pin_model.dart';

class FlutterPinProvider extends PinProvider {
  final PinModel _pinModel;

  const FlutterPinProvider(this._pinModel);

  @override
  String adminPin() {
    return _pinModel.adminPin;
  }

  @override
  String pin() {
    return _pinModel.pin;
  }
}
