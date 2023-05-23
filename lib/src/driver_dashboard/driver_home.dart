// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, dead_code, unrelated_type_equality_checks, prefer_is_empty, use_build_context_synchronously, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
String? userName;
int ratingVal = 0;

class _DriverHomeState extends State<DriverHome> {
  final PaymentController controller = Get.put(PaymentController());
  final ratingController = TextEditingController();
  String? status;
  String docId = "";
  final CollectionReference _jobs =
      FirebaseFirestore.instance.collection('Jobs');
  final CollectionReference _drivers =
      FirebaseFirestore.instance.collection('Drivers');
  final CollectionReference _mechanics =
      FirebaseFirestore.instance.collection('Mechanics');

  Future getStatus() async {
    QuerySnapshot requestsQuery = await _jobs
        .where("driverEmail", isEqualTo: userEmail)
        .where("jobRequestStatus", whereIn: [
      "requested",
      "accepted",
      "completed",
      "completed/paid"
    ]).get();

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
      } else if (document['jobRequestStatus'] == 'completed/paid') {
        status = "completed/paid";
        docId = requestsQuery.docs.first.id;
      } else {
        status = "";
      }
    }

    //--------------------get user's name--------------------------

    QuerySnapshot driverQuery =
        await _drivers.where("email", isEqualTo: userEmail).get();

    if (driverQuery.docs.isNotEmpty) {
      userName = await driverQuery.docs.first['fname'];
    }
    if (mounted) {
      setState(() {});
    }
  }

  void setRating() async {
    QuerySnapshot ratingQuery = await _jobs
        .where("mechanicEmail", isEqualTo: mecEmail)
        .where("jobRequestStatus", isEqualTo: "completed/paid/rated")
        .get();

    var length = ratingQuery.docs.length;
    num ratingTotal = 0;
    for (var document in ratingQuery.docs) {
      ratingTotal = ratingTotal + document['rating'];
      print(ratingTotal);
    }

    var tempRating = (ratingTotal / length);

    //---------------------------------------------------

    QuerySnapshot mechanicQuery =
        await _mechanics.where("email", isEqualTo: mecEmail).get();

    String tempMecId;
    if (mechanicQuery.docs.isNotEmpty) {
      tempMecId = mechanicQuery.docs.first.id;

      _mechanics.doc(tempMecId).update({
        "rating": tempRating,
      });
    }
  }

  @override
  void dispose() {
    ratingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getStatus();
    ratingVal = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavDriverWidget(),
      body: userName == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          'Hello... Welcome back $userName',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Gabriela-Regular",
                            color: Color.fromARGB(255, 3, 48, 85),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder(
                      stream: _jobs
                          .where("driverEmail", isEqualTo: userEmail)
                          .where("jobRequestStatus", whereIn: [
                        "requested",
                        "accepted",
                        "completed",
                        "completed/paid"
                      ]).snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.length > 0) {
                            if (snapshot.data!.docs[0]['jobRequestStatus'] ==
                                'requested') {
                              getStatus();
                              return jobRequestWidget(context);
                            } else if (snapshot.data!.docs[0]
                                    ['jobRequestStatus'] ==
                                'accepted') {
                              getStatus();
                              return currentJobWidget(context);
                            } else if (snapshot.data!.docs[0]
                                    ['jobRequestStatus'] ==
                                'completed') {
                              getStatus();
                              return paymentWidget(size, context);
                            } else if (snapshot.data!.docs[0]
                                    ['jobRequestStatus'] ==
                                'completed/paid') {
                              getStatus();
                              return ratingWidget(size, context);
                            } else {
                              getStatus();
                              return getAssistance(size, context);
                            }
                          } else {
                            getStatus();
                            return getAssistance(size, context);
                          }
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    previousJobsWidget(context),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        chatAdminWidget(context),
                        SizedBox(
                          width: 25,
                        ),
                        profileWidget(context),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  //---------------------------------------------------------------

  Widget chatAdminWidget(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () =>
          GoRouter.of(context).go('/driver/chatWithAdmin/$userName-admin'),
      child: Container(
        height: size.height * 0.15,
        width: size.width * 0.4,
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
            SizedBox(height: size.height * 0.0015),
            Text(
              'Chat Admin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gabriela-Regular',
              ),
            ),
            SizedBox(height: size.height * 0.0015),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0),
                    bottom: Radius.circular(20),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/chatAdmin.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //-------------------------------------------------------------

  Widget profileWidget(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => GoRouter.of(context).go('/driver/driverProfile'),
      child: Container(
        height: size.height * 0.15,
        width: size.width * 0.4,
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
            SizedBox(height: size.height * 0.0015),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gabriela-Regular',
              ),
            ),
            SizedBox(height: size.height * 0.0015),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0),
                    bottom: Radius.circular(20),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/profile1.png'),
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //------------------------------------------------------------

  Widget previousJobsWidget(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => GoRouter.of(context).go('/driver/jobHistoryDriver'),
      child: Container(
        height: size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.blue,
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
            SizedBox(height: size.height * 0.01),
            Text(
              'Job History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gabriela-Regular',
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0),
                    bottom: Radius.circular(20),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/previousJobs.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Canceled Job Request.'),
                          backgroundColor: Colors.green,
                        ),
                      );
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Canceled the job.'),
                          backgroundColor: Colors.green,
                        ),
                      );
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
            height: size.height * 0.20,
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
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _jobs
                            .doc(docId)
                            .update({"jobRequestStatus": "completed/paid"});
                      },
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          side: BorderSide(width: 3, color: Colors.green),
                          elevation: 15),
                      child: Text('Pay by Cash'),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.makePayment(
                            amount: fee.toString(),
                            currency: 'LKR',
                            context: context);
                      },
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          side: BorderSide(width: 3, color: Colors.blue),
                          elevation: 15),
                      child: Text('Pay by Card'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------

  Widget ratingWidget(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.6,
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
                  image: AssetImage('assets/images/rating.jpg'),
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
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  'Rate your previous job with mecName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                RatingBar(
                  ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      half: Icon(
                        Icons.star,
                        color: Colors.grey,
                      ),
                      empty: Icon(
                        Icons.star,
                        color: Colors.grey,
                      )),
                  updateOnDrag: true,
                  onRatingUpdate: (rating) {
                    //print(rating);
                    ratingVal = rating.toInt();
                  },
                ),
                Text('Rating: $ratingVal'),
                SizedBox(height: 15),
                TextFormField(
                  controller: ratingController,
                  minLines: 4,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Give your feedback...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _jobs.doc(docId).update({
                          "jobRequestStatus": "completed/paid/skippedRating",
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          side: BorderSide(width: 3, color: Colors.blue),
                          elevation: 15),
                      child: Text('Skip'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        //print(ratingController.text);
                        try {
                          await _jobs.doc(docId).update({
                            "jobRequestStatus": "completed/paid/rated",
                            "rating": ratingVal,
                            "feedback": ratingController.text
                          });
                          setRating();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully Rated'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          side: BorderSide(width: 3, color: Colors.blue),
                          elevation: 15),
                      child: Text('Submit'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
