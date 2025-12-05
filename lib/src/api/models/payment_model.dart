// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    required String id,
    required String name,
    @JsonKey(name: 'payment') String? paymentMethod,  // API字段为payment
    @JsonKey(name: 'handling_fee_fixed') double? handlingFeeFixed,
    @JsonKey(name: 'handling_fee_percent') double? handlingFeePercent,
    String? icon,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    Map<String, dynamic>? config,
    String? description,
    @JsonKey(name: 'min_amount') double? minAmount,
    @JsonKey(name: 'max_amount') double? maxAmount,
  }) = _PaymentMethodModel;

  const PaymentMethodModel._();

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodModelFromJson(json);
}

@freezed
class PaymentResultModel with _$PaymentResultModel {
  const factory PaymentResultModel.success({
    String? transactionId,
    String? message,
    Map<String, dynamic>? extra,
  }) = PaymentResultSuccess;

  const factory PaymentResultModel.redirect({
    required String url,
    String? method,
    Map<String, String>? headers,
  }) = PaymentResultRedirect;

  const factory PaymentResultModel.failed({
    required String message,
    String? errorCode,
    Map<String, dynamic>? extra,
  }) = PaymentResultFailed;

  const factory PaymentResultModel.canceled({
    String? message,
  }) = PaymentResultCanceled;

  factory PaymentResultModel.fromJson(Map<String, dynamic> json) => _$PaymentResultModelFromJson(json);
}
