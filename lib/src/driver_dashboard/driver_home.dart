// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, dead_code, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:motor_rescue/src/controllers/payment_controller.dart';
import 'package:motor_rescue/src/widgets/bottom_nav_driver.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;
String? mecEmail;
String? driverEmail;
String? fee;

class _DriverHomeState extends State<DriverHome> {
  final PaymentController controller = Get.put(PaymentController());
  String? status;
  String docId = "";
  final CollectionReference _jobs =
      FirebaseFirestore.instance.collection('Jobs');

  Future getStatus() async {
    QuerySnapshot requestsQuery = await _jobs
        .where("driverEmail", isEqualTo: userEmail)
        .where("jobRequestStatus",
            whereIn: ["requested", "accepted", "completed"]).get();

    status = "";
    if (requestsQuery.docs.isNotEmpty) {
      mecEmail = requestsQuery.docs.first['mechanicEmail'];
      driverEmail = requestsQuery.docs.first['driverEmail'];
      fee = requestsQuery.docs.first['fee'];
    }

    for (var document in requestsQuery.docs) {
      if (document['jobRequestStatus'] == 'requested' ||
          document['jobRequestStatus'] == "") {
        status = "requested";
        docId = requestsQuery.docs.first.id;
      } else if (document['jobRequestStatus'] == 'accepted') {
        status = "accepted";
        docId = requestsQuery.docs.first.id;
      } else if (document['jobRequestStatus'] == 'completed') {
        status = "completed";
        docId = requestsQuery.docs.first.id;
      } else {
        status = "";
      }
    }
  }

  @override
  void initState() {
    getStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavDriverWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width * 0.5),
                  child: Text(
                    'Hello... Welcome back Sandun',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gabriela-Regular",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder(
                future: getStatus(),
                builder: (BuildContext context, snapshot) {
                  if (status == 'requested') {
                    return jobRequestWidget(context);
                  } else if (status == 'accepted') {
                    return currentJobWidget(context);
                  } else if (status == 'completed') {
                    return paymentWidget(size, context);
                  } else {
                    return getAssistance(size, context);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              //jobRequestWidget(context),
              //currentJobWidget(context),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Text(
              //     'Tips',
              //     style: TextStyle(
              //       fontSize: 25,
              //       fontWeight: FontWeight.bold,
              //       fontFamily: "Gabriela-Regular",
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------

  Widget getAssistance(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.33,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.7),

            blurRadius: 10,
            //offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: size.height * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: AssetImage('assets/images/getAssistance.jpg'),
                  fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.5),

                  blurRadius: 10,
                  //offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            //child: Image(image: AssetImage('assets/images/vBreakdown.png')),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'best mechanics in your area are ready help you...',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/driver/nearestMechanics');
                  },
                  style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: BorderSide(width: 3, color: Colors.blue),
                      elevation: 15),
                  child: Text('Get Assistance'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------

  Widget jobRequestWidget(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.7),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Text(
            'Assistance requested. waiting for a response from the mechanic...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gabriela-Regular',
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/jobRequest.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            //child: Image(image: AssetImage('assets/images/vBreakdown.png')),
          ),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    GoRouter.of(context)
                        .go('/driver/chatWithMechanic/$driverEmail-$mecEmail');
                    //setState(() {});
                  },
                  splashColor: Colors.grey.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.chat, size: 40, color: Colors.blue),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            'Chat With Mechanic',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.025),
                InkWell(
                  onTap: () {
                    try {
                      _jobs.doc(docId).update({
                        "jobRequestStatus": "canceled",
                      });
                      getStatus();
                      setState(() {});
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  splashColor: Colors.grey.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.close, size: 40, color: Colors.red),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            'Cancel the Request',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------------

  Widget currentJobWidget(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.425,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.7),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Text(
            'Your mechanic is on the way...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gabriela-Regular',
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: AssetImage('assets/images/jobRequest.jpg'),
                  fit: BoxFit.cover),
            ),
            //child: Image(image: AssetImage('assets/images/vBreakdown.png')),
          ),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    GoRouter.of(context)
                        .go('/driver/chatWithMechanic/$driverEmail-$mecEmail');
                  },
                  splashColor: Colors.grey.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.chat, size: 40, color: Colors.blue),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            'Chat With Mechanic',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.025),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).go('/driver/liveLocation');
                  },
                  splashColor: Colors.grey.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.pin_drop, size: 40, color: Colors.blue),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            "Mechanic's Location",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.025),
                InkWell(
                  onTap: () {
                    try {
                      _jobs.doc(docId).update({
                        "jobRequestStatus": "canceled",
                      });
                      setState(() {});
                      //getStatus();
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  splashColor: Colors.grey.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.close, size: 40, color: Colors.red),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            'Cancel the Job',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------

  Widget paymentWidget(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.33,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.7),

            blurRadius: 10,
            //offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: size.height * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: AssetImage('assets/images/payment.jpg'),
                  fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.5),

                  blurRadius: 10,
                  //offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            //child: Image(image: AssetImage('assets/images/vBreakdown.png')),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'You have a payment due for your previouse job.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.makePayment(
                        amount: fee.toString(),
                        currency: 'LKR',
                        context: context);
                  },
                  style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: BorderSide(width: 3, color: Colors.blue),
                      elevation: 15),
                  child: Text('Make Payment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
