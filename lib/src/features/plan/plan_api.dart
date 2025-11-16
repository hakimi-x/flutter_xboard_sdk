import 'package:flutter_xboard_sdk/src/services/http_service.dart';
import 'package:flutter_xboard_sdk/src/features/plan/plan_models.dart';
import 'package:flutter_xboard_sdk/src/common/models/api_response.dart';
import 'package:flutter_xboard_sdk/src/exceptions/xboard_exceptions.dart';

class PlanApi {
  final HttpService _httpService;

  PlanApi(this._httpService);

  /// 获取套餐列表
  Future<ApiResponse<List<Plan>>> fetchPlans() async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/plan/fetch');
      return ApiResponse.fromJson(result, (json) => (json as List<dynamic>).map((e) => Plan.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取套餐列表时发生错误: $e');
    }
  }

  /// 获取套餐详情
  Future<ApiResponse<Plan>> fetchPlanDetail(int id) async {
    try {
      final result = await _httpService.getRequest('/api/v1/user/plan/fetch?id=$id');
      return ApiResponse.fromJson(result, (json) => Plan.fromJson(json as Map<String, dynamic>));
    } catch (e) {
      if (e is XBoardException) rethrow;
      throw ApiException('获取套餐详情时发生错误: $e');
    }
  }
}
