import '../../../core/http/http_service.dart';
import '../models/xboard_login_models.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 登录 API 实现
class XBoardLoginApi {
  final HttpService _httpService;

  XBoardLoginApi(this._httpService);

  Future<LoginResult> login(String email, String password) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/passport/auth/login',
        {
          'email': email,
          'password': password,
        },
      );
      return LoginResult.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('登录失败: $e');
    }
  }
}
