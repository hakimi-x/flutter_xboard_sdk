import '../models/config_model.dart';

abstract class ConfigApi {
  Future<ConfigModel> getConfig();
}
