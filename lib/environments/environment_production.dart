import 'package:recparenting/environments/env_model.dart';

class ProdConfig implements EnvConfig {
  @override
  EnvTypes get type => EnvTypes.production;
  @override
  String get web => 'https://www.recparenting.com/';
  @override
  String get url => 'https://app.recparenting.com/';
  @override
  String get apiUrl => 'https://app.recparenting.com/api/';
  @override
  String get clientId => '9a1b7e82-7e64-4167-b751-02345a21783e';
  @override
  String get clientSecret => 'a2ppSmwcxyP7YUsp6ARWmpW49jXSli4EWdA0nvNb';
  @override
  String get pusherAppId => '1441200';
  @override
  String get pusherAppKey => '7e49681775b557e70717';
  @override
  String get pusherAppSecret => '67afed448f3f308cf250';
  @override
  String get pusherAppCluster => 'eu';
  @override
  String get bugsnagApiKey => 'f1894b8b872b2fc94f45e5187da57abe';
}
