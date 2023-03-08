// ignore_for_file: prefer_const_constructors

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bgimg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 70),
              Image(
                image: AssetImage("assets/images/landing.png"),
                fit: BoxFit.cover,
                height: size.height * 0.25,
              ),
              const Text(
                "\nMotor Rescue",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "\nExpert Hands, Expert Solutions\n\n",
                style: TextStyle(
                  fontSize: 20,
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
