import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_app_models.dart';

/// V2Board 应用 API 实现
class V2BoardAppApi {
  final HttpService _httpService;

  V2BoardAppApi(this._httpService);

  Future<ApiResponse<AppInfo>> generateDedicatedApp() async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/app/generate', {});
      final appInfo = AppInfo.fromJson(result['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: appInfo);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 生成专属应用失败: $e');
    }
  }

  Future<ApiResponse<AppInfo>> fetchDedicatedAppInfo() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/app/info');
      final appInfo = AppInfo.fromJson(result['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: appInfo);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取专属应用信息失败: $e');
    }
  }
}
