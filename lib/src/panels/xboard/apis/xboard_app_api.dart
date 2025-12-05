import '../../../core/http/http_service.dart';
import '../models/xboard_app_models.dart';
import '../../../core/models/api_response.dart';
import '../../../core/exceptions/xboard_exceptions.dart';

/// XBoard APP API 实现
class XBoardAppApi {
  final HttpService _httpService;

  XBoardAppApi(this._httpService);

  Future<ApiResponse<AppInfo>> generateDedicatedApp() async {
    try {
      final response = await _httpService.postRequest(
        '/api/v1/user/app/generate',
        {},
      );
      return ApiResponse.fromJson(
        response,
        (json) => AppInfo.fromJson(json as Map<String, dynamic>),
      );
    } on XBoardException {
      rethrow;
    } catch (e) {
      throw ApiException('Generate dedicated app failed: $e');
    }
  }

  Future<ApiResponse<AppInfo>> fetchDedicatedAppInfo() async {
    try {
      final response = await _httpService.getRequest('/api/v1/user/app/fetch');
      return ApiResponse.fromJson(
        response,
        (json) => AppInfo.fromJson(json as Map<String, dynamic>),
      );
    } on XBoardException {
      rethrow;
    } catch (e) {
      throw ApiException('Fetch dedicated app info failed: $e');
    }
  }
}
