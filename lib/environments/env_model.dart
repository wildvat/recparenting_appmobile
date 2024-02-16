enum EnvTypes { development, production }

abstract class EnvConfig {
  EnvTypes get type;
  String get web;
  String get url;
  String get apiUrl;
  String get clientId;
  String get clientSecret;
  String get pusherAppId;
  String get pusherAppKey;
  String get pusherAppSecret;
  String get pusherAppCluster;
  String get bugsnagApiKey;
}
