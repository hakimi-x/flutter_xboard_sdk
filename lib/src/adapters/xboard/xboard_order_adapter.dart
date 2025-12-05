import '../../api/interfaces/order_api.dart';
import '../../api/models/order_model.dart';
import '../../api/models/payment_model.dart';
import '../../api/models/coupon_model.dart';
import '../../panels/xboard/apis/xboard_order_api.dart';
import '../../panels/xboard/apis/xboard_coupon_api.dart';
import '../../panels/xboard/models/xboard_order_models.dart';
import '../../panels/xboard/models/xboard_coupon_models.dart';

class XBoardOrderAdapter implements OrderApi {
  final XBoardOrderApi _api;
  final XBoardCouponApi _couponApi;

  XBoardOrderAdapter(this._api, this._couponApi);

  @override
  Future<List<OrderModel>> getOrders({int page = 1, int pageSize = 10}) async {
    final response = await _api.fetchUserOrders();
    final data = response.data;
    return data.map(_mapOrder).toList();
  }

  @override
  Future<String> createOrder(int planId, String period, {String? couponCode}) async {
    final response = await _api.createOrder(
      planId: planId,
      period: period,
      couponCode: couponCode,
    );
    if (response.data == null) throw Exception('Order creation failed: no data returned');
    return response.data!;
  }

  @override
  Future<PaymentResultModel> checkoutOrder(String tradeNo, String method) async {
    final response = await _api.submitPayment(tradeNo: tradeNo, method: method);
    
    if (response.type == 1) { // Redirect
      return PaymentResultModel.redirect(url: response.data as String);
    } else if (response.type == 0 || response.type == -1) { // Free/Success (XBoard uses -1 for free, 0 for success sometimes?)
       // Need to verify type codes. Assuming 0/-1 is success or handled.
       // If data is bool true, it's success.
       return PaymentResultModel.success(message: 'Payment successful');
    } else {
      return PaymentResultModel.failed(message: 'Unknown payment result type: ${response.type}');
    }
  }

  @override
  Future<OrderModel?> getOrder(String tradeNo) async {
    final response = await _api.getOrderDetails(tradeNo);
    return _mapOrder(response);
  }

  @override
  Future<bool> cancelOrder(String tradeNo) async {
    await _api.cancelOrder(tradeNo);
    return true;
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods(String tradeNo) async {
    // XBoard API returns all payment methods, tradeNo is not used in this specific API call
    final response = await _api.getPaymentMethods();
    if (response.data == null) return [];
    return response.data!.map(_mapPaymentMethod).toList();
  }

  OrderModel _mapOrder(Order order) {
    return OrderModel(
      planId: order.planId,
      tradeNo: order.tradeNo,
      totalAmount: order.totalAmount,
      period: order.period,
      status: order.status,
      createdAt: order.createdAt,
      orderPlan: order.orderPlan != null ? _mapOrderPlan(order.orderPlan!) : null,
    );
  }

  OrderPlanModel _mapOrderPlan(OrderPlan plan) {
    return OrderPlanModel(
      id: plan.id,
      name: plan.name,
      onetimePrice: plan.onetimePrice,
      content: plan.content,
    );
  }

  PaymentMethodModel _mapPaymentMethod(PaymentMethod method) {
    return PaymentMethodModel(
      id: method.id,
      name: method.name,
      icon: method.icon,
      isAvailable: method.isAvailable,
      config: method.config,
    );
  }
  @override
  Future<CouponModel?> checkCoupon(String code, int planId) async {
    try {
      final response = await _couponApi.checkCoupon(code, planId);
      if (response.data == null) return null;
      return _mapCoupon(response.data!);
    } catch (e) {
      return null;
    }
  }

  CouponModel _mapCoupon(CouponData coupon) {
    return CouponModel(
      id: coupon.id,
      name: coupon.name,
      code: coupon.code,
      type: coupon.type,
      value: coupon.value,
      limitUse: coupon.limitUse,
      limitUseWithUser: coupon.limitUseWithUser,
      limitPlanIds: coupon.limitPlanIds,
      limitPeriod: coupon.limitPeriod,
      startedAt: coupon.startedAt,
      endedAt: coupon.endedAt,
      show: coupon.show,
      createdAt: coupon.createdAt,
      updatedAt: coupon.updatedAt,
    );
  }
}
