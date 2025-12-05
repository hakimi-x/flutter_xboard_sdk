// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

DateTime? _fromUnixTimestamp(int? timestamp) =>
    timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000) : null;
int? _toUnixTimestamp(DateTime? dateTime) =>
    dateTime != null ? dateTime.millisecondsSinceEpoch ~/ 1000 : null;

@freezed
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    @JsonKey(name: 'subscribe_url') String? subscribeUrl,
    SubscriptionPlanModel? plan,
    String? token,
    @JsonKey(name: 'expired_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? expiredAt,
    int? u,
    int? d,
    @JsonKey(name: 'transfer_enable') int? transferEnable,
    @JsonKey(name: 'plan_id') int? planId,
    String? email,
    String? uuid,
    @JsonKey(name: 'device_limit') int? deviceLimit,
    @JsonKey(name: 'speed_limit') int? speedLimit,
    @JsonKey(name: 'next_reset_at', fromJson: _fromUnixTimestamp, toJson: _toUnixTimestamp)
    DateTime? nextResetAt,
  }) = _SubscriptionModel;

  const SubscriptionModel._();

  String? get planName => plan?.name;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => _$SubscriptionModelFromJson(json);
}

@freezed
class SubscriptionPlanModel with _$SubscriptionPlanModel {
  const factory SubscriptionPlanModel({
    String? name,
    int? id,
    double? price,
    String? description,
    @JsonKey(name: 'transfer_enable') int? transferEnable,
    @JsonKey(name: 'speed_limit') int? speedLimit,
  }) = _SubscriptionPlanModel;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanModelFromJson(json);
}
