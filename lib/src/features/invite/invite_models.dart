
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_models.freezed.dart';
part 'invite_models.g.dart';

DateTime _fromUnixTimestamp(int timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
int _toUnixTimestamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

@freezed
class InviteCode with _$InviteCode {
  const factory InviteCode({
    @JsonKey(name: 'user_id') required int userId,
    required String code,
    required int pv,
    required bool status,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
  }) = _InviteCode;

  const InviteCode._();

  factory InviteCode.fromJson(Map<String, dynamic> json) => _$InviteCodeFromJson(json);

  bool get isActive => status;
}

@freezed
class InviteInfo with _$InviteInfo {
  @JsonSerializable(explicitToJson: true)
  const factory InviteInfo({
    required List<InviteCode> codes,
    required List<int> stat,
  }) = _InviteInfo;

  const InviteInfo._();

  factory InviteInfo.fromJson(Map<String, dynamic> json) => _$InviteInfoFromJson(json);

  // stat 数组结构（基于旧版本定义）:
  // stat[0] - 总邀请数 (totalInvites)
  // stat[1] - 总佣金 (totalCommission)
  // stat[2] - 待处理佣金 (pendingCommission)
  // stat[3] - 返利比例 (commissionRate)
  // stat[4] - 可用佣金 (availableCommission)
  int get totalInvites => stat.isNotEmpty ? stat[0] : 0;
  int get totalCommission => stat.length > 1 ? stat[1] : 0;
  int get pendingCommission => stat.length > 2 ? stat[2] : 0;
  int get commissionRate => stat.length > 3 ? stat[3] : 0;
  int get availableCommission => stat.length > 4 ? stat[4] : 0;
}

@freezed
class CommissionDetail with _$CommissionDetail {
  const factory CommissionDetail({
    required int id,
    @JsonKey(name: 'order_amount') required int orderAmount,
    @JsonKey(name: 'trade_no') required String tradeNo,
    @JsonKey(name: 'get_amount') required int getAmount,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
  }) = _CommissionDetail;

  const CommissionDetail._();

  factory CommissionDetail.fromJson(Map<String, dynamic> json) => _$CommissionDetailFromJson(json);

  double get orderAmountInYuan => orderAmount / 100.0;
  double get getAmountInYuan => getAmount / 100.0;
}
