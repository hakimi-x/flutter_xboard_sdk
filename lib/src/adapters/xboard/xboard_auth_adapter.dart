import '../../api/interfaces/auth_api.dart';
import '../../panels/xboard/apis/xboard_login_api.dart';
import '../../panels/xboard/apis/xboard_register_api.dart';
import '../../panels/xboard/apis/xboard_reset_password_api.dart';
import '../../panels/xboard/apis/xboard_send_email_code_api.dart';

class XBoardAuthAdapter implements AuthApi {
  final XBoardLoginApi _loginApi;
  final XBoardRegisterApi _registerApi;
  final XBoardSendEmailCodeApi _emailCodeApi;
  final XBoardResetPasswordApi _resetPasswordApi;

  XBoardAuthAdapter(
    this._loginApi,
    this._registerApi,
    this._emailCodeApi,
    this._resetPasswordApi,
  );

  @override
  Future<String?> login(String email, String password) async {
    final response = await _loginApi.login(email, password);
    return response.authData ?? response.token;
  }

  @override
  Future<bool> register(String email, String password, {String? emailCode, String? inviteCode}) async {
    final response = await _registerApi.register(email, password, inviteCode, emailCode);
    // Assuming response.data is Map and contains token
    final data = response.data as Map<String, dynamic>?;
    return data != null && data.containsKey('token');
  }

  Future<bool> resetPassword(String email, String password, String emailCode) async {
    final response = await _resetPasswordApi.resetPassword(
      email: email,
      password: password,
      emailCode: emailCode,
    );
    return response.success;
  }

  @override
  Future<bool> logout() async {
    // XBoard doesn't typically have a logout API, client just clears token.
    // But if there is one, call it.
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
