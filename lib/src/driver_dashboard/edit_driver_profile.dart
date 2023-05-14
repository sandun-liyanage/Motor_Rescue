// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav_driver.dart';

class EditDriverProfile extends StatefulWidget {
  const EditDriverProfile({super.key});

  @override
  State<EditDriverProfile> createState() => _EditDriverProfileState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;
String? userFname;
String? userLname;
String? userAddress;
String? userPhone;

final fnameController = TextEditingController();
final lnameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final addressController = TextEditingController();
final phoneController = TextEditingController();

final _formKey = GlobalKey<FormState>();

class _EditDriverProfileState extends State<EditDriverProfile> {
  final CollectionReference _drivers =
      FirebaseFirestore.instance.collection('Drivers');

  Future<void> _editDetails(BuildContext context) async {
    QuerySnapshot driverQuery =
        await _drivers.where("email", isEqualTo: userEmail).get();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String tempId;
      if (driverQuery.docs.isNotEmpty) {
        tempId = driverQuery.docs.first.id;

        await _drivers.doc(tempId).update({
          "fname":
              fnameController.text == "" ? userFname : fnameController.text,
          'lname':
              lnameController.text == "" ? userLname : lnameController.text,
          'address': addressController.text == ""
              ? userAddress
              : addressController.text,
          'phone': phoneController.text == "" ? userPhone : phoneController.text
        });

        GoRouter.of(context).go('/driver');
      }
    }
  }

  //----------------------------------------------

  Future getStatus() async {
    //--------------------get user's details--------------------------

    QuerySnapshot driverQuery =
        await _drivers.where("email", isEqualTo: userEmail).get();

    if (driverQuery.docs.isNotEmpty) {
      userFname = await driverQuery.docs.first['fname'];
      userLname = await driverQuery.docs.first['lname'];
      userAddress = await driverQuery.docs.first['address'];
      userPhone = await driverQuery.docs.first['phone'];
    }
    if (mounted) {
      setState(() {});
    }
  }

  //----------------------------------------------

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff24688e)),
        toolbarHeight: 75,
        leadingWidth: 75,
      ),
      bottomNavigationBar: BottomNavDriverWidget(),
      body: userFname == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabriela-Regular',
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Change the details you want to update and submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(child: buildFirstName()),
                            SizedBox(width: size.width * 0.03),
                            Flexible(child: buildLastName()),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),
                        buildAddress(),
                        SizedBox(height: size.height * 0.03),
                        buildPhone(),
                        SizedBox(height: size.height * 0.03),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () => _editDetails(context),
                            child: const Text(
                              'Update Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

//-----------------------------------------------------------------

Widget buildFirstName() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        height: 60,
        child: TextField(
          controller: fnameController,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.person,
              color: Color(0xff5ac18e),
              size: 30,
            ),
            hintText: '$userFname',
          ),
        ),
      ),
    ],
  );
}

//-----------------------------------------------------------

Widget buildLastName() {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        height: 60,
        child: TextField(
          controller: lnameController,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              null,
              color: Color(0xff5ac18e),
              size: 30,
            ),
            hintText: '$userLname',
          ),
        ),
      ),
    ],
  );
}

//-----------------------------------------------------------

Widget buildEmail() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        height: 60,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.email,
              color: Color(0xff5ac18e),
              size: 30,
            ),
            hintText: 'Email',
          ),
        ),
      ),
    ],
  );
}

//------------------------------------------------------

Widget buildPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        height: 60,
        child: TextField(
          obscureText: true,
          controller: passwordController,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.lock,
              color: Color(0xff5ac18e),
              size: 30,
            ),
            hintText: 'Password',
          ),
        ),
      ),
    ],
  );
}

//-----------------------------------------------------

Widget buildAddress() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        height: 60,
        child: TextField(
          controller: addressController,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.house,
              color: Color(0xff5ac18e),
              size: 30,
            ),
            hintText: '$userAddress',
          ),
        ),
      ),
    ],
  );
}

//------------------------------------------------------

Widget buildPhone() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        height: 60,
        child: TextField(
          keyboardType: TextInputType.phone,
          controller: phoneController,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              Icons.phone,
              color: Color(0xff5ac18e),
              size: 30,
            ),
            hintText: '$userPhone',
          ),
        ),
      ),
    ],
  );
}

//----------------------------------------------------
