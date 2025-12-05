import '../models/payment_model.dart';

abstract class PaymentApi {
  Future<List<PaymentMethodModel>> getPaymentMethods();
}
