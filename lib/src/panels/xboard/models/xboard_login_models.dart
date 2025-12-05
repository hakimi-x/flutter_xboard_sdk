// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'xboard_login_models.freezed.dart';
part 'xboard_login_models.g.dart';

/// 登录请求模型
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

/// 登录数据模型
@freezed
class LoginData with _$LoginData {
  const factory LoginData({
    String? token,
    @JsonKey(name: 'auth_data') String? authData,
    Map<String, dynamic>? user,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) => _$LoginDataFromJson(json);
}

/// 登录响应模型 - 兼容XBoard API格式
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool success,
    String? message,
    LoginData? data, // 将data字段类型改为LoginData
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}

/// LoginResult 别名（向后兼容）
typedef LoginResult = LoginData;