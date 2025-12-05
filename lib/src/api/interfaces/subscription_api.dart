import '../models/subscription_model.dart';

abstract class SubscriptionApi {
  Future<SubscriptionModel> getSubscription();
  Future<String> getSubscribeUrl();
}
