import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class SubscriptionManager extends ChangeNotifier {
  static final SubscriptionManager _instance = SubscriptionManager._internal();
  factory SubscriptionManager() => _instance;
  SubscriptionManager._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _isAvailable = false;
  bool _isPremium = false;
  List<ProductDetails> _products = [];
  bool _purchasePending = false;

  static const String _premiumProductId = 'intellilearn_premium_monthly';

  bool get isAvailable => _isAvailable;
  bool get isPremium => _isPremium;
  List<ProductDetails> get products => _products;
  bool get purchasePending => _purchasePending;

  Future<void> init() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    if (Platform.isIOS) {
      final iosAddition = _iap
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosAddition.setDelegate(
        ExamplePaymentQueueDelegate() as SKPaymentQueueDelegateWrapper,
      );
    }

    _subscription = _iap.purchaseStream.listen(_listenToPurchaseUpdated);
    await _loadProducts();
    await _checkPastPurchases();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails({_premiumProductId});
    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> _checkPastPurchases() async {
    await _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        _purchasePending = true;
      } else {
        _purchasePending = false;
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          if (purchase.productID == _premiumProductId) {
            _isPremium = true;
          }
        }
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
      notifyListeners();
    }
  }

  Future<void> purchasePremium() async {
    final product = _products.firstWhere(
      (p) => p.id == _premiumProductId,
      orElse: () => throw Exception("Product not loaded"),
    );
    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final iosAddition = _iap
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }
}

class ExamplePaymentQueueDelegate extends SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) => true;

  @override
  bool shouldShowPriceConsent() => false;
}

