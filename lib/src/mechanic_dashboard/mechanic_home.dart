// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_mechanic.dart';

class MechanicHome extends StatelessWidget {
  const MechanicHome({super.key});

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
              jobRequestWidget(context),
              SizedBox(height: size.height * 0.01),
              currentJobWidget(context),
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
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.01,
                      vertical: size.height * 0.01,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.chat, size: 40),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          'Chat With Driver',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.025),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.01,
                      vertical: size.height * 0.01,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.done,
                        size: 40,
                        color: Colors.green,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          'Accept the Job',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.025),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.01,
                      vertical: size.height * 0.01,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.close,
                        size: 40,
                        color: Colors.red,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          'Decline the Job',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
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
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.01,
                      vertical: size.height * 0.01,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.chat, size: 40),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          'Chat With Driver',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.025),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/mechanic/directions');
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.01,
                      vertical: size.height * 0.01,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.navigation,
                        size: 40,
                        color: Colors.blue,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          'Driver Location',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.025),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.01,
                      vertical: size.height * 0.01,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.red,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          'Complete the Job',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
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
