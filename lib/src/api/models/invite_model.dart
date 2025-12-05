// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_model.freezed.dart';
part 'invite_model.g.dart';

DateTime _fromUnixTimestamp(int timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
int _toUnixTimestamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

@freezed
class InviteCodeModel with _$InviteCodeModel {
  const factory InviteCodeModel({
    @JsonKey(name: 'user_id') required int userId,
    required String code,
    required int pv,
    required bool status,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime updatedAt,
  }) = _InviteCodeModel;

  const InviteCodeModel._();

  factory InviteCodeModel.fromJson(Map<String, dynamic> json) => _$InviteCodeModelFromJson(json);

  bool get isActive => status;
}

@freezed
class InviteInfoModel with _$InviteInfoModel {
  @JsonSerializable(explicitToJson: true)
  const factory InviteInfoModel({
    required List<InviteCodeModel> codes,
    required List<int> stat,
  }) = _InviteInfoModel;

  const InviteInfoModel._();

  factory InviteInfoModel.fromJson(Map<String, dynamic> json) => _$InviteInfoModelFromJson(json);

  int get totalInvites => stat.isNotEmpty ? stat[0] : 0;
  int get totalCommission => stat.length > 1 ? stat[1] : 0;
  int get pendingCommission => stat.length > 2 ? stat[2] : 0;
  
  /// 佣金比例（原始整数值，如 50 表示 50%）
  int get commissionRate => stat.length > 3 ? stat[3] : 0;
  
  /// 佣金比例的百分比表示（0-100），用于UI显示
  double get commissionRatePercent => commissionRate.toDouble();
  
  int get availableCommission => stat.length > 4 ? stat[4] : 0;
}

@freezed
class CommissionDetailModel with _$CommissionDetailModel {
  const factory CommissionDetailModel({
    required int id,
    @JsonKey(name: 'order_amount') required int orderAmount,
    @JsonKey(name: 'trade_no') required String tradeNo,
    @JsonKey(name: 'get_amount') required int getAmount,
    @JsonKey(name: 'created_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp) required DateTime createdAt,
  }) = _CommissionDetailModel;

  const CommissionDetailModel._();

  factory CommissionDetailModel.fromJson(Map<String, dynamic> json) => _$CommissionDetailModelFromJson(json);

  double get orderAmountInYuan => orderAmount / 100.0;
  double get getAmountInYuan => getAmount / 100.0;
}
