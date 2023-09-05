import 'package:recparenting/environments/env_model.dart';

class ProdConfig implements EnvConfig {
  @override
  String get url => 'https://www.recparenting.net/';
  @override
  String get apiUrl => 'https://www.recparenting.net/apiMobile/';
  @override
  String get clientId => '2';
  @override
  String get clientSecret => 'EV0UA75FX23zhkJFbB7D8SaHNRloZdQCXDW17hdu';
}
