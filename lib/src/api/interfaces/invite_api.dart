import '../models/invite_model.dart';

abstract class InviteApi {
  Future<InviteInfoModel> getInviteInfo();
  Future<List<InviteCodeModel>> getInviteCodes();
  Future<String> generateInviteCode();
  Future<List<CommissionDetailModel>> getCommissionDetails({int page = 1, int pageSize = 10});
  Future<bool> withdrawCommission({required double amount, required String method, required Map<String, dynamic> params});
  Future<bool> transferCommissionToBalance(double amount);
}
