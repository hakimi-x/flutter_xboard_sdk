// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

/// 用户信息数据模型
@freezed
class UserInfo with _$UserInfo {
  const UserInfo._();
  
  const factory UserInfo({
    required String email,
    @JsonKey(name: 'transfer_enable') int? transferEnable,
    @JsonKey(name: 'device_limit') int? deviceLimit,
    @JsonKey(name: 'last_login_at') int? lastLoginAt,
    @JsonKey(name: 'created_at') int? createdAt,
    int? banned,
    @JsonKey(name: 'auto_renewal') int? autoRenewal,
    @JsonKey(name: 'remind_expire') int? remindExpire,
    @JsonKey(name: 'remind_traffic') int? remindTraffic,
    @JsonKey(name: 'expired_at') int? expiredAt,
    int? balance,
    @JsonKey(name: 'commission_balance') int? commissionBalance,
    @JsonKey(name: 'plan_id') int? planId,
    int? discount,
    @JsonKey(name: 'commission_rate') int? commissionRate,
    @JsonKey(name: 'telegram_id') int? telegramId,
    String? uuid,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    
    /// 已上传流量 (bytes)
    int? u,
    
    /// 已下载流量 (bytes)
    int? d,
  }) = _UserInfo;
  
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  
  /// 是否已过期
  bool get isExpired {
    if (expiredAt == null) return false;
    return expiredAt! * 1000 < DateTime.now().millisecondsSinceEpoch;
  }
  
  /// 是否被封禁
  bool get isBanned => banned == 1;
  
  /// 已使用流量 (bytes)
  int get usedTraffic => (u ?? 0) + (d ?? 0);
  
  /// 剩余流量 (bytes)
  int get remainingTraffic {
    final total = transferEnable ?? 0;
    final used = usedTraffic;
    return (total - used).clamp(0, total);
  }
  
  /// 流量使用百分比 (0-100)
  double get trafficUsagePercent {
    final total = transferEnable ?? 0;
    if (total == 0) return 0;
    return (usedTraffic / total * 100).clamp(0, 100);
  }
}
