// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'xboard_user_info_models.dart';

part 'xboard_balance_models.freezed.dart';
part 'xboard_balance_models.g.dart';

bool _intToBool(int value) => value == 0; // 0表示开启，1表示关闭
int _boolToInt(bool value) => value ? 0 : 1;

@freezed
class SystemConfig with _$SystemConfig {
  const factory SystemConfig({
    @JsonKey(name: 'withdraw_methods') required List<String> withdrawMethods,
    @JsonKey(name: 'withdraw_close', fromJson: _intToBool, toJson: _boolToInt)
    required bool withdrawEnabled,
    required String currency,
    @JsonKey(name: 'currency_symbol') required String currencySymbol,
  }) = _SystemConfig;

  factory SystemConfig.fromJson(Map<String, dynamic> json) => _$SystemConfigFromJson(json);
}

@freezed
class TransferResult with _$TransferResult {
  const factory TransferResult({
    required bool success,
    String? message,
    UserInfo? updatedUserInfo, // Reference UserInfo
  }) = _TransferResult;

  factory TransferResult.fromJson(Map<String, dynamic> json) => _$TransferResultFromJson(json);
}

@freezed
class WithdrawResult with _$WithdrawResult {
  const factory WithdrawResult({
    required bool success,
    String? message,
    String? withdrawId,
  }) = _WithdrawResult;

  factory WithdrawResult.fromJson(Map<String, dynamic> json) => _$WithdrawResultFromJson(json);
}

@freezed
class CommissionHistoryItem with _$CommissionHistoryItem {
  const factory CommissionHistoryItem({
    required int id,
    @JsonKey(name: 'order_amount') required int orderAmount,
    @JsonKey(name: 'trade_no') required String tradeNo,
    @JsonKey(name: 'get_amount') required int getAmount,
    @JsonKey(name: 'created_at') required int createdAt,
  }) = _CommissionHistoryItem;

  factory CommissionHistoryItem.fromJson(Map<String, dynamic> json) => _$CommissionHistoryItemFromJson(json);
}