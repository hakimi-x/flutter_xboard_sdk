import '../../api/interfaces/user_api.dart';
import '../../api/models/user_model.dart';
import '../../panels/xboard/apis/xboard_user_info_api.dart';
import '../../panels/xboard/models/xboard_user_info_models.dart';

class XBoardUserAdapter implements UserApi {
  final XBoardUserInfoApi _api;

  XBoardUserAdapter(this._api);

  @override
  Future<UserModel> getUserInfo() async {
    final response = await _api.getUserInfo();
    final userInfo = response.data;
    if (userInfo == null) {
      throw Exception('User info is null');
    }
    return _mapUserInfo(userInfo);
  }

  @override
  Future<bool> updateUserInfo(Map<String, dynamic> data) async {
    final response = await _api.updateUserInfo(data);
    return response.success;
  }

  @override
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    // TODO: Implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<bool> resetSecurity() async {
    // TODO: Implement resetSecurity
    throw UnimplementedError();
  }

  UserModel _mapUserInfo(UserInfo info) {
    return UserModel(
      email: info.email,
      transferEnable: info.transferEnable,
      lastLoginAt: info.lastLoginAt,
      createdAt: info.createdAt,
      banned: info.banned,
      remindExpire: info.remindExpire,
      remindTraffic: info.remindTraffic,
      expiredAt: info.expiredAt,
      balance: info.balance,
      commissionBalance: info.commissionBalance,
      planId: info.planId,
      discount: info.discount,
      commissionRate: info.commissionRate,
      telegramId: info.telegramId,
      uuid: info.uuid,
      avatarUrl: info.avatarUrl,
    );
  }
}
