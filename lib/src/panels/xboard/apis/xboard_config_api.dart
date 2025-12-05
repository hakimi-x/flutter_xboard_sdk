import '../../../core/http/http_service.dart';
import '../models/xboard_config_models.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard 配置 API 实现
class XBoardConfigApi {
  final HttpService _httpService;

  XBoardConfigApi(this._httpService);

  Future<ConfigData> getConfig() async {
    try {
      // 使用 guest 接口获取注册配置（包含 is_email_verify 和 is_invite_force）
      final result = await _httpService.getRequest('/api/v1/guest/comm/config');
      return ConfigData.fromJson(result['data'] as Map<String, dynamic>);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取配置失败: $e');
    }
  }
}
