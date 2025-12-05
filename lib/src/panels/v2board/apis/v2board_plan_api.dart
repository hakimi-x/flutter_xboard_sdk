import '../../../core/http/http_service.dart';
import '../../../core/exceptions/xboard_exceptions.dart';
import '../../../core/models/api_response.dart';
import '../../xboard/models/xboard_plan_models.dart';

/// V2Board 套餐 API 实现
class V2BoardPlanApi {
  final HttpService _httpService;

  V2BoardPlanApi(this._httpService);

  Future<ApiResponse<List<Plan>>> fetchPlans() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/plan/fetch');
      
      if (result['data'] != null) {
        final List<dynamic> plansJson = result['data'] as List;
        final plans = plansJson
            .map((json) => Plan.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return ApiResponse(
          success: true,
          data: plans,
        );
      }
      
      return ApiResponse(
        success: false,
        data: [],
        message: result['message'] ?? '获取套餐列表失败',
      );
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('V2Board 获取套餐列表失败: $e');
    }
  }
}
