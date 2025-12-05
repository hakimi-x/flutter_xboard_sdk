import '../../api/interfaces/auth_api.dart';
import '../../panels/v2board/apis/v2board_login_api.dart';
import '../../panels/v2board/apis/v2board_register_api.dart';
import '../../panels/v2board/apis/v2board_reset_password_api.dart';
import '../../panels/v2board/apis/v2board_send_email_code_api.dart';

class V2BoardAuthAdapter implements AuthApi {
  final V2BoardLoginApi _loginApi;
  final V2BoardRegisterApi _registerApi;
  final V2BoardSendEmailCodeApi _emailCodeApi;
  final V2BoardResetPasswordApi _resetPasswordApi;

  V2BoardAuthAdapter(
    this._loginApi,
    this._registerApi,
    this._emailCodeApi,
    this._resetPasswordApi,
  );

  @override
  Future<String?> login(String email, String password) async {
    final response = await _loginApi.login(email, password);
    return response.token;
  }

  @override
  Future<bool> register(String email, String password, {String? emailCode, String? inviteCode}) async {
    final response = await _registerApi.register(email, password, emailCode, inviteCode);
    final data = response.data as Map<String, dynamic>?;
    return data != null && data.containsKey('token');
  }

  @override
  Future<bool> logout() async {
    return true;
  }

  @override
  Future<bool> sendEmailVerifyCode(String email) async {
    final result = await _emailCodeApi.sendEmailCode(email);
    return result.success;
  }

  @override
  Future<bool> forgotPassword(String email, String code, String newPassword) async {
    final response = await _resetPasswordApi.resetPassword(
      email: email,
      password: newPassword,
      emailCode: code,
    );
    return response.success;
  }
}
