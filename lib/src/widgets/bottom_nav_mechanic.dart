// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

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

class _BottomNavMechanicWidgetState extends State<BottomNavMechanicWidget> {
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
                  GoRouter.of(context).go('/driver');
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
