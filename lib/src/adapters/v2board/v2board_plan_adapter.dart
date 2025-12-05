import '../../api/interfaces/plan_api.dart';
import '../../api/models/plan_model.dart';
import '../../panels/v2board/apis/v2board_plan_api.dart';
import '../../panels/xboard/models/xboard_plan_models.dart';

class V2BoardPlanAdapter implements PlanApi {
  final V2BoardPlanApi _api;

  V2BoardPlanAdapter(this._api);

  @override
  Future<List<PlanModel>> getPlans() async {
    final response = await _api.fetchPlans();
    if (response.data == null) return [];
    return response.data!.map(_mapPlan).toList();
  }

  @override
  Future<PlanModel?> getPlan(int id) async {
    final plans = await getPlans();
    try {
      return plans.firstWhere((element) => element.id == id);
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
      speedLimit: plan.speedLimit,
      show: plan.show,
      sort: plan.sort,
      renew: plan.renew,
      content: plan.content,
      monthPrice: plan.monthPrice,
      quarterPrice: plan.quarterPrice,
      halfYearPrice: plan.halfYearPrice,
      yearPrice: plan.yearPrice,
      twoYearPrice: plan.twoYearPrice,
      threeYearPrice: plan.threeYearPrice,
      onetimePrice: plan.onetimePrice,
      resetPrice: plan.resetPrice,
    );
  }
}
