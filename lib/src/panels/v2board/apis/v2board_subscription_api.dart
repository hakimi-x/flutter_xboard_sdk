import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../xboard/models/xboard_subscription_models.dart';

/// V2Board 订阅 API 实现
class V2BoardSubscriptionApi {
  final HttpService _httpService;

  V2BoardSubscriptionApi(this._httpService);

  Future<SubscriptionInfo> getSubscriptionInfo() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/getSubscribe');
      return SubscriptionInfo.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取订阅信息失败: $e');
    }
  }
}
