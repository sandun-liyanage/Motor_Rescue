// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';

class NearestMechanics extends StatefulWidget {
  const NearestMechanics({super.key});

  @override
  State<NearestMechanics> createState() => _NearestMechanicsState();
}

LocationData? currentLocation;
String mecEmail = "";

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;

class _NearestMechanicsState extends State<NearestMechanics> {
  final CollectionReference _mechanics =
      FirebaseFirestore.instance.collection('Mechanics');
  final CollectionReference _jobs =
      FirebaseFirestore.instance.collection('Jobs');

  void getCurrentLocation() async {
    Location location = Location();

    await location.getLocation().then((location) {
      currentLocation = location;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff24688e)),
        toolbarHeight: 75,
        leadingWidth: 75,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Available mechanics near you',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Gabriela-Regular",
                  ),
                ),
              ),
              StreamBuilder(
                stream: _mechanics.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Card(
                          //margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(documentSnapshot['fname']),
                            subtitle: Text('Ratings: '),
                            onTap: () async {
                              QuerySnapshot requestsQuery = await _jobs
                                  .where("mechanicEmail",
                                      isEqualTo: documentSnapshot['email'])
                                  .where("jobRequestStatus",
                                      whereIn: ["requested", "accepted"]).get();

                              if (requestsQuery.docs.isEmpty) {
                                if (currentLocation != null &&
                                    userEmail != null) {
                                  print(currentLocation!.latitude);

                                  QuerySnapshot eventsQuery = await _mechanics
                                      .where("email",
                                          isEqualTo: documentSnapshot['email'])
                                      .get();

                                  for (var document in eventsQuery.docs) {
                                    mecEmail = document['email'];
                                  }
                                  print(mecEmail);
                                  print(userEmail);
                                  final json = {
                                    'driverEmail': userEmail,
                                    'mechanicEmail': mecEmail,
                                    'jobRequestStatus': 'requested',
                                    'latitude': currentLocation!.latitude,
                                    'longitude': currentLocation!.longitude,
                                  };
                                  await _jobs.doc().set(json);
                                }
                                GoRouter.of(context).push('/driver');
                              } else {
                                print('already sent request');
                              }
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
