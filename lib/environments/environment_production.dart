import 'package:recparenting/environments/env_model.dart';

class ProdConfig implements EnvConfig {
  @override
  String get web => 'https://www.recparenting.com/';
  @override
  String get url => 'https://www.recparenting.net/';
  @override
  String get apiUrl => 'https://www.recparenting.net/apiMobile/';
  @override
  String get clientId => '2';
  @override
  String get clientSecret => 'EV0UA75FX23zhkJFbB7D8SaHNRloZdQCXDW17hdu';
  @override
  String get pusherAppId => '1404349';
  @override
  String get pusherAppKey => '75a6a9ada98076b7556c';
  @override
  String get pusherAppSecret => 'c79d8ba17123c386ad4e';
  @override
  String get pusherAppCluster => 'eu';
}
