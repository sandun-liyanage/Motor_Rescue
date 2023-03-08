// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingWidget extends StatefulWidget {
  const LandingWidget({super.key});

  @override
  State<LandingWidget> createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/bgimg.jpg"),
            //   fit: BoxFit.cover,
            // ),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.topCenter,
            //   colors: const [
            //     Colors.blue,
            //     Colors.white,
            //   ],
            // ),
            ),
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.025),
              const Text(
                "\nMotor Rescue",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Gabriela-Regular",
                ),
              ),
              const Text(
                "Expert Hands, Expert Solutions\n\n",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Gabriela-Regular",
                ),
              ),
              Image(
                image: AssetImage("assets/images/icon.png"),
                fit: BoxFit.cover,
                height: size.height * 0.4,
              ),
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        height: 50,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "     Continue as     ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        height: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Material(
                      color: Colors.blue,
                      elevation: 20,
                      borderRadius: BorderRadius.circular(30),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        splashColor: Colors.black,
                        onTap: () => GoRouter.of(context).go('/driverLogin'),
                        child: Column(
                          children: [
                            Ink.image(
                              image: const AssetImage(
                                  'assets/images/driverIcon.jpg'),
                              height: size.height * 0.12,
                              width: size.width * 0.35,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Driver',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Material(
                      color: Colors.blue,
                      elevation: 20,
                      borderRadius: BorderRadius.circular(30),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        splashColor: Colors.black,
                        onTap: () => GoRouter.of(context).go('/mechanicLogin'),
                        child: Column(
                          children: [
                            Ink.image(
                              image: const AssetImage(
                                  'assets/images/mechanicIcon.jpg'),
                              height: size.height * 0.12,
                              width: size.width * 0.35,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Mechanic',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
