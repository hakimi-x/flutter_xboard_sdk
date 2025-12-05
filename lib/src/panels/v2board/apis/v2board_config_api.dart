import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../xboard/models/xboard_config_models.dart';

/// V2Board 配置 API 实现
class V2BoardConfigApi {
  final HttpService _httpService;

  V2BoardConfigApi(this._httpService);

  Future<ConfigData> getConfig() async {
    try {
      // V2Board 也使用 guest 接口获取配置
      final result = await _httpService.getRequest('/api/v1/guest/comm/config');
      return ConfigData.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取配置失败: $e');
    }
  }
}
