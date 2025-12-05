import '../../../core/http/http_service.dart';
import '../../../core/models/api_response.dart';
import '../models/xboard_coupon_models.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 优惠券 API 实现
class XBoardCouponApi {
  final HttpService _httpService;

  XBoardCouponApi(this._httpService);

  Future<ApiResponse<CouponData>> checkCoupon(String code, int planId) async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/coupon/check', {
        'code': code,
        'plan_id': planId,
      });
      return ApiResponse.fromJson(
        result,
        (json) => CouponData.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('验证优惠券失败: $e');
    }
  }
}
