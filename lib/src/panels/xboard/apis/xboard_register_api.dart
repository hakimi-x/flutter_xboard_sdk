import '../../../core/http/http_service.dart';
import '../../../core/models/api_response.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 注册 API 实现
class XBoardRegisterApi {
  final HttpService _httpService;

  XBoardRegisterApi(this._httpService);

  Future<ApiResponse> register(
    String email,
    String password,
    String? inviteCode,
    String? emailCode,
  ) async {
    try {
      // 构建请求数据：只有非空值才传递字段
      final data = <String, dynamic>{
        "email": email,
        "password": password,
      };
      
      // 邀请码：只有非空时才添加字段
      if (inviteCode != null && inviteCode.isNotEmpty) {
        data["invite_code"] = inviteCode;
      }
      
      // 邮箱验证码：只有非空时才添加字段
      if (emailCode != null && emailCode.isNotEmpty) {
        data["email_code"] = emailCode;
      }
      
      final response = await _httpService.postRequest(
        "/api/v1/passport/auth/register",
        data,
      );
      return ApiResponse.fromJson(response, (json) => json);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('Register failed: $e');
    }
  }
}
