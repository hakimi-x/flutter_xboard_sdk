import '../../api/interfaces/invite_api.dart';
import '../../api/models/invite_model.dart';
import '../../panels/xboard/apis/xboard_invite_api.dart';
import '../../panels/xboard/models/xboard_invite_models.dart';

class XBoardInviteAdapter implements InviteApi {
  final XBoardInviteApi _api;

  XBoardInviteAdapter(this._api);

  @override
  Future<InviteInfoModel> getInviteInfo() async {
    final response = await _api.getInviteInfo();
    if (response.data == null) throw Exception('Invite info is null');
    return _mapInviteInfo(response.data!);
  }

  @override
  Future<List<InviteCodeModel>> getInviteCodes() async {
    final response = await _api.getInviteInfo();
    if (response.data == null) return [];
    return response.data!.codes.map(_mapInviteCode).toList();
  }

  @override
  Future<String> generateInviteCode() async {
    final response = await _api.generateInviteCode();
    if (response.data == null) throw Exception('Generated invite code is null');
    return response.data!.code;
  }

  @override
  Future<List<CommissionDetailModel>> getCommissionDetails({int page = 1, int pageSize = 10}) async {
    final response = await _api.fetchCommissionDetails(current: page, pageSize: pageSize);
    if (response.data == null) return [];
    return response.data!.map(_mapCommissionDetail).toList();
  }

  InviteInfoModel _mapInviteInfo(InviteInfo info) {
    return InviteInfoModel(
      codes: info.codes.map(_mapInviteCode).toList(),
      stat: info.stat,
    );
  }

  InviteCodeModel _mapInviteCode(InviteCode code) {
    return InviteCodeModel(
      userId: code.userId,
      code: code.code,
      pv: code.pv,
      status: code.status,
      createdAt: code.createdAt,
      updatedAt: code.updatedAt,
    );
  }

  CommissionDetailModel _mapCommissionDetail(CommissionDetail detail) {
    return CommissionDetailModel(
      id: detail.id,
      orderAmount: detail.orderAmount,
      tradeNo: detail.tradeNo,
      getAmount: detail.getAmount,
      createdAt: detail.createdAt,
    );
  }

  @override
  Future<bool> withdrawCommission({required double amount, required String method, required Map<String, dynamic> params}) async {
    final response = await _api.withdrawCommission(
      amount: amount,
      method: method,
      params: params,
    );
    return response.success;
  }

  @override
  Future<bool> transferCommissionToBalance(double amount) async {
    final response = await _api.transferCommissionToBalance(amount: amount);
    return response.success;
  }
}
