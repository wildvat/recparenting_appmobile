import 'package:recparenting/environments/env_model.dart';

class DevConfig implements EnvConfig {
  @override
  String get web => 'https://www.recparenting.com/';
  @override
  //String get url => 'https://rec.upthemedia.com/';
  //String get url => 'http://192.168.1.37/';
  String get url => 'http://192.168.1.38/';
  //String get url => 'http://192.168.1.146/';
  //String get url => 'http://192.168.18.124/';
  @override
  //String get apiUrl => 'https://rec.upthemedia.com/api/';
  //String get apiUrl => 'http://192.168.1.37/api/';
  String get apiUrl => 'http://192.168.1.38/api/';
  //String get apiUrl => 'http://192.168.1.146/api/';
  //String get apiUrl => 'http://192.168.18.124/api/';
  @override
  String get clientId => '9a1b7e82-7e64-4167-b751-02345a21783e';
  @override
  String get clientSecret => 'a2ppSmwcxyP7YUsp6ARWmpW49jXSli4EWdA0nvNb';
  @override
  String get pusherAppId => '1441198';
  @override
  String get pusherAppKey => 'fe85be4e0fa8ffac8574';
  @override
  String get pusherAppSecret => '74e6149e0d6f08818c97';
  @override
  String get pusherAppCluster => 'eu';
  @override
  String get bugsnagApiKey => 'f1894b8b872b2fc94f45e5187da57abe';
}
