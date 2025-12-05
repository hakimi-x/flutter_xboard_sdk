// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'xboard_payment_models.freezed.dart';
part 'xboard_payment_models.g.dart';

/// 支付状态枚举
enum PaymentStatus {
  initial,
  processing,
  success,
  failed,
  canceled,
  pending,
  timeout;

  String get description {
    switch (this) {
      case PaymentStatus.initial:
        return '初始状态';
      case PaymentStatus.processing:
        return '处理中';
      case PaymentStatus.success:
        return '支付成功';
      case PaymentStatus.failed:
        return '支付失败';
      case PaymentStatus.canceled:
        return '已取消';
      case PaymentStatus.pending:
        return '等待确认';
      case PaymentStatus.timeout:
        return '支付超时';
    }
  }

  bool get isFinal {
    return this == PaymentStatus.success || 
           this == PaymentStatus.failed || 
           this == PaymentStatus.canceled ||
           this == PaymentStatus.timeout;
  }

  bool get isSuccess => this == PaymentStatus.success;

  bool get isFailed => this == PaymentStatus.failed || this == PaymentStatus.timeout;
}

@freezed
class PaymentStatusResult with _$PaymentStatusResult {
  const factory PaymentStatusResult({
    required bool isSuccess,
    required bool isCanceled,
    required bool isPending,
    String? message,
  }) = _PaymentStatusResult;

  factory PaymentStatusResult.fromJson(Map<String, dynamic> json) => _$PaymentStatusResultFromJson(json);

  factory PaymentStatusResult.success([String? message]) => 
      PaymentStatusResult(
        isSuccess: true, 
        isCanceled: false, 
        isPending: false,
        message: message,
      );

  factory PaymentStatusResult.canceled([String? message]) => 
      PaymentStatusResult(
        isSuccess: false, 
        isCanceled: true, 
        isPending: false,
        message: message,
      );

  factory PaymentStatusResult.pending([String? message]) => 
      PaymentStatusResult(
        isSuccess: false, 
        isCanceled: false, 
        isPending: true,
        message: message,
      );

  factory PaymentStatusResult.failed([String? message]) => 
      PaymentStatusResult(
        isSuccess: false, 
        isCanceled: false, 
        isPending: false,
        message: message,
      );
}

// Helper functions for parsing
String _parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

@freezed
class PaymentMethodInfo with _$PaymentMethodInfo {
  const factory PaymentMethodInfo({
    required String id,
    required String name,
    @JsonKey(name: 'handling_fee_percent') required double feePercent,
    String? icon,
    @Default(true) bool isAvailable,
    Map<String, dynamic>? config,
    String? description,
    double? minAmount,
    double? maxAmount,
  }) = _PaymentMethodInfo;

  const PaymentMethodInfo._();

  factory PaymentMethodInfo.fromJson(Map<String, dynamic> json) {
    return PaymentMethodInfo(
      id: json['id']?.toString() ?? '',
      name: _parseString(json['name']),
      feePercent: _parseDouble(json['handling_fee_percent'] ?? json['fee_percent']),
      icon: json['icon'] as String?,
      isAvailable: json['is_available'] != false,
      config: json['config'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      minAmount: _parseDouble(json['min_amount']),
      maxAmount: _parseDouble(json['max_amount']),
    );
  }

  double calculateFee(double amount) {
    return amount * (feePercent / 100);
  }

  double calculateTotalAmount(double amount) {
    return amount + calculateFee(amount);
  }

  bool isAmountValid(double amount) {
    if (minAmount != null && amount < minAmount!) return false;
    if (maxAmount != null && amount > maxAmount!) return false;
    return true;
  }
}

@freezed
class PaymentOrderInfo with _$PaymentOrderInfo {
  const factory PaymentOrderInfo({
    required String tradeNo,
    required double originalAmount,
    @Default(0.0) double finalAmount,
    String? couponCode,
    double? discountAmount,
    @Default('CNY') String currency,
    DateTime? expireTime,
  }) = _PaymentOrderInfo;

  const PaymentOrderInfo._();

  factory PaymentOrderInfo.fromJson(Map<String, dynamic> json) => _$PaymentOrderInfoFromJson(json);

  double get actualDiscountAmount {
    return discountAmount ?? (originalAmount - finalAmount);
  }

  bool get hasDiscount => actualDiscountAmount > 0;

  double get discountPercent {
    if (originalAmount <= 0) return 0;
    return (actualDiscountAmount / originalAmount) * 100;
  }

  bool get isExpired {
    if (expireTime == null) return false;
    return DateTime.now().isAfter(expireTime!);
  }
}

@freezed
sealed class PaymentResult with _$PaymentResult {
  const factory PaymentResult.success({
    String? transactionId,
    String? message,
    Map<String, dynamic>? extra,
  }) = PaymentResultSuccess;

  const factory PaymentResult.redirect({
    required String url,
    String? method,
    Map<String, String>? headers,
  }) = PaymentResultRedirect;

  const factory PaymentResult.failed({
    required String message,
    String? errorCode,
    Map<String, dynamic>? extra,
  }) = PaymentResultFailed;

  const factory PaymentResult.canceled({
    String? message,
  }) = PaymentResultCanceled;

  factory PaymentResult.fromJson(Map<String, dynamic> json) => _$PaymentResultFromJson(json);
}

@freezed
sealed class PaymentError with _$PaymentError {
  const PaymentError._();

  const factory PaymentError.noToken() = NoTokenError;
  const factory PaymentError.networkError([String? message]) = NetworkError;
  const factory PaymentError.invalidResponse([String? message]) = InvalidResponseError;
  const factory PaymentError.preCheckFailed([String? message]) = PreCheckError;
  const factory PaymentError.cannotLaunchUrl([String? url]) = UrlLaunchError;
  const factory PaymentError.timeout([String? message]) = PaymentTimeoutError;
  const factory PaymentError.invalidAmount([String? message]) = InvalidAmountError;
  const factory PaymentError.paymentMethodUnavailable([String? message]) = PaymentMethodUnavailableError;
  const factory PaymentError.unknownError(String message) = UnknownError;

  factory PaymentError.fromException(dynamic e) {
    if (e is PaymentError) return e;
    return PaymentError.unknownError(e.toString());
  }

  @override
  String toString() {
    return map(
      noToken: (_) => 'PaymentError(NO_TOKEN): No access token available',
      networkError: (e) => 'PaymentError(NETWORK_ERROR): ${e.message ?? 'Network request failed'}',
      invalidResponse: (e) => 'PaymentError(INVALID_RESPONSE): ${e.message ?? 'Invalid server response'}',
      preCheckFailed: (e) => 'PaymentError(PRE_CHECK_FAILED): ${e.message ?? 'Payment pre-check failed'}',
      cannotLaunchUrl: (e) => 'PaymentError(URL_LAUNCH_ERROR): ${e.url != null ? 'Cannot launch payment URL: ${e.url}' : 'Cannot launch payment URL'}',
      timeout: (e) => 'PaymentError(TIMEOUT): ${e.message ?? 'Payment timeout'}',
      invalidAmount: (e) => 'PaymentError(INVALID_AMOUNT): ${e.message ?? 'Invalid payment amount'}',
      paymentMethodUnavailable: (e) => 'PaymentError(METHOD_UNAVAILABLE): ${e.message ?? 'Payment method is not available'}',
      unknownError: (e) => 'PaymentError(UNKNOWN_ERROR): ${e.message}',
    );
  }
}

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState({
    PaymentOrderInfo? orderInfo,
    @Default(PaymentStatus.initial) PaymentStatus status,
    String? error,
    @Default([]) List<PaymentMethodInfo> paymentMethods,
    @Default(false) bool isLoading,
    PaymentResult? result,
  }) = _PaymentState;

  const PaymentState._();

  bool get canPay {
    return orderInfo != null && 
           !isLoading && 
           status != PaymentStatus.processing &&
           paymentMethods.isNotEmpty;
  }

  bool get isCompleted {
    return status.isFinal;
  }

  bool get isSuccess {
    return status.isSuccess;
  }
}

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    @JsonKey(name: 'trade_no') required String tradeNo,
    required String method,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
}

@freezed
class PaymentResponse with _$PaymentResponse {
  const factory PaymentResponse({
    required bool success,
    String? message,
    PaymentResult? result,
    Map<String, dynamic>? data,
  }) = _PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => _$PaymentResponseFromJson(json);
}