import '../../../core/http/http_service.dart';
import '../models/xboard_balance_models.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 余额 API 实现
class XBoardBalanceApi {
  final HttpService _httpService;

  XBoardBalanceApi(this._httpService);

  Future<TransferResult> transferCommission(int amount) async {
    try {
      final response = await _httpService.postRequest(
        '/api/v1/user/transfer',
        {'transfer_amount': amount},
      );
      
      // XBoard 返回 {data: true} 表示成功
      return TransferResult(
        success: response['data'] == true,
        message: response['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('划转佣金失败: $e');
    }
  }

  Future<WithdrawResult> withdrawFunds(String withdrawMethod, String withdrawAccount) async {
    try {
      final response = await _httpService.postRequest(
        '/api/v1/user/ticket/withdraw',
        {
          'withdraw_method': withdrawMethod,
          'withdraw_account': withdrawAccount,
        },
      );
      
      // XBoard 返回 {data: true} 表示成功
      return WithdrawResult(
        success: response['data'] == true,
        message: response['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('提现申请失败: $e');
    }
  }
}
