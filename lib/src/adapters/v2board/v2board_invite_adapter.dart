import '../../api/interfaces/invite_api.dart';
import '../../api/models/invite_model.dart';
import '../../panels/v2board/apis/v2board_invite_api.dart';
import '../../panels/xboard/models/xboard_invite_models.dart';

class V2BoardInviteAdapter implements InviteApi {
  final V2BoardInviteApi _api;

  V2BoardInviteAdapter(this._api);

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

  @override
  Future<bool> withdrawCommission({required double amount, required String method, required Map<String, dynamic> params}) async {
    // V2Board 可能不支持此功能，返回 false 或抛出异常
    throw UnimplementedError('V2Board does not support commission withdrawal');
  }

  @override
  Future<bool> transferCommissionToBalance(double amount) async {
    // V2Board 可能不支持此功能，返回 false 或抛出异常
    throw UnimplementedError('V2Board does not support commission transfer');
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
}
