// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan.freezed.dart';
part 'plan.g.dart';

/// 套餐计划数据模型
@freezed
class Plan with _$Plan {
  const Plan._();
  
  const factory Plan({
    required int id,
    @JsonKey(name: 'group_id') int? groupId,
    @JsonKey(name: 'transfer_enable') int? transferEnable,
    String? name,
    int? show,
    int? sort,
    int? renew,
    String? content,
    @JsonKey(name: 'month_price') int? monthPrice,
    @JsonKey(name: 'quarter_price') int? quarterPrice,
    @JsonKey(name: 'half_year_price') int? halfYearPrice,
    @JsonKey(name: 'year_price') int? yearPrice,
    @JsonKey(name: 'two_year_price') int? twoYearPrice,
    @JsonKey(name: 'three_year_price') int? threeYearPrice,
    @JsonKey(name: 'onetime_price') int? onetimePrice,
    @JsonKey(name: 'reset_price') int? resetPrice,
    @JsonKey(name: 'reset_traffic_method') int? resetTrafficMethod,
    @JsonKey(name: 'capacity_limit') int? capacityLimit,
    @JsonKey(name: 'speed_limit') int? speedLimit,
    @JsonKey(name: 'device_limit') int? deviceLimit,
  }) = _Plan;
  
  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  
  /// 获取指定周期的价格
  int? getPriceForPeriod(String period) {
    switch (period) {
      case 'month_price':
        return monthPrice;
      case 'quarter_price':
        return quarterPrice;
      case 'half_year_price':
        return halfYearPrice;
      case 'year_price':
        return yearPrice;
      case 'two_year_price':
        return twoYearPrice;
      case 'three_year_price':
        return threeYearPrice;
      case 'onetime_price':
        return onetimePrice;
      case 'reset_price':
        return resetPrice;
      default:
        return null;
    }
  }
  
  /// 是否显示
  bool get isVisible => show == 1;
  
  /// 是否可续费
  bool get isRenewable => renew == 1;
  
  /// 流量大小（GB）
  double? get transferGB {
    if (transferEnable == null) return null;
    return transferEnable! / 1024.0;
  }
}
