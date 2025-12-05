// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'xboard_coupon_models.freezed.dart';
part 'xboard_coupon_models.g.dart';

// Helper functions for DateTime to Unix timestamp conversion
int? _toUnixTimestamp(DateTime? date) => date?.millisecondsSinceEpoch == null ? null : date!.millisecondsSinceEpoch ~/ 1000;
DateTime? _fromUnixTimestamp(int? timestamp) =>
    timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000) : null;

// Helper functions for int/bool conversion
bool _intToBool(dynamic value) {
  if (value is int) {
    return value == 1;
  } else if (value is bool) {
    return value;
  }
  return false; // Default or handle error
}

int? _boolToInt(bool? value) => value == null ? null : (value ? 1 : 0);

@freezed
class CouponData with _$CouponData {
  const factory CouponData({
    int? id, // Changed from String? to int?
    String? name,
    String? code,
    int? type, // 1: 金额折扣, 2: 百分比折扣
    int? value, // Changed from double? to int?
    @JsonKey(name: 'limit_use') int? limitUse, // 使用限制次数
    @JsonKey(name: 'limit_use_with_user') int? limitUseWithUser, // 单用户使用限制
    @JsonKey(name: 'limit_plan_ids') List<String>? limitPlanIds, // 限制的套餐ID列表
    dynamic limitPeriod, // Added limit_period
    @JsonKey(name: 'started_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? startedAt, // 开始时间
    @JsonKey(name: 'ended_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? endedAt, // 结束时间
    @JsonKey(fromJson: _intToBool, toJson: _boolToInt)
    bool? show, // 是否显示
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? updatedAt,
  }) = _CouponData;

  factory CouponData.fromJson(Map<String, dynamic> json) => _$CouponDataFromJson(json);
}

@freezed
class CouponResponse with _$CouponResponse {
  const factory CouponResponse({
    required bool success,
    String? message,
    CouponData? data,
    Map<String, dynamic>? errors,
  }) = _CouponResponse;

  factory CouponResponse.fromJson(Map<String, dynamic> json) => _$CouponResponseFromJson(json);
}
