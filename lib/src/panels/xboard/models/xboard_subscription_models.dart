// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'xboard_subscription_models.freezed.dart';
part 'xboard_subscription_models.g.dart';

// Helper functions for DateTime conversion
DateTime? _fromUnixTimestamp(int? timestamp) =>
    timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000) : null;
int? _toUnixTimestamp(DateTime? dateTime) =>
    dateTime != null ? dateTime.millisecondsSinceEpoch ~/ 1000 : null;

/// 计划详情模型
@freezed
class PlanDetails with _$PlanDetails {
  const factory PlanDetails({
    String? name,
    int? id,
    double? price,
    String? description,
    @JsonKey(name: 'transfer_enable') int? transferEnable,
    @JsonKey(name: 'speed_limit') int? speedLimit,
  }) = _PlanDetails;

  factory PlanDetails.fromJson(Map<String, dynamic> json) => _$PlanDetailsFromJson(json);
}

/// 订阅信息模型
@freezed
class SubscriptionInfo with _$SubscriptionInfo {
  const factory SubscriptionInfo({
    @JsonKey(name: 'subscribe_url') String? subscribeUrl,
    PlanDetails? plan,
    String? token,
    @JsonKey(name: 'expired_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? expiredAt,
    int? u, // 上传流量
    int? d, // 下载流量
    @JsonKey(name: 'transfer_enable') int? transferEnable, // 总流量限制
    @JsonKey(name: 'plan_id') int? planId, // 套餐ID
    String? email, // 邮箱
    String? uuid, // 用户UUID
    @JsonKey(name: 'device_limit') int? deviceLimit, // 设备限制
    @JsonKey(name: 'speed_limit') int? speedLimit, // 速度限制
    @JsonKey(name: 'next_reset_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? nextResetAt, // 下次重置时间
  }) = _SubscriptionInfo;

  const SubscriptionInfo._(); // Add this line

  String? get planName => plan?.name; // Derived property

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) => _$SubscriptionInfoFromJson(json);
}

/// 订阅统计信息模型
class SubscriptionStats {
  final int? todayUsed;
  final int? monthUsed;
  final int? totalUsed;
  final int? totalRemaining;
  final DateTime? expiredAt;

  SubscriptionStats({
    this.todayUsed,
    this.monthUsed,
    this.totalUsed,
    this.totalRemaining,
    this.expiredAt,
  });

  factory SubscriptionStats.fromJson(dynamic json) {
    if (json is List) {
      // 如果API返回的是List，我们假设它是一个无效或默认的响应，返回一个默认实例
      return SubscriptionStats(
        todayUsed: 0,
        monthUsed: 0,
        totalUsed: 0,
        totalRemaining: 0,
        expiredAt: null,
      );
    } else if (json is Map<String, dynamic>) {
      // 否则，按正常方式解析Map
      return SubscriptionStats(
        todayUsed: json['today_used'] as int?,
        monthUsed: json['month_used'] as int?,
        totalUsed: json['total_used'] as int?,
        totalRemaining: json['total_remaining'] as int?,
        expiredAt: _fromUnixTimestamp(json['expired_at'] as int?),
      );
    }
    throw FormatException('Invalid JSON format for SubscriptionStats');
  }

  Map<String, dynamic> toJson() {
    return {
      'today_used': todayUsed,
      'month_used': monthUsed,
      'total_used': totalUsed,
      'total_remaining': totalRemaining,
      'expired_at': _toUnixTimestamp(expiredAt),
    };
  }
}

/// 订阅响应模型
@freezed
class SubscriptionResponse with _$SubscriptionResponse {
  const factory SubscriptionResponse({
    required bool success,
    String? message,
    SubscriptionInfo? data,
  }) = _SubscriptionResponse;

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) => _$SubscriptionResponseFromJson(json);
}