import '../../../core/http/http_service.dart';
import '../models/xboard_user_info_models.dart';
import '../../../core/models/api_response.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 用户信息 API 实现
class XBoardUserInfoApi {
  final HttpService _httpService;

  XBoardUserInfoApi(this._httpService);

  Future<ApiResponse<UserInfo>> getUserInfo() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/info');
      return ApiResponse.fromJson(
        result,
        (json) => UserInfo.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取用户信息失败: $e');
    }
  }

  Future<ApiResponse<bool>> validateToken() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/getSubscribe');
      // 如果能成功获取订阅信息，说明token有效
      return ApiResponse.fromJson(result, (json) => json['subscribe_url'] != null);
    } catch (e) {
      // 如果请求失败（401等），说明token无效
      return ApiResponse(
        success: false,
        message: 'Token validation failed',
        data: false,
      );
    }
  }

  Future<ApiResponse<String?>> getSubscriptionLink() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/getSubscribe');
      return ApiResponse.fromJson(result, (json) => json['subscribe_url'] as String?);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取订阅链接失败: $e');
    }
  }

  Future<ApiResponse<String?>> resetSubscriptionLink() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/resetSecurity');
      return ApiResponse.fromJson(result, (json) => json as String?);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('重置订阅链接失败: $e');
    }
  }

  Future<ApiResponse<void>> toggleTrafficReminder(bool value) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/update', {
        'remind_traffic': value ? 1 : 0,
      });
      return ApiResponse.fromJson(result, (json) {});
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('切换流量提醒失败: $e');
    }
  }

  Future<ApiResponse<void>> toggleExpireReminder(bool value) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/update', {
        'remind_expire': value ? 1 : 0,
      });
      return ApiResponse.fromJson(result, (json) {});
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('切换到期提醒失败: $e');
    }
  }
  Future<ApiResponse<void>> updateUserInfo(Map<String, dynamic> data) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/update', data);
      return ApiResponse.fromJson(result, (json) {});
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('更新用户信息失败: $e');
    }
  }
}
