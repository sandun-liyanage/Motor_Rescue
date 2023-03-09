// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NearestMechanics extends StatefulWidget {
  const NearestMechanics({super.key});

  @override
  State<NearestMechanics> createState() => _NearestMechanicsState();
}

class _NearestMechanicsState extends State<NearestMechanics> {
  final CollectionReference _mechanics =
      FirebaseFirestore.instance.collection('Mechanics');
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
                            subtitle:
                                Text(documentSnapshot['phone'].toString()),
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

  // Stream<List<MechanicModel>> readMechanics() => FirebaseFirestore.instance
  //     .collection('Mechanics')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs
  //         .map((doc) => MechanicModel.fromJson(doc.data()))
  //         .toList());
}
