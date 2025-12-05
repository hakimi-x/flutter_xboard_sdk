import '../../../core/http/http_service.dart';
import '../models/xboard_send_email_code_models.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 邮箱验证码 API 实现
class XBoardSendEmailCodeApi {
  final HttpService _httpService;

  XBoardSendEmailCodeApi(this._httpService);

  Future<SendEmailCodeResult> sendEmailCode(String email) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/passport/comm/sendEmailVerify',
        {'email': email},
      );
      // API 返回的 data 直接是 bool 值，不是对象
      final success = result['data'] as bool? ?? false;
      return SendEmailCodeResult(
        success: success,
        message: result['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('发送邮箱验证码失败: $e');
    }
  }
}
