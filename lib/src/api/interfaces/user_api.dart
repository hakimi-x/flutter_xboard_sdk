import '../models/user_model.dart';

abstract class UserApi {
  Future<UserModel> getUserInfo();
  Future<bool> updateUserInfo(Map<String, dynamic> data);
  Future<bool> changePassword(String oldPassword, String newPassword);
  Future<bool> resetSecurity();
}
