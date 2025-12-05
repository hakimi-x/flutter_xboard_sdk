// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

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
  return false;
}

int? _boolToInt(bool? value) => value == null ? null : (value ? 1 : 0);

@freezed
class CouponModel with _$CouponModel {
  const factory CouponModel({
    int? id,
    String? name,
    String? code,
    int? type, // 1: 金额折扣, 2: 百分比折扣
    int? value,
    @JsonKey(name: 'limit_use') int? limitUse,
    @JsonKey(name: 'limit_use_with_user') int? limitUseWithUser,
    @JsonKey(name: 'limit_plan_ids') List<String>? limitPlanIds,
    dynamic limitPeriod,
    @JsonKey(name: 'started_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? startedAt,
    @JsonKey(name: 'ended_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? endedAt,
    @JsonKey(fromJson: _intToBool, toJson: _boolToInt)
    bool? show,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? updatedAt,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) => _$CouponModelFromJson(json);
}
