// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavMechanicWidget extends StatefulWidget {
  const BottomNavMechanicWidget({super.key});

  @override
  State<BottomNavMechanicWidget> createState() =>
      _BottomNavMechanicWidgetState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;

final CollectionReference _drivers =
    FirebaseFirestore.instance.collection('Mechanics');

String? userName;

class _BottomNavMechanicWidgetState extends State<BottomNavMechanicWidget> {
  //--------------------get user's name--------------------------

  Future getChat(BuildContext context) async {
    QuerySnapshot driverQuery =
        await _drivers.where("email", isEqualTo: userEmail).get();

    if (driverQuery.docs.isNotEmpty) {
      userName = await driverQuery.docs.first['fname'];
    }

    if (userName != null) {
      GoRouter.of(context).go('/mechanic/chatWithAdmin/$userName-admin');
    } else {
      getChat(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GNav(
            backgroundColor: Colors.blue,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue.shade700,
            padding: EdgeInsets.all(10),
            gap: 5,
            onTabChange: (index) {
              switch (index) {
                case 0:
                  GoRouter.of(context).go('/mechanic');
                  break;
                case 1:
                  getChat(context);
                  break;
                case 2:
                  GoRouter.of(context).go('/mechanic/directions');
                  break;
                case 3:
                  if (mounted) {
                    GoRouter.of(context).go('/driver');
                    //Navigator.of(context).pop();
                    //context.pop();
                  }
                  FirebaseAuth.instance.signOut();

                  break;
                default:
                  GoRouter.of(context).go('/mechanic');
              }
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconSize: 30,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GButton(
                icon: Icons.support_agent,
                text: 'Contact Us',
                iconSize: 30,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                iconSize: 30,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GButton(
                icon: Icons.logout,
                text: 'Logout',
                iconSize: 30,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class BottomNavMechanicWidget extends StatelessWidget {
//   const BottomNavMechanicWidget({
//     super.key,
//   });

//   @override
  
// }
