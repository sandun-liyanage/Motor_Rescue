// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, use_build_context_synchronously, avoid_print, avoid_init_to_null, unrelated_type_equality_checks, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_mechanic.dart';

class MechanicHome extends StatefulWidget {
  const MechanicHome({super.key});

  @override
  State<MechanicHome> createState() => _MechanicHomeState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;
String? status;
String docId = "";

class _MechanicHomeState extends State<MechanicHome> {
  final CollectionReference _jobs =
      FirebaseFirestore.instance.collection('Jobs');

  Future getStatus() async {
    QuerySnapshot requestsQuery = await _jobs
        .where("mechanicEmail", isEqualTo: userEmail)
        .where("jobRequestStatus", whereIn: ["requested", "accepted"]).get();

    for (var document in requestsQuery.docs) {
      // status = document['jobRequestStatus'];
      // docId = document.id;
      if (document['jobRequestStatus'] == 'requested' ||
          document['jobRequestStatus'] == "") {
        status = "requested";
        docId = requestsQuery.docs.first.id;
      } else if (document['jobRequestStatus'] == 'accepted') {
        status = "accepted";
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
      bottomNavigationBar: BottomNavMechanicWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
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
                      fontFamily: 'Gabriela-Regular',
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              FutureBuilder(
                future: getStatus(),
                builder: (BuildContext context, snapshot) {
                  if (status == 'requested') {
                    return jobRequestWidget(context);
                  } else if (status == 'accepted') {
                    return currentJobWidget(context);
                  } else {
                    return emptyJobWidget(context);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              // Center(
              //   child: status == 'null'
              //       ? jobRequestWidget(context)
              //       : status == 'accepted'
              //           ? currentJobWidget(context)
              //           : emptyJobWidget(context),
              // )

              // jobRequestWidget(context),
              // SizedBox(height: size.height * 0.01),
              //currentJobWidget(context),
            ],
          ),
        ),
      ),
    );
  }

//---------------------------------------------------------------------------

  Widget jobRequestWidget(BuildContext context) {
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
            'New Job Request - 5KM away...',
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
                    //
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
                            'Chat With Driver',
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
                        "jobRequestStatus": "accepted",
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
                        Icon(Icons.done, size: 40, color: Colors.green),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            'Accept the Job',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
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
                        "jobRequestStatus": "declined",
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
                            'Decline the Job',
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
            'Current Job',
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
                    //
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
                            'Chat With Driver',
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
                    GoRouter.of(context).go('/mechanic/directions');
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
                        Icon(Icons.navigation, size: 40, color: Colors.blue),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            'Get Directions',
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
                        "jobRequestStatus": "completed",
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
                        Icon(Icons.done, size: 40, color: Colors.green),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 90),
                          child: Text(
                            'Job Completed',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
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

  //-------------------------------------------------------------------------

  Widget emptyJobWidget(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.35,
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
            'No jobs at the moment   :(',
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
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Check again in few minutes',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: BorderSide(width: 3, color: Colors.blue),
                      elevation: 15),
                  child: Text(
                    'Refresh',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
