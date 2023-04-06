// ignore_for_file: camel_case_types, must_be_immutable, library_private_types_in_public_api, no_logic_in_create_state, prefer_final_fields, prefer_const_constructors, avoid_print, sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class messages extends StatefulWidget {
  String id;
  messages({super.key, required this.id});
  @override
  _messagesState createState() => _messagesState(id: id);
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;

final CollectionReference _messages =
    FirebaseFirestore.instance.collection('Messages');
final CollectionReference _drivers =
    FirebaseFirestore.instance.collection('Drivers');
final CollectionReference _mechanics =
    FirebaseFirestore.instance.collection('Mechanics');
String name = "Kevin";

class _messagesState extends State<messages> {
  String id;
  _messagesState({required this.id});

  void getName() async {
    String tempEmail;
    QuerySnapshot messageQuery = await _messages
        .where("id", isEqualTo: id)
        .where("email", isNotEqualTo: "$userEmail")
        .get();

    if (messageQuery.docs.isNotEmpty) {
      tempEmail = messageQuery.docs.first['email'];

      QuerySnapshot driverQuery =
          await _drivers.where("email", isEqualTo: tempEmail).get();
      if (driverQuery.docs.isNotEmpty) {
        name = driverQuery.docs.first['fname'];
      }

      QuerySnapshot mechanicQuery =
          await _mechanics.where("email", isEqualTo: tempEmail).get();
      if (mechanicQuery.docs.isNotEmpty) {
        name = mechanicQuery.docs.first['fname'];
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Messages')
          .where("id", isEqualTo: id)
          .orderBy('time')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text("something is wrong ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            name == 'Kevin') {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemBuilder: (_, index) {
            QueryDocumentSnapshot qs = snapshot.data!.docs[index];
            Timestamp t = qs['time'];
            DateTime d = t.toDate();
            print(d.toString());
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: userEmail == qs['email']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.purple,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        qs['email'] == userEmail ? "You" : name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              qs['message'],
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            d.hour.toString() + ":" + d.minute.toString(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
