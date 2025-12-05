// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method.freezed.dart';
part 'payment_method.g.dart';

/// 支付方式数据模型
@freezed
class PaymentMethod with _$PaymentMethod {
  const PaymentMethod._();
  
  const factory PaymentMethod({
    required int id,
    String? name,
    String? payment,
    String? icon,
    int? show,
    String? config,
    @JsonKey(name: 'handling_fee_fixed') int? handlingFeeFixed,
    @JsonKey(name: 'handling_fee_percent') double? handlingFeePercent,
  }) = _PaymentMethod;
  
  factory PaymentMethod.fromJson(Map<String, dynamic> json) => 
      _$PaymentMethodFromJson(json);
  
  /// 是否显示
  bool get isVisible => show == 1;
  
  /// 计算手续费
  int calculateFee(int amount) {
    int fee = handlingFeeFixed ?? 0;
    if (handlingFeePercent != null) {
      fee += (amount * handlingFeePercent! / 100).round();
    }
    return fee;
  }
}
