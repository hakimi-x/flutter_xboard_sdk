import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_notice_models.dart';

/// V2Board 公告 API 实现
class V2BoardNoticeApi {
  final HttpService _httpService;

  V2BoardNoticeApi(this._httpService);

  Future<ApiResponse<List<Notice>>> fetchNotices() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/notice/fetch');
      final List<dynamic> noticesJson = result['data'] as List? ?? [];
      final notices = noticesJson.map((json) => Notice.fromJson(json as Map<String, dynamic>)).toList();
      return ApiResponse(success: true, data: notices);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取公告列表失败: $e');
    }
  }
}
