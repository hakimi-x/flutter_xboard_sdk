import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_user_info_models.dart';

/// V2Board 用户信息 API 实现
class V2BoardUserInfoApi {
  final HttpService _httpService;

  V2BoardUserInfoApi(this._httpService);

  Future<ApiResponse<UserInfo>> getUserInfo() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/info');
      
      if (result['data'] != null) {
        final userInfo = UserInfo.fromJson(result['data'] as Map<String, dynamic>);
        return ApiResponse(
          success: true,
          data: userInfo,
        );
      }
      
      return ApiResponse(
        success: false,
        message: result['message'] ?? '获取用户信息失败',
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取用户信息失败: $e');
    }
  }

  Future<ApiResponse<bool>> validateToken() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/info');
      return ApiResponse(
        success: result['data'] != null,
        data: result['data'] != null,
      );
    } catch (e) {
      return ApiResponse(success: false, data: false);
    }
  }

  Future<ApiResponse<String?>> getSubscriptionLink() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/getSubscribe');
      
      final data = result['data'] as Map<String, dynamic>?;
      final subscribeUrl = data?['subscribe_url'] as String?;
      
      return ApiResponse(
        success: subscribeUrl != null,
        data: subscribeUrl,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取订阅链接失败: $e');
    }
  }

  Future<ApiResponse<String?>> resetSubscriptionLink() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/resetSecurity');
      
      final data = result['data'] as String?;
      return ApiResponse(
        success: data != null,
        data: data,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 重置订阅链接失败: $e');
    }
  }

  Future<ApiResponse<void>> toggleTrafficReminder(bool value) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/update',
        {'remind_traffic': value ? 1 : 0},
      );
      
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 切换流量提醒失败: $e');
    }
  }

  Future<ApiResponse<void>> toggleExpireReminder(bool value) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/update',
        {'remind_expire': value ? 1 : 0},
      );
      
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 切换到期提醒失败: $e');
    }
  }
  Future<ApiResponse<void>> updateUserInfo(Map<String, dynamic> data) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/update', data);
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 更新用户信息失败: $e');
    }
  }
}
