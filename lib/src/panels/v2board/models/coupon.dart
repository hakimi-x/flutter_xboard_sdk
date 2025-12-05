// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

/// 优惠券数据模型
@freezed
class Coupon with _$Coupon {
  const Coupon._();
  
  const factory Coupon({
    int? id,
    String? code,
    String? name,
    int? type,
    int? value,
    @JsonKey(name: 'limit_use') int? limitUse,
    @JsonKey(name: 'limit_use_with_user') int? limitUseWithUser,
    @JsonKey(name: 'limit_plan_ids') List<int>? limitPlanIds,
    @JsonKey(name: 'started_at') int? startedAt,
    @JsonKey(name: 'ended_at') int? endedAt,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _Coupon;
  
  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  
  /// 优惠券类型：1=金额，2=百分比
  bool get isAmountType => type == 1;
  bool get isPercentType => type == 2;
  
  /// 计算折扣金额
  int calculateDiscount(int originalAmount) {
    if (type == 1) {
      // 固定金额
      return value ?? 0;
    } else if (type == 2) {
      // 百分比
      return (originalAmount * (value ?? 0) / 100).round();
    }
    return 0;
  }
}
