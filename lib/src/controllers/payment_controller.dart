// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  String docId = "";
  String? mecEmail;
  String? driverEmail;
  final CollectionReference _jobs =
      FirebaseFirestore.instance.collection('Jobs');

  Future getDetails() async {
    QuerySnapshot requestsQuery = await _jobs
        .where("driverEmail", isEqualTo: userEmail)
        .where("jobRequestStatus", isEqualTo: "completed")
        .get();

    if (requestsQuery.docs.isNotEmpty) {
      docId = requestsQuery.docs.first.id;
      mecEmail = requestsQuery.docs.first['mechanicEmail'];
      driverEmail = requestsQuery.docs.first['driverEmail'];
    }
  }

  Future<bool> makePayment(
      {required String amount,
      required String currency,
      required BuildContext context}) async {
    try {
      await getDetails();
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          // applePay: true,
          // googlePay: true,
          // testEnv: true,
          // merchantCountryCode: 'US',
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));

        displayPaymentSheet(context);
      }
      return false;
    } catch (e, s) {
      print('exception:$e$s');
      return false;
    }
  }

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      _jobs.doc(docId).update({"jobRequestStatus": "completed/paid"});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment Successful.'),
          backgroundColor: Colors.green,
        ),
      );
      // Get.snackbar('Payment', 'Payment Successful',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //     margin: const EdgeInsets.all(10),
      //     duration: const Duration(seconds: 2));
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.error.localizedMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print("Unforeseen error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': 'driver: $driverEmail , mechanic: $mecEmail',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                "Bearer sk_test_51Mr31YGofsKhWmKaJksxcU5ItzlLAgJpcI9cT3xFHxMNY5Bynu6CDSiC3KhaZCg9ameU9vbnueKeJ4km4olD7ijQ00AQvcUU1N",
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
