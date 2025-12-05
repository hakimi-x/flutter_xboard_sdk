// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// 订单数据模型
@freezed
class Order with _$Order {
  const Order._();
  
  const factory Order({
    int? id,
    @JsonKey(name: 'trade_no') String? tradeNo,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'plan_id') int? planId,
    @JsonKey(name: 'coupon_id') int? couponId,
    @JsonKey(name: 'payment_id') int? paymentId,
    int? type,
    String? period,
    @JsonKey(name: 'total_amount') int? totalAmount,
    int? status,
    @JsonKey(name: 'commission_status') int? commissionStatus,
    @JsonKey(name: 'commission_balance') int? commissionBalance,
    @JsonKey(name: 'actual_commission_balance') int? actualCommissionBalance,
    @JsonKey(name: 'surplus_amount') int? surplusAmount,
    @JsonKey(name: 'refund_amount') int? refundAmount,
    @JsonKey(name: 'balance_amount') int? balanceAmount,
    @JsonKey(name: 'surplus_order_ids') List<dynamic>? surplusOrderIds,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
    
    /// 套餐信息（关联）
    Map<String, dynamic>? plan,
  }) = _Order;
  
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  
  /// 订单状态：0=待支付，1=开通中，2=已取消，3=已完成，4=已折抵
  bool get isPending => status == 0;
  bool get isProcessing => status == 1;
  bool get isCancelled => status == 2;
  bool get isCompleted => status == 3;
  bool get isDiscounted => status == 4;
}
