import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_manager.dart';

final subscriptionProvider = Provider<SubscriptionManager>((ref) {
  return SubscriptionManager();
});
