// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'xboard_config_models.freezed.dart';
part 'xboard_config_models.g.dart';

@freezed
class ConfigData with _$ConfigData {
  const factory ConfigData({
    @JsonKey(name: 'tos_url') String? tosUrl,
    @JsonKey(name: 'is_email_verify', fromJson: _intToBoolSafe, toJson: _boolToInt)
    @Default(false) bool isEmailVerify,
    @JsonKey(name: 'is_invite_force', fromJson: _intToBoolSafe, toJson: _boolToInt)
    @Default(false) bool isInviteForce,
    @JsonKey(name: 'email_whitelist_suffix', fromJson: _emailWhitelistFromJson, toJson: _emailWhitelistToJson)
    @Default([]) List<String> emailWhitelistSuffix,
    @JsonKey(name: 'is_captcha', fromJson: _intToBoolSafe, toJson: _boolToInt)
    @Default(false) bool isCaptcha,
    @JsonKey(name: 'captcha_type') @Default('') String captchaType,
    @JsonKey(name: 'recaptcha_site_key') String? recaptchaSiteKey,
    @JsonKey(name: 'recaptcha_v3_site_key') String? recaptchaV3SiteKey,
    @JsonKey(name: 'recaptcha_v3_score_threshold')
    @Default(0.5) double recaptchaV3ScoreThreshold,
    @JsonKey(name: 'turnstile_site_key') String? turnstileSiteKey,
    @JsonKey(name: 'app_description') @Default('') String appDescription,
    @JsonKey(name: 'app_url') @Default('') String appUrl,
    String? logo,
    @JsonKey(name: 'is_recaptcha', fromJson: _intToBoolSafe, toJson: _boolToInt)
    @Default(false) bool isRecaptcha,
  }) = _ConfigData;

  factory ConfigData.fromJson(Map<String, dynamic> json) => _$ConfigDataFromJson(json);
}

/// 安全地将整数或布尔值转换为布尔值
/// 支持: 0/1 (int), true/false (bool), null (返回 false)
bool _intToBoolSafe(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final intValue = int.tryParse(value);
    if (intValue != null) return intValue == 1;
    return value.toLowerCase() == 'true';
  }
  return false;
}

int _boolToInt(bool value) => value ? 1 : 0;

List<String> _emailWhitelistFromJson(dynamic value) {
  if (value is int && value == 0) {
    return [];
  }
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
}

dynamic _emailWhitelistToJson(List<String> value) {
  if (value.isEmpty) {
    return 0; // 或者根据API要求返回其他默认值
  }
  return value;
}


@freezed
class ConfigResponse with _$ConfigResponse {
  const factory ConfigResponse({
    required String status,
    required String message,
    ConfigData? data,
    dynamic error,
  }) = _ConfigResponse;

  factory ConfigResponse.fromJson(Map<String, dynamic> json) => _$ConfigResponseFromJson(json);
}