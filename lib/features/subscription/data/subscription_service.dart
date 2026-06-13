import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:savingor_app/core/config/revenuecat_config.dart';
import 'package:savingor_app/features/subscription/data/debug_subscription_override_store.dart';
import 'package:savingor_app/features/subscription/domain/debug_subscription_override.dart';
import 'package:savingor_app/features/subscription/domain/effective_subscription_resolver.dart';
import 'package:savingor_app/features/subscription/domain/subscription_status.dart';

export 'package:savingor_app/features/subscription/domain/subscription_status.dart';

/// RevenueCat-powered subscription service with a safe demo fallback.
///
/// Production flow:
/// Flutter app → RevenueCat SDK → Apple StoreKit / Google Play Billing →
/// RevenueCat "pro" entitlement → app unlocks Pro.
///
/// - With RevenueCat configured, the "pro" entitlement is the source of
///   truth; Firestore `users/{uid}` is only a UI mirror/cache.
/// - Without RevenueCat keys (local portfolio builds), the explicit demo
///   fallback methods write the Firestore mirror with provider "demo".
///
/// TODO: Replace fallback demo activation with real RevenueCat purchase once
/// RevenueCat API keys and store products are configured.
class SubscriptionService {
  SubscriptionService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  static const double proMonthlyPrice = 14.99;
  static const String proCurrency = 'CAD';

  static const String _notConfiguredMessage =
      'Payment provider is not configured in this local build.';

  /// Set after a successful [configureRevenueCat] call in this session.
  static bool _revenueCatReady = false;

  static DebugSubscriptionOverrideStore? _debugOverrideStore;

  /// Binds the local debug override store (debug builds only).
  static void bindDebugOverrideStore(DebugSubscriptionOverrideStore store) {
    _debugOverrideStore = store;
  }

  static DebugSubscriptionOverrideStore? get debugOverrideStore =>
      _debugOverrideStore;

  /// True when RevenueCat public keys were supplied at build time.
  bool get isRevenueCatConfigured => RevenueCatConfig.isConfigured;

  /// True when the SDK has been configured and can be called.
  bool get isRevenueCatReady => _revenueCatReady;

  /// Initializes the RevenueCat SDK. Safe no-op when keys are missing or the
  /// platform is unsupported — the app must never crash because of this.
  Future<void> configureRevenueCat({required String appUserId}) async {
    if (_revenueCatReady || !RevenueCatConfig.isConfigured || kIsWeb) {
      return;
    }

    final String apiKey;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        apiKey = RevenueCatConfig.androidApiKey;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        apiKey = RevenueCatConfig.iosApiKey;
        break;
      default:
        return;
    }
    if (apiKey.isEmpty) {
      return;
    }

    try {
      await Purchases.configure(
        PurchasesConfiguration(apiKey)..appUserID = appUserId,
      );
      _revenueCatReady = true;
    } catch (_) {
      // Never crash on startup because of subscription configuration.
      _revenueCatReady = false;
    }
  }

  /// Returns the active Pro entitlement from [info], accepting any of the
  /// known identifiers ("Savingor Pro" from the RevenueCat dashboard, or
  /// "pro" as the future clean identifier).
  static EntitlementInfo? _activeProEntitlement(CustomerInfo info) {
    for (final String id in RevenueCatConfig.proEntitlementIds) {
      final EntitlementInfo? entitlement = info.entitlements.active[id];
      if (entitlement != null) {
        return entitlement;
      }
    }
    return null;
  }

  /// Real subscription state from RevenueCat or the Firestore mirror.
  ///
  /// Never applies the local debug override. Use for manage-subscription flows.
  Future<SubscriptionStatus> getRealSubscription() async {
    return _fetchRealSubscription();
  }

  /// Effective subscription state for feature access and plan previews.
  ///
  /// Applies the local debug override in debug builds only.
  Future<SubscriptionStatus> getCurrentSubscription() async {
    final SubscriptionStatus real = await _fetchRealSubscription();
    return _applyDebugOverride(real);
  }

  SubscriptionStatus _applyDebugOverride(SubscriptionStatus real) {
    final DebugSubscriptionOverrideStore? store = _debugOverrideStore;
    final DebugSubscriptionOverride debugOverride =
        store?.override ?? DebugSubscriptionOverride.none;
    return resolveEffectiveSubscription(
      real: real,
      debugOverride: debugOverride,
    );
  }

  Future<SubscriptionStatus> _fetchRealSubscription() async {
    if (_revenueCatReady) {
      try {
        final CustomerInfo info = await Purchases.getCustomerInfo();
        final EntitlementInfo? pro = _activeProEntitlement(info);
        if (pro != null) {
          const SubscriptionStatus status = SubscriptionStatus(
            plan: SubscriptionPlan.pro,
            status: SubscriptionState.active,
            provider: SubscriptionProvider.revenuecat,
            price: proMonthlyPrice,
            currency: proCurrency,
          );
          await _mirrorRevenueCatPro();
          return status;
        }
        return SubscriptionStatus.free;
      } catch (_) {
        // Fall back to the Firestore mirror on transient SDK errors.
      }
    }
    return _readFirestoreMirror();
  }

  Future<bool> isPro() async =>
      (await getCurrentSubscription()).hasActiveProAccess;

  /// Purchases the monthly Pro subscription through RevenueCat.
  /// Throws [SubscriptionException] with a clear message when the payment
  /// provider is not configured (local portfolio builds).
  Future<void> purchaseProMonthly() async {
    if (!_revenueCatReady) {
      throw const SubscriptionException(_notConfiguredMessage);
    }

    try {
      final Offerings offerings = await Purchases.getOfferings();
      final Offering? offering =
          offerings.all[RevenueCatConfig.offeringId] ?? offerings.current;

      Package? package = offering?.monthly;
      if (package == null && offering != null) {
        for (final Package candidate in offering.availablePackages) {
          if (candidate.storeProduct.identifier ==
              RevenueCatConfig.productProMonthly) {
            package = candidate;
            break;
          }
        }
      }
      if (package == null) {
        throw const SubscriptionException(
          'The Pro subscription is not available right now. Please try again later.',
        );
      }

      final PurchaseResult result =
          await Purchases.purchase(PurchaseParams.package(package));
      final EntitlementInfo? pro = _activeProEntitlement(result.customerInfo);
      if (pro == null) {
        throw const SubscriptionException(
          'Purchase completed but Pro is not active yet. Try Restore purchases.',
        );
      }

      await _mirrorRevenueCatPro();
    } on SubscriptionException {
      rethrow;
    } on PlatformException catch (e) {
      final PurchasesErrorCode code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        throw const SubscriptionException('Purchase cancelled.');
      }
      if (code == PurchasesErrorCode.networkError) {
        throw const SubscriptionException(
          'Network error. Check your connection and try again.',
        );
      }
      throw const SubscriptionException(
        'Could not complete the purchase. Please try again.',
      );
    }
  }

  /// Restores previous store purchases through RevenueCat and updates the
  /// Firestore mirror. Returns the resulting subscription state.
  Future<SubscriptionStatus> restorePurchases() async {
    if (!_revenueCatReady) {
      throw const SubscriptionException(_notConfiguredMessage);
    }

    try {
      final CustomerInfo info = await Purchases.restorePurchases();
      final EntitlementInfo? pro = _activeProEntitlement(info);
      if (pro != null) {
        await _mirrorRevenueCatPro();
        return const SubscriptionStatus(
          plan: SubscriptionPlan.pro,
          status: SubscriptionState.active,
          provider: SubscriptionProvider.revenuecat,
          price: proMonthlyPrice,
          currency: proCurrency,
        );
      }
      return SubscriptionStatus.free;
    } on PlatformException {
      throw const SubscriptionException(
        'Could not restore purchases. Please try again.',
      );
    }
  }

  /// Returns the store subscription management URL from RevenueCat
  /// (`CustomerInfo.managementURL`), or null when it is unavailable —
  /// e.g. RevenueCat is not configured, the Test Store is in use, or there
  /// is no managed subscription for this customer. Never throws.
  Future<String?> getManagementUrl() async {
    if (!_revenueCatReady) {
      return null;
    }
    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      final String? url = info.managementURL;
      if (url == null || url.isEmpty) {
        return null;
      }
      return url;
    } catch (_) {
      return null;
    }
  }

  /// Demo fallback for local portfolio testing only — marks the user as Pro
  /// in the Firestore mirror. No payment is processed.
  ///
  /// TODO: Replace fallback demo activation with real RevenueCat purchase
  /// once RevenueCat API keys and store products are configured.
  Future<void> activateProDemoFallback() async {
    await _writeSubscriptionMirror(<String, dynamic>{
      'subscriptionPlan': 'pro',
      'subscriptionStatus': 'active_demo',
      'subscriptionProvider': 'demo',
      'subscriptionPrice': proMonthlyPrice,
      'subscriptionCurrency': proCurrency,
      'subscriptionUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Cancels the demo fallback and returns the user to the Free plan.
  Future<void> cancelProDemoFallback() async {
    await _writeSubscriptionMirror(<String, dynamic>{
      'subscriptionPlan': 'free',
      'subscriptionStatus': 'inactive',
      'subscriptionProvider': 'none',
      'subscriptionPrice': 0,
      'subscriptionCurrency': proCurrency,
      'subscriptionUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<SubscriptionStatus> _readFirestoreMirror() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return SubscriptionStatus.free;
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(user.uid).get();
    final Map<String, dynamic>? data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return SubscriptionStatus.free;
    }
    return SubscriptionStatus.fromFirestore(data);
  }

  /// Mirrors an active RevenueCat Pro entitlement to Firestore (UI cache).
  Future<void> _mirrorRevenueCatPro() async {
    try {
      await _writeSubscriptionMirror(<String, dynamic>{
        'subscriptionPlan': 'pro',
        'subscriptionStatus': 'active',
        'subscriptionProvider': 'revenuecat',
        'subscriptionPrice': proMonthlyPrice,
        'subscriptionCurrency': proCurrency,
        'subscriptionUpdatedAt': FieldValue.serverTimestamp(),
      });
    } on SubscriptionException {
      // Mirror failures must not break the entitlement-based flow.
    }
  }

  /// Firestore is a UI mirror/cache only — never the source of truth for
  /// real payments.
  Future<void> _writeSubscriptionMirror(Map<String, dynamic> data) async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const SubscriptionException(
        'You need to be signed in to manage your subscription.',
      );
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));
    } on FirebaseException {
      throw const SubscriptionException(
        'Could not update your subscription. Please try again.',
      );
    }
  }
}

/// Thrown when a subscription operation fails with a user-facing message.
class SubscriptionException implements Exception {
  const SubscriptionException(this.message);

  final String message;

  @override
  String toString() => message;
}
