// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motor_rescue/src/widgets/bottom_nav_driver.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavDriverWidget(),
      body: SingleChildScrollView(
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
                    'Hello... Welcome back Sandun',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gabriela-Regular",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                            image:
                                AssetImage('assets/images/getAssistance.jpg'),
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
                              GoRouter.of(context)
                                  .go('/driver/nearestMechanics');
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
                            child: Text('Get Assistance'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Tips',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Gabriela-Regular",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
