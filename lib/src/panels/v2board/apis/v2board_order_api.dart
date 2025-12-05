import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_order_models.dart';

/// V2Board 订单 API 实现
class V2BoardOrderApi {
  final HttpService _httpService;

  V2BoardOrderApi(this._httpService);

  Future<OrderResponse> fetchUserOrders() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/order/fetch');
      return OrderResponse.fromJson(result);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取订单列表失败: $e');
    }
  }

  Future<Order> getOrderDetails(String tradeNo) async {
    try {
      final result = await _httpService.getRequest(
        '/api/v1/user/order/detail?trade_no=$tradeNo',
      );
      
      return Order.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取订单详情失败: $e');
    }
  }

  Future<ApiResponse<dynamic>> cancelOrder(String tradeNo) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/order/cancel',
        {'trade_no': tradeNo},
      );
      
      return ApiResponse.fromJson(result, null);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 取消订单失败: $e');
    }
  }

  Future<ApiResponse<String>> createOrder({
    required int planId,
    required String period,
    String? couponCode,
  }) async {
    try {
      final data = {
        'plan_id': planId,
        'period': period,
        if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
      };
      
      final result = await _httpService.postRequest('/api/v1/user/order/save', data);
      
      final tradeNo = result['data'] as String?;
      return ApiResponse(
        success: tradeNo != null,
        data: tradeNo,
        message: result['message'],
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 创建订单失败: $e');
    }
  }

  Future<ApiResponse<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/order/getPaymentMethod');
      
      if (result['data'] != null) {
        final List<dynamic> methodsJson = result['data'] as List;
        final methods = methodsJson
            .map((json) => PaymentMethod.fromJson(json as Map<String, dynamic>))
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

  Future<CheckoutResult> submitPayment({
    required String tradeNo,
    required String method,
  }) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/order/checkout',
        {
          'trade_no': tradeNo,
          'method': method,
        },
      );
      
      return CheckoutResult.fromJson(result);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 提交支付失败: $e');
    }
  }
}
