// ignore_for_file: prefer_const_constructors, unused_field, avoid_function_literals_in_foreach_calls, unused_import, await_only_futures, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motor_rescue/.env.dart';

class LiveLocation extends StatefulWidget {
  const LiveLocation({super.key});

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;
double? lat = 1;
double? lng = 1;

String? docId;
LocationData? destination;

List<LatLng> polylineCordinates = [];
LatLng? currentLocation;
LatLng sourceLocation = LatLng(lat!, lng!);
int poly = 0;
int src = 0;

class _LiveLocationState extends State<LiveLocation> {
  final Completer<GoogleMapController> _controller = Completer();

  final CollectionReference _jobs =
      FirebaseFirestore.instance.collection('Jobs');
  final _database = FirebaseDatabase.instance.ref();

  void getMechanicLocation() async {
    lat = await 0;
    lng = await 0;
    QuerySnapshot requestsQuery = await _jobs
        .where("driverEmail", isEqualTo: userEmail)
        .where("jobRequestStatus", isEqualTo: "accepted")
        .get();

    if (requestsQuery.docs.isNotEmpty) {
      lat = await requestsQuery.docs.first['mechanicLat'].toDouble();
      lng = await requestsQuery.docs.first['mechanicLng'].toDouble();
      sourceLocation = LatLng(lat!, lng!);
      src = 1;
      docId = await requestsQuery.docs.first.id;
      liveLocation();
    }
  }

  void liveLocation() async {
    QuerySnapshot requestsQuery = await _jobs
        .where("driverEmail", isEqualTo: userEmail)
        .where("jobRequestStatus", isEqualTo: "accepted")
        .get();

    if (requestsQuery.docs.isNotEmpty) {
      lat = await requestsQuery.docs.first['mechanicLat'].toDouble();
      lng = await requestsQuery.docs.first['mechanicLng'].toDouble();
      currentLocation = LatLng(lat!, lng!);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {});
      }
      liveLocation();
    });
    // if (mounted) {
    //   setState(() {});
    // }
    // liveLocation();
  }

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      destination = location;
      //currentLocation = location;
      //sourceLocation = location;

      getPolyPoints();
    });
  }

  void getPolyPoints() async {
    if (poly == 0) {
      PolylinePoints polylinePoints = await PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDMIuR2nZ9hKQzZCy6dWJjvwdO-wm3zyOM",
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination!.latitude!, destination!.longitude!),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach(
          (PointLatLng point) => polylineCordinates.add(
            LatLng(point.latitude, point.longitude),
          ),
        );
        if (mounted) {
          setState(() {});
        }
        poly = 1;
      } else {
        getPolyPoints();
      }
    } else {
      getPolyPoints();
    }
  }

  void setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/mechanicIcon.jpg")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    getMechanicLocation();
    liveLocation();
    getLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff24688e)),
        toolbarHeight: 75,
        leadingWidth: 75,
      ),
      body: currentLocation == null ||
              sourceLocation.latitude == 1 ||
              lat == 0 ||
              lat == 1 ||
              poly == 0 ||
              src == 0
          ? Center(child: const Text('Loading'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(destination!.latitude!, destination!.longitude!),
                zoom: 15,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: polylineCordinates,
                  color: Colors.blue,
                  width: 6,
                )
              },
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  icon: currentLocationIcon,
                  position: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude),
                ),
                Marker(
                  markerId: MarkerId('source'),
                  position:
                      LatLng(sourceLocation.latitude, sourceLocation.longitude),
                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position:
                      LatLng(destination!.latitude!, destination!.longitude!),
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
