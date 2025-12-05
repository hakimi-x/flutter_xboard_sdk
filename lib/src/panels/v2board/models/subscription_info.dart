// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_info.freezed.dart';
part 'subscription_info.g.dart';

/// 订阅信息数据模型
@freezed
class SubscriptionInfo with _$SubscriptionInfo {
  const factory SubscriptionInfo({
    @JsonKey(name: 'subscribe_url') String? subscribeUrl,
    String? token,
  }) = _SubscriptionInfo;
  
  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) => 
      _$SubscriptionInfoFromJson(json);
}
