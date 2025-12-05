import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../xboard/models/xboard_send_email_code_models.dart';

/// V2Board 发送邮箱验证码 API 实现
class V2BoardSendEmailCodeApi {
  final HttpService _httpService;

  V2BoardSendEmailCodeApi(this._httpService);

  Future<SendEmailCodeResult> sendEmailCode(String email) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/passport/comm/sendEmailVerify',
        {'email': email},
      );
      
      return SendEmailCodeResult.fromJson(result);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 发送邮箱验证码失败: $e');
    }
  }
}
