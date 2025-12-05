import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';

/// V2Board 重置密码 API 实现
class V2BoardResetPasswordApi {
  final HttpService _httpService;

  V2BoardResetPasswordApi(this._httpService);

  Future<ApiResponse> resetPassword({
    required String email,
    required String password,
    required String emailCode,
  }) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/passport/auth/forget',
        {
          'email': email,
          'password': password,
          'email_code': emailCode,
        },
      );
      
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 重置密码失败: $e');
    }
  }
}
