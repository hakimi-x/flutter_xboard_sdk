import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_invite_models.dart';

/// V2Board 邀请 API 实现
class V2BoardInviteApi {
  final HttpService _httpService;

  V2BoardInviteApi(this._httpService);

  Future<ApiResponse<InviteInfo>> getInviteInfo() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/invite/fetch');
      final inviteInfo = InviteInfo.fromJson(result['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: inviteInfo);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取邀请信息失败: $e');
    }
  }

  Future<ApiResponse<InviteCode>> generateInviteCode() async {
    try {
      final result = await _httpService.postRequest('/api/v1/user/invite/save', {});
      final code = InviteCode.fromJson(result['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: code);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 生成邀请码失败: $e');
    }
  }

  Future<ApiResponse<List<CommissionDetail>>> fetchCommissionDetails({
    required int current,
    required int pageSize,
  }) async {
    try {
      final result = await _httpService.getRequest(
        '/api/v1/user/comm/fetch?current=$current&page_size=$pageSize',
      );
      final List<dynamic> detailsJson = result['data'] as List? ?? [];
      final details = detailsJson
          .map((json) => CommissionDetail.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse(success: true, data: details);
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取佣金详情失败: $e');
    }
  }

  Future<String> generateInviteLink(String baseUrl) async {
    try {
      final inviteInfo = await getInviteInfo();
      final codes = inviteInfo.data?.codes ?? [];
      if (codes.isEmpty) {
        throw ApiException('没有可用的邀请码');
      }
      return '$baseUrl/#/register?code=${codes.first.code}';
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 生成邀请链接失败: $e');
    }
  }
}
