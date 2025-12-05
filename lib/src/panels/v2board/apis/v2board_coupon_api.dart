import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_coupon_models.dart';

/// V2Board 优惠券 API 实现
class V2BoardCouponApi {
  final HttpService _httpService;

  V2BoardCouponApi(this._httpService);

  Future<ApiResponse<CouponData>> checkCoupon(String code, int planId) async {
    try {
      final result = await _httpService.postRequest(
        '/api/v1/user/coupon/check',
        {
          'code': code,
          'plan_id': planId,
        },
      );
      final coupon = CouponData.fromJson(result['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: coupon);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 检查优惠券失败: $e');
    }
  }
}
