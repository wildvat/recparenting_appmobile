import 'package:recparenting/environments/env_model.dart';
import 'package:recparenting/environments/environment_development.dart';
import 'package:recparenting/environments/environment_production.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

final EnvConfig env = isProduction ? ProdConfig() : DevConfig();
