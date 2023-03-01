import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motor_rescue/src/auth/driver_login.dart';
import 'package:motor_rescue/src/auth/driver_signup.dart';
import 'package:motor_rescue/src/auth/mechanic_login.dart';
import 'package:motor_rescue/src/auth/mechanic_signup.dart';
import 'package:motor_rescue/src/driver_dashboard/driver_home.dart';
import 'package:motor_rescue/src/landing.dart';
import 'package:motor_rescue/src/mechanic_dashboard/mechanic_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingWidget(),
      routes: [
        GoRoute(
          path: 'driverLogin',
          builder: (context, state) => const DriverLogin(),
        ),
        GoRoute(
          path: 'driverSignup',
          builder: (context, state) => const DriverSignup(),
        ),
        GoRoute(
          path: 'mechanicLogin',
          builder: (context, state) => const MechanicLogin(),
        ),
        GoRoute(
          path: 'mechanicSignup',
          builder: (context, state) => const MechanicSignup(),
        ),
        GoRoute(
          path: 'driverHome',
          builder: (context, state) => const DriverHome(),
        ),
        GoRoute(
          path: 'mechanicHome',
          builder: (context, state) => const MechanicHome(),
        )
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'title here',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
