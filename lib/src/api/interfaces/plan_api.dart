import '../models/plan_model.dart';

abstract class PlanApi {
  Future<List<PlanModel>> getPlans();
  Future<PlanModel?> getPlan(int id);
}
