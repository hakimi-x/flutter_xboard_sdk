abstract class AuthApi {
  Future<String?> login(String email, String password);
  Future<bool> register(String email, String password, {String? emailCode, String? inviteCode});
  Future<bool> logout();
  Future<bool> sendEmailVerifyCode(String email);
  Future<bool> forgotPassword(String email, String code, String newPassword);
}
