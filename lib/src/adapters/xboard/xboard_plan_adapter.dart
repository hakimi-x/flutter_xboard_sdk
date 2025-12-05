import '../../api/interfaces/plan_api.dart';
import '../../api/models/plan_model.dart';
import '../../panels/xboard/apis/xboard_plan_api.dart';
import '../../panels/xboard/models/xboard_plan_models.dart';

class XBoardPlanAdapter implements PlanApi {
  final XBoardPlanApi _api;

  XBoardPlanAdapter(this._api);

  @override
  Future<List<PlanModel>> getPlans() async {
    final response = await _api.fetchPlans();
    if (response.data == null) return [];
    return response.data!.map(_mapPlan).toList();
  }

  @override
  Future<PlanModel?> getPlan(int id) async {
    // XBoard API typically returns all plans, so we might need to filter locally or implement a specific endpoint if available.
    // Assuming getPlans returns all, we filter here.
    final response = await _api.fetchPlans();
    try {
      if (response.data == null) return null;
      final plan = response.data!.firstWhere((p) => p.id == id);
      return _mapPlan(plan);
    } catch (e) {
      return null;
    }
  }

  PlanModel _mapPlan(Plan plan) {
    return PlanModel(
      id: plan.id,
      groupId: plan.groupId,
      transferEnable: plan.transferEnable,
      name: plan.name,
      tags: plan.tags,
      speedLimit: plan.speedLimit,
      show: plan.show,
      content: plan.content,
      onetimePrice: plan.onetimePrice,
      monthPrice: plan.monthPrice,
      quarterPrice: plan.quarterPrice,
      halfYearPrice: plan.halfYearPrice,
      yearPrice: plan.yearPrice,
      twoYearPrice: plan.twoYearPrice,
      threeYearPrice: plan.threeYearPrice,
      resetPrice: plan.resetPrice,
      capacityLimit: plan.capacityLimit,
      deviceLimit: plan.deviceLimit,
      sell: plan.sell,
      renew: plan.renew,
      resetTrafficMethod: plan.resetTrafficMethod,
      sort: plan.sort,
      createdAt: plan.createdAt,
      updatedAt: plan.updatedAt,
    );
  }
}
