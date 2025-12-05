import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_payment_models.dart';

/// V2Board 支付 API 实现
class V2BoardPaymentApi {
  final HttpService _httpService;

  V2BoardPaymentApi(this._httpService);

  Future<ApiResponse<List<PaymentMethodInfo>>> getPaymentMethods() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/order/getPaymentMethod');
      
      if (result['data'] != null) {
        final List<dynamic> methodsJson = result['data'] as List;
        final methods = methodsJson
            .map((json) => PaymentMethodInfo.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return ApiResponse(
          success: true,
          data: methods,
        );
      }
      
      return ApiResponse(
        success: false,
        data: [],
        message: result['message'] ?? '获取支付方式失败',
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取支付方式失败: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> submitOrderPayment(PaymentRequest request) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/order/checkout',
        {
          'trade_no': request.tradeNo,
          'method': request.method,
        },
      );
      
      return ApiResponse(
        success: true,
        data: result['data'] as Map<String, dynamic>?,
        message: result['message'],
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 提交支付失败: $e');
    }
  }

  Future<ApiResponse<PaymentStatusResult>> checkPaymentStatus(String tradeNo) async {
    try {
      final result = await _httpService.getRequest(
        '/api/v1/user/order/check?trade_no=$tradeNo',
      );
      
      final status = PaymentStatusResult.fromJson(result);
      return ApiResponse(
        success: true,
        data: status,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 查询支付状态失败: $e');
    }
  }

  Future<ApiResponse<PaymentStatusResult>> checkOrderStatus(String tradeNo) async {
    return checkPaymentStatus(tradeNo);
  }

  Future<ApiResponse<void>> cancelPayment(String tradeNo) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/order/cancel',
        {'trade_no': tradeNo},
      );
      
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 取消支付失败: $e');
    }
  }
}
