import '../../api/interfaces/payment_api.dart';
import '../../api/models/payment_model.dart';
import '../../panels/xboard/apis/xboard_payment_api.dart';
import '../../panels/xboard/models/xboard_payment_models.dart';

class XBoardPaymentAdapter implements PaymentApi {
  final XBoardPaymentApi _api;

  XBoardPaymentAdapter(this._api);

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _api.getPaymentMethods();
    if (response.data == null) return [];
    return response.data!.map(_mapPaymentMethod).toList();
  }

  PaymentMethodModel _mapPaymentMethod(PaymentMethodInfo method) {
    return PaymentMethodModel(
      id: method.id,
      name: method.name,
      paymentMethod: method.id, // Assuming id is the method key
      handlingFeeFixed: 0, // Not available in PaymentMethodInfo
      handlingFeePercent: method.feePercent,
      icon: method.icon,
      isAvailable: method.isAvailable,
      config: method.config,
      description: method.description,
      minAmount: method.minAmount,
      maxAmount: method.maxAmount,
    );
  }
}
