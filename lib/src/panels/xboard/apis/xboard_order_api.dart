import '../../../core/http/http_service.dart';
import '../models/xboard_order_models.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';

/// XBoard 订单 API 实现
class XBoardOrderApi {
  final HttpService _httpService;

  XBoardOrderApi(this._httpService);

  Future<OrderResponse> fetchUserOrders() async {
    try {
      final result = await _httpService.getRequest("/api/v1/user/order/fetch");
      return OrderResponse.fromJson(result);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取订单列表失败: $e');
    }
  }

  Future<Order> getOrderDetails(String tradeNo) async {
    try {
      final result = await _httpService.getRequest(
        "/api/v1/user/order/detail?trade_no=$tradeNo",
      );
      if (result['data'] != null) {
        return Order.fromJson(result['data'] as Map<String, dynamic>);
      }
      throw ApiException('获取订单详情失败: ${result['message'] ?? 'Unknown error'}');
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取订单详情失败: $e');
    }
  }

  Future<ApiResponse<dynamic>> cancelOrder(String tradeNo) async {
    try {
      final result = await _httpService.postRequest(
        "/api/v1/user/order/cancel",
        {"trade_no": tradeNo},
      );
      return ApiResponse.fromJson(result, (json) => json);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('取消订单失败: $e');
    }
  }

  Future<ApiResponse<String>> createOrder({
    required int planId,
    required String period,
    String? couponCode,
  }) async {
    try {
      final request = CreateOrderRequest(
        planId: planId,
        period: period,
        couponCode: couponCode,
      );

      final result = await _httpService.postRequest(
        "/api/v1/user/order/save",
        request.toJson(),
      );
      return ApiResponse.fromJson(result, (data) => data.toString());
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('创建订单失败: $e');
    }
  }

  Future<ApiResponse<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final result = await _httpService.getRequest("/api/v1/user/order/getPaymentMethod");
      return ApiResponse.fromJson(
        result,
        (json) => (json as List<dynamic>)
            .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取支付方式失败: $e');
    }
  }

  Future<CheckoutResult> submitPayment({
    required String tradeNo,
    required String method,
  }) async {
    try {
      final request = SubmitOrderRequest(
        tradeNo: tradeNo,
        method: method,
      );

      final result = await _httpService.postRequest(
        "/api/v1/user/order/checkout",
        request.toJson(),
      );
      
      // XBoard 返回: {type: -1, data: true} (免费) 或 {type: 0/1, data: "url"} (付费)
      final dynamic resultData = result['data'];
      
      // 兼容两种返回格式
      if (resultData is Map<String, dynamic>) {
        // 格式1: {data: {type: 0, data: "url"}}
        return CheckoutResult(
          type: resultData['type'] as int? ?? 0,
          data: resultData['data'], // 保持动态类型
        );
      } else {
        // 格式2: {type: -1/0/1, data: bool/String}
        final typeValue = result['type'] as int? ?? 0;
        return CheckoutResult(
          type: typeValue,
          data: resultData, // 保持动态类型，可以是 bool 或 String
        );
      }
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('提交支付失败: $e');
    }
  }
}
