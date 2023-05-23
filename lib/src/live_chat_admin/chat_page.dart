// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, camel_case_types, library_private_types_in_public_api, no_logic_in_create_state, must_be_immutable, body_might_complete_normally_nullable, use_key_in_widget_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message.dart';

class chatpage1 extends StatefulWidget {
  String id;
  chatpage1({required this.id});
  @override
  _chatpage1State createState() => _chatpage1State(id: id);
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;

final CollectionReference _drivers =
    FirebaseFirestore.instance.collection('Drivers');
final CollectionReference _mechanics =
    FirebaseFirestore.instance.collection('Mechanics');

class _chatpage1State extends State<chatpage1> {
  String id;
  _chatpage1State({required this.id});

  final fs = FirebaseFirestore.instance;
  final TextEditingController message = TextEditingController();

  var collectionName = '';
  var docId = '';
  void getName() async {
    QuerySnapshot driverQuery =
        await _drivers.where("email", isEqualTo: userEmail).get();
    if (driverQuery.docs.isNotEmpty) {
      collectionName = "Drivers";
      docId = driverQuery.docs.first.id;
    }

    QuerySnapshot mechanicQuery =
        await _mechanics.where("email", isEqualTo: userEmail).get();
    if (mechanicQuery.docs.isNotEmpty) {
      collectionName = "Mechanics";
      docId = mechanicQuery.docs.first.id;
    }
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat With Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 177, 202, 221),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff24688e)),
        toolbarHeight: 65,
        leadingWidth: 75,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: messages(
                id: id,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple[100],
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs.collection('messages-admin').doc().set({
                        'text': message.text.trim(),
                        'createdAt': DateTime.now(),
                        'user': userEmail,
                        'id': id,
                      });

                      fs.collection(collectionName).doc(docId).update({
                        'read': 'false',
                      });

                      print(collectionName);

                      message.clear();
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
