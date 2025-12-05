import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';

/// V2Board 注册 API 实现
class V2BoardRegisterApi {
  final HttpService _httpService;

  V2BoardRegisterApi(this._httpService);

  Future<ApiResponse> register(
    String email,
    String password,
    String? inviteCode,
    String? emailCode,
  ) async {
    try {
      // 只有非空值才添加字段
      final data = <String, dynamic>{
        'email': email,
        'password': password,
      };
      
      if (inviteCode != null && inviteCode.isNotEmpty) {
        data['invite_code'] = inviteCode;
      }
      
      if (emailCode != null && emailCode.isNotEmpty) {
        data['email_code'] = emailCode;
      }
      
      final result = await _httpService.postRequest(
        '/api/v1/passport/auth/register',
        data,
      );
      
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 注册失败: $e');
    }
  }
}
