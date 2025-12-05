import '../../api/interfaces/config_api.dart';
import '../../api/models/config_model.dart';
import '../../panels/xboard/apis/xboard_config_api.dart';
import '../../panels/xboard/models/xboard_config_models.dart';

class XBoardConfigAdapter implements ConfigApi {
  final XBoardConfigApi _api;

  XBoardConfigAdapter(this._api);

  @override
  Future<ConfigModel> getConfig() async {
    final config = await _api.getConfig();
    return _mapConfig(config);
  }

  ConfigModel _mapConfig(ConfigData data) {
    return ConfigModel(
      tosUrl: data.tosUrl,
      isEmailVerify: data.isEmailVerify,
      isInviteForce: data.isInviteForce,
      emailWhitelistSuffix: data.emailWhitelistSuffix,
      isCaptcha: data.isCaptcha,
      captchaType: data.captchaType,
      recaptchaSiteKey: data.recaptchaSiteKey,
      recaptchaV3SiteKey: data.recaptchaV3SiteKey,
      recaptchaV3ScoreThreshold: data.recaptchaV3ScoreThreshold,
      turnstileSiteKey: data.turnstileSiteKey,
      appDescription: data.appDescription,
      appUrl: data.appUrl,
      logo: data.logo,
      isRecaptcha: data.isRecaptcha,
    );
  }
}
