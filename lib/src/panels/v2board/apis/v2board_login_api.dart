import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../xboard/models/xboard_login_models.dart'; // 复用 XBoard 的 LoginResult

/// V2Board 登录 API 实现
class V2BoardLoginApi {
  final HttpService _httpService;

  V2BoardLoginApi(this._httpService);

  Future<LoginResult> login(String email, String password) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/passport/auth/login',
        {
          'email': email,
          'password': password,
        },
      );
      
      // V2Board API 返回格式：{ "data": { "auth_data": "token", ...} }
      final data = result['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ApiException('登录响应数据为空');
      }
      
      // 返回统一的 LoginResult
      return LoginResult(
        token: data['token'] as String?,
        authData: data['auth_data'] as String?,
        user: data['user'] as Map<String, dynamic>?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 登录失败: $e');
    }
  }
}
