import 'package:recparenting/environments/env_model.dart';

class DevConfig implements EnvConfig {
  @override
  String get url => 'http://192.168.1.37/';
  @override
  String get apiUrl => 'http://192.168.1.37/api/';
  @override
  String get clientId => '9a1b7e82-7e64-4167-b751-02345a21783e';
  @override
  String get clientSecret => 'a2ppSmwcxyP7YUsp6ARWmpW49jXSli4EWdA0nvNb';
  @override
  String get authorizationRecMobile => 'xxxx';
}
