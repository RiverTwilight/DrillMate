import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:hgeology_app/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ApiResponse<T> {
  final bool status;
  final String message;
  final T? data;

  ApiResponse({required this.status, this.message = '', this.data});
}

class PurchaseProvider {
  final client = Supabase.instance.client;

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    var purchaseID = purchaseDetails.purchaseID;

    if (purchaseDetails is AppStorePurchaseDetails) {
      final originalTransaction = purchaseDetails.skPaymentTransaction;
      purchaseID = originalTransaction.transactionIdentifier;
    } else {
      // TODO android
    }

    Map<String, dynamic> verifyData = {
      'transactionId': purchaseID,
      'uid': AuthProvider().user!.id,
      'productId': purchaseDetails.productID,
      'receipt': purchaseDetails.verificationData.serverVerificationData,
      'sandbox': false,
    };

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(verifyBackupKey, json.encode(verifyData));

    final res = await client.functions.invoke(
      'verifyPurchase',
      body: verifyData,
    );

    if (res.status == 200) {
      await prefs.remove(verifyBackupKey);

      return true;
    }

    return false;
  }

  Future<ApiResponse> redeemCode(String code) async {
    try {
      final res = await client.functions.invoke(
        'redeemPromoCode',
        body: {
          'code': code,
          'uid': AuthProvider().user!.id,
        },
      );

      if (res.status == 200) {
        // Assume res.data contains any data you might want to pass along
        return ApiResponse(
            status: true, message: res.data['message'], data: res.data);
      }

      return ApiResponse(status: false, message: res.data['message']);
    } catch (e) {
      return ApiResponse(status: false, message: e.toString());
    }
  }
}
