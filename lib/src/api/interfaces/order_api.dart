import '../models/order_model.dart';
import '../models/payment_model.dart';
import '../models/coupon_model.dart';

abstract class OrderApi {
  Future<List<OrderModel>> getOrders({int page = 1, int pageSize = 10});
  Future<String> createOrder(int planId, String period, {String? couponCode});
  Future<PaymentResultModel> checkoutOrder(String tradeNo, String method);
  Future<OrderModel?> getOrder(String tradeNo);
  Future<bool> cancelOrder(String tradeNo);
  Future<List<PaymentMethodModel>> getPaymentMethods(String tradeNo);
  Future<CouponModel?> checkCoupon(String code, int planId);
}
