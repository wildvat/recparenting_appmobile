import 'package:recparenting/environments/env_model.dart';

class DevConfig implements EnvConfig {
  @override
  String get url => 'http://192.168.1.38/';
  @override
  String get apiUrl => 'http://192.168.1.38/api/';
  @override
  String get clientId => '9a1b7e82-7e64-4167-b751-02345a21783e';
  @override
  String get clientSecret => 'a2ppSmwcxyP7YUsp6ARWmpW49jXSli4EWdA0nvNb';
  @override
  String get pusherAppId => '1404349';
  @override
  String get pusherAppKey => '75a6a9ada98076b7556c';
  @override
  String get pusherAppSecret => 'c79d8ba17123c386ad4e';
  @override
  String get pusherAppCluster => 'eu';
}
