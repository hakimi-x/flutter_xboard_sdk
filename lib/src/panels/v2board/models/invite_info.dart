// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_info.freezed.dart';
part 'invite_info.g.dart';

/// 邀请信息数据模型
@freezed
class InviteInfo with _$InviteInfo {
  const factory InviteInfo({
    List<InviteCode>? codes,
    InviteStat? stat,  // 单个对象，不是数组
  }) = _InviteInfo;

  factory InviteInfo.fromJson(Map<String, dynamic> json) =>
      _$InviteInfoFromJson(json);
}

/// 邀请码数据模型
@freezed
class InviteCode with _$InviteCode {
  const InviteCode._();
  
  const factory InviteCode({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    String? code,
    int? status,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _InviteCode;
  
  factory InviteCode.fromJson(Map<String, dynamic> json) => 
      _$InviteCodeFromJson(json);
  
  /// 是否可用
  bool get isAvailable => status == 0;
}

/// 邀请统计数据模型
@freezed
class InviteStat with _$InviteStat {
  const factory InviteStat({
    @JsonKey(name: 'register_count') int? registerCount,
    @JsonKey(name: 'commission_rate') int? commissionRate,
    @JsonKey(name: 'commission_balance') int? commissionBalance,
    @JsonKey(name: 'commission_pending_balance') int? commissionPendingBalance,
  }) = _InviteStat;
  
  factory InviteStat.fromJson(Map<String, dynamic> json) => 
      _$InviteStatFromJson(json);
}
