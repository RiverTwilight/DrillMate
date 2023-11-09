import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:hgeology_app/pages/account/login_page.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/provider/network/purchase_provider.dart';
import 'package:hgeology_app/utils/contact.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/widget/tip_text.dart';
import 'package:hgeology_app/gen/strings.g.dart';

final bool _kAutoConsume = Platform.isIOS || true;
final double _bottomPurchaseBarHeight = 120;

// keep sync with App Store Connect
// https://appstoreconnect.apple.com/apps/6453835050/appstore/subscription-groups/21367945
const String _kLifeTimeId = 'lifetime_plus_v1';
const String _kMonthlySubscriptionId = 'monthly_plus_v1';
const String _kSixMonthSubscriptionId = 'sixmonths_plus_v1';

// !!Do NOT break the order!!
const List<String> _kProductIds = <String>[
  _kMonthlySubscriptionId,
  _kSixMonthSubscriptionId,
  _kLifeTimeId,
];

class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initStoreInfo();
    });
  }

  Future<void> _refreshData() async {
    print("Refresing the data");

    final userDataManager = ref.read(userDataProvider);

    userDataManager.loadData();
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    // Price changes for Android are not handled by the application, but are
    // instead handled by the Play Store. See
    // https://developer.android.com/google/play/billing/price-changes for more
    // information on price changes on Android.
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  void handleError(IAPError error) {
    print("Error ${error}");

    setState(() {
      _purchasePending = false;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    setState(() {
      _purchasePending = false;
    });
    _inAppPurchase.completePurchase(purchaseDetails);

    _refreshData();
    // Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    final purchaseProvider = PurchaseProvider();

    bool isValid = await purchaseProvider.verifyPurchase(purchaseDetails);

    return isValid;
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        _handleInvalidPurchase(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            print("Payment Successful");
            setState(() {
              _purchasePending = false;
            });

            _refreshData();

            // Navigator.popUntil(context, (route) => route.isFirst);

            Navigator.pop(context);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume &&
              purchaseDetails.productID == _kMonthlySubscriptionId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  void invokePurchase(int productId) {
    if (!AuthProvider().loggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            onLoginSuccess: () {
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ),
      );
      return;
    }

    if (DataProvider().isPlus) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.purchasePage.alreadyPurchasedHint),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      _cleanTransanctions();

      final ProductDetails productDetails = _products[productId];
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: AuthProvider().user?.id,
      );

      if (productId == 0) {
        InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
    }
  }

  void _redeem() {
    TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(t.purchasePage.redeem.dialogTitle),
          content: TextField(
            controller: codeController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (!AuthProvider().loggedIn) {
                  // Handle the not-logged-in case
                } else {
                  final purchaseProvider = PurchaseProvider();

                  final ApiResponse response =
                      await purchaseProvider.redeemCode(codeController.text);

                  if (response.status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.purchasePage.redeem.redeemSuccessHint),
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response.message),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: Text(t.general.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(t.purchasePage.title),
          leading: const LeadingBackButton(),
        ),
        body: const Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(t.purchasePage.title),
            leading: const LeadingBackButton(),
            actions: [
              TextButton(
                onPressed: _redeem,
                child: Text(t.purchasePage.redeem.title),
              )
            ],
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.maxFinite,
                            color: Theme.of(context).colorScheme.primary,
                            child: InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Text(
                                        "${t.appName}+",
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      textColor: Colors.white,
                                      dense: true,
                                      leading: const Icon(
                                        Icons.video_chat_rounded,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        t.purchasePage.intro.unlimited,
                                      ),
                                    ),
                                    ListTile(
                                      textColor: Colors.white,
                                      dense: true,
                                      leading: const Icon(
                                        Icons.cloud,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        t.purchasePage.intro.sync,
                                      ),
                                    ),
                                    ListTile(
                                      textColor: Colors.white,
                                      dense: true,
                                      leading: const Icon(
                                        Icons.workspace_premium_sharp,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        t.purchasePage.intro.review,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Add your descriptions here.
                          const SizedBox(height: 16),
                          if (AuthProvider().user == null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: TipCard(
                                variant: 'info',
                                text: t.purchasePage.loginHint,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                        onLoginSuccess: () {
                                          Navigator.pop(context);
                                          setState(
                                              () {}); // remove the login prompt
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          // Feature Comparison DataTable
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: DataTable(
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Feature',
                                      // style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Basic',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Plus',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                _buildDataRow([
                                  t.purchasePage.features.bookmark,
                                  '100',
                                  'Unlimited'
                                ]),
                                _buildDataRow([
                                  t.purchasePage.features.media,
                                  '8',
                                  'Unlimited'
                                ]),
                                _buildDataRow(
                                    [t.purchasePage.features.note, '✅', '✅']),
                                _buildDataRow(
                                    [t.purchasePage.features.tag, '✅', '✅']),
                                _buildDataRow(
                                    [t.purchasePage.features.loop, '✅', '✅']),
                                _buildDataRow(
                                    [t.purchasePage.features.speed, '✅', '✅']),
                                _buildDataRow(
                                    [t.purchasePage.features.theme, '✅', '✅']),
                                _buildDataRow([
                                  t.purchasePage.features.transcribe,
                                  '✅',
                                  '✅'
                                ]),
                                _buildDataRow([
                                  t.purchasePage.features.cloudSync,
                                  '❌',
                                  '✅'
                                ]),
                                _buildDataRow(
                                    [t.purchasePage.features.review, '❌', '✅']),
                                // _buildDataRow(['Custom Practice', '❌', '✅']),
                                // _buildDataRow(['Auto generate subtitle', '❌', '✅']),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodySmall,
                                children: [
                                  TextSpan(
                                    text: t
                                        .purchasePage.purchaseHint.beforePolicy,
                                  ),
                                  TextSpan(
                                    text: t.purchasePage.purchaseHint.policy,
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => WebViewPage(
                                        //       initialUrl: privacyPolicyLink,
                                        //     ),
                                        //   ),
                                        // );
                                        checkPrivacyPolicy();
                                      },
                                  ),
                                  TextSpan(
                                    text:
                                        t.purchasePage.purchaseHint.afterPolicy,
                                  ),
                                  TextSpan(
                                    text: t.purchasePage.purchaseHint.contact,
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        support(context);
                                      },
                                  ),
                                  TextSpan(
                                    text: t
                                        .purchasePage.purchaseHint.afterContact,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              showPendingUI();
                              await InAppPurchase.instance.restorePurchases();
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(t.purchasePage.restore),
                          ),
                          const SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _products.isEmpty
              ? Container()
              : BottomAppBar(
                  height: kBottomNavigationBarHeight + 40,
                  child: IconTheme(
                    data: IconThemeData(
                        color: Theme.of(context).colorScheme.onSurface),
                    child: Row(children: [
                      // TODO Disable purchase button when lifetime activated or not logged in
                      Expanded(
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              invokePurchase(1);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(_products[1].title,
                                    style: const TextStyle(fontSize: 22)),
                                Text(_products[1].price,
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              invokePurchase(2);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(_products[2].title,
                                    style: const TextStyle(fontSize: 22)),
                                Text(_products[2].price,
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: Theme.of(context).colorScheme.primary,
                          child: InkWell(
                            onTap: () async {
                              invokePurchase(0);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _products[0].title,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                                Text(
                                  _products[0].price,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
        ),
        if (_purchasePending)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // Block interactions
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // DO NOT USE THIS IN PRODUCTION. This is just for demo purpose.
  void _cleanTransanctions() async {
    var transactions = await SKPaymentQueueWrapper().transactions();

    transactions.forEach((skPaymentTransactionWrapper) {
      SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
    });
  }

  DataRow _buildDataRow(List<String> items) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            items[0],
          ),
        ),
        ...items
            .sublist(
          1,
        )
            .map((item) {
          return DataCell(
            Center(
                child: Text(
              item,
              textAlign: TextAlign.center,
            )),
          );
        }).toList()
      ],
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
