import '../../../core/http/http_service.dart';
import '../../../core/models/api_response.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../models/xboard_invite_models.dart';

/// XBoard 邀请 API 实现
class XBoardInviteApi {
  final HttpService _httpService;

  XBoardInviteApi(this._httpService);

  Future<ApiResponse<InviteCode>> generateInviteCode() async {
    try {
      // 调用生成邀请码接口（返回 boolean）
      final response = await _httpService.getRequest('/api/v1/user/invite/save');
      
      // 检查是否成功
      if (response['data'] != true) {
        throw ApiException('Generate invite code failed');
      }
      
      // 重新获取邀请信息以获取新生成的邀请码
      final inviteInfoResponse = await _httpService.getRequest('/api/v1/user/invite/fetch');
      final inviteInfo = InviteInfo.fromJson(inviteInfoResponse['data'] as Map<String, dynamic>);
      
      // 获取最新的邀请码（第一个）
      if (inviteInfo.codes.isEmpty) {
        throw ApiException('No invite code found after generation');
      }
      
      final newCode = inviteInfo.codes.first;
      
      return ApiResponse(
        success: true,
        data: newCode,
        message: response['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('Generate invite code failed: $e');
    }
  }

  Future<ApiResponse<InviteInfo>> getInviteInfo() async {
    try {
      final response = await _httpService.getRequest('/api/v1/user/invite/fetch');
      return ApiResponse.fromJson(
        response,
        (json) => InviteInfo.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw ApiException('Fetch invite codes failed: $e');
    }
  }

  Future<ApiResponse<List<CommissionDetail>>> fetchCommissionDetails({
    required int current,
    required int pageSize,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uri = '/api/v1/user/invite/details?current=$current&page_size=$pageSize&t=$timestamp';
      final response = await _httpService.getRequest(uri);
      
      // API 返回: {data: [...], total: 10}
      final dynamic dataField = response['data'];
      
      List<CommissionDetail> details;
      if (dataField is List) {
        // 如果 data 直接是数组
        details = dataField
            .map((e) => CommissionDetail.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (dataField is Map<String, dynamic>) {
        // 如果 data 是嵌套结构
        final detailData = dataField['data'] as List<dynamic>? ?? [];
        details = detailData
            .map((e) => CommissionDetail.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        details = [];
      }
      
      return ApiResponse(
        success: true,
        data: details,
        message: response['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('Fetch commission details failed: $e');
    }
  }

  Future<String> generateInviteLink(String baseUrl) async {
    // 获取邀请信息以获取邀请码
    final inviteInfo = await getInviteInfo();
    final codes = inviteInfo.data?.codes ?? [];
    
    if (codes.isEmpty) {
      throw ApiException('No invite codes available');
    }
    
    // 使用第一个有效的邀请码
    final code = codes.firstWhere(
      (c) => c.isActive,
      orElse: () => codes.first,
    ).code;
    
    return '$baseUrl/?code=$code';
  }

  Future<ApiResponse<bool>> withdrawCommission({
    required double amount,
    required String method,
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await _httpService.postRequest('/api/v1/user/invite/withdraw', {
        'amount': amount,
        'method': method,
        ...params,
      });
      
      return ApiResponse(
        success: true,
        data: true,
        message: response['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('Withdraw commission failed: $e');
    }
  }

  Future<ApiResponse<bool>> transferCommissionToBalance({
    required double amount,
  }) async {
    try {
      // 假设接口为 /api/v1/user/invite/transfer
      // 如果实际接口不同，请修改此处
      final response = await _httpService.postRequest('/api/v1/user/invite/transfer', {
        'amount': amount,
      });
      
      return ApiResponse(
        success: true,
        data: true,
        message: response['message'] as String?,
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('Transfer commission failed: $e');
    }
  }
}
