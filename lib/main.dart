import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motor_rescue/src/auth/driver_login.dart';
import 'package:motor_rescue/src/landing.dart';

void main() => runApp(const MyApp());

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
