import '../../../core/http/http_service.dart';
import '../../../core/models/api_response.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 重置密码 API 实现
class XBoardResetPasswordApi {
  final HttpService _httpService;

  XBoardResetPasswordApi(this._httpService);

  Future<ApiResponse> resetPassword({
    required String email,
    required String password,
    required String emailCode,
  }) async {
    try {
      final response = await _httpService.postRequest(
        '/api/v1/passport/auth/forget',
        {
          'email': email,
          'password': password,
          'email_code': emailCode,
        },
      );
      return ApiResponse.fromJson(response, (json) => json);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('重置密码失败: $e');
    }
  }
}
