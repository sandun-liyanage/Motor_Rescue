import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:motor_rescue/src/auth/driver_login.dart';
import 'package:motor_rescue/src/auth/driver_signup.dart';
import 'package:motor_rescue/src/auth/mechanic_login.dart';
import 'package:motor_rescue/src/auth/mechanic_signup.dart';
import 'package:motor_rescue/src/driver_dashboard/driver_home.dart';
import 'package:motor_rescue/src/driver_dashboard/driver_profile.dart';
import 'package:motor_rescue/src/driver_dashboard/edit_driver_profile.dart';
import 'package:motor_rescue/src/driver_dashboard/live_location.dart';
import 'package:motor_rescue/src/driver_dashboard/nearest_mechanics.dart';
import 'package:motor_rescue/src/landing.dart';
import 'package:motor_rescue/src/live_chat/chat_page.dart';
import 'package:motor_rescue/src/live_chat_admin/chat_page.dart';
import 'package:motor_rescue/src/mechanic_dashboard/directions.dart';
import 'package:motor_rescue/src/mechanic_dashboard/edit_mechanic_profile.dart';
import 'package:motor_rescue/src/mechanic_dashboard/job_hostory_mec.dart';
import 'package:motor_rescue/src/mechanic_dashboard/mechanic_home.dart';
import 'package:motor_rescue/src/mechanic_dashboard/mechanic_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51Mr31YGofsKhWmKackjWPBQjWw9k2xEdtmmbu7aqrT35zgeUflXAduPtVIfhHgrQjZccYxfu2n3Czad6qczuE6oo00sjYZikuB";
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
          path: 'driver',
          builder: (context, state) => const DriverHome(),
          routes: [
            GoRoute(
              path: 'nearestMechanics',
              builder: (context, state) => const NearestMechanics(),
            ),
            GoRoute(
              path: 'liveLocation',
              builder: (context, state) => const LiveLocation(),
            ),
            GoRoute(
              path: 'chatWithMechanic/:id',
              builder: (context, state) {
                final id = state.params['id'];
                return chatpage(id: id!);
              },
            ),
            GoRoute(
              path: 'chatWithAdmin/:id',
              builder: (context, state) {
                final id = state.params['id'];
                return chatpage1(id: id!);
              },
            ),
            GoRoute(
              path: 'driverProfile',
              builder: (context, state) => const DriverProfile(),
              routes: [
                GoRoute(
                  path: 'editDriverProfile',
                  builder: (context, state) => const EditDriverProfile(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'mechanic',
          builder: (context, state) => const MechanicHome(),
          routes: [
            GoRoute(
              path: 'directions',
              builder: (context, state) => const Directions(),
            ),
            GoRoute(
              path: 'chatWithDriver/:id',
              builder: (context, state) {
                final id = state.params['id'];
                return chatpage(id: id!);
              },
            ),
            GoRoute(
              path: 'chatWithAdmin/:id',
              builder: (context, state) {
                final id = state.params['id'];
                return chatpage1(id: id!);
              },
            ),
            GoRoute(
              path: 'mechanicProfile',
              builder: (context, state) => const MechanicProfile(),
              routes: [
                GoRoute(
                  path: 'editMechanicProfile',
                  builder: (context, state) => const EditMechanicProfile(),
                ),
              ],
            ),
            GoRoute(
              path: 'jobHistoryMechanic',
              builder: (context, state) => const JobHistoryMechanic(),
            ),
          ],
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
