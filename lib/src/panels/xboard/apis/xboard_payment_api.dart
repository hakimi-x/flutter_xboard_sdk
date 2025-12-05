import '../../../core/http/http_service.dart';
import '../models/xboard_payment_models.dart';
import '../../../core/models/api_response.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 支付 API 实现
class XBoardPaymentApi {
  final HttpService _httpService;

  XBoardPaymentApi(this._httpService);

  Future<ApiResponse<List<PaymentMethodInfo>>> getPaymentMethods() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/order/getPaymentMethod');
      return ApiResponse.fromJson(
        result,
        (json) => (json as List<dynamic>)
            .map((e) => PaymentMethodInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取支付方式失败: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> submitOrderPayment(PaymentRequest request) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/order/checkout', request.toJson());
      return ApiResponse.fromJson(result, (json) => json as Map<String, dynamic>);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('提交订单支付失败: $e');
    }
  }

  Future<ApiResponse<PaymentStatusResult>> checkPaymentStatus(String tradeNo) async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/order/status?trade_no=$tradeNo');
      return ApiResponse.fromJson(
        result,
        (json) => PaymentStatusResult.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('查询支付状态失败: $e');
    }
  }

  Future<ApiResponse<PaymentStatusResult>> checkOrderStatus(String tradeNo) async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/order/check?trade_no=$tradeNo');
      return ApiResponse.fromJson(result, (json) {
        // API返回的data字段是整数状态码，需要转换为PaymentStatusResult
        if (json is int) {
          switch (json) {
            case 0:
              return PaymentStatusResult.pending('等待中');
            case 2:
              return PaymentStatusResult.canceled('订单已取消');
            case 3:
              return PaymentStatusResult.success('支付成功');
            default:
              return PaymentStatusResult.failed('未知状态: $json');
          }
        } else if (json is Map<String, dynamic>) {
          return PaymentStatusResult.fromJson(json);
        } else {
          throw ApiException('无效的订单状态数据类型: ${json.runtimeType}');
        }
      });
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('检查订单状态失败: $e');
    }
  }

  Future<ApiResponse<void>> cancelPayment(String tradeNo) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/order/cancel', {'trade_no': tradeNo});
      return ApiResponse.fromJson(result, (json) {});
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('取消支付失败: $e');
    }
  }
}
