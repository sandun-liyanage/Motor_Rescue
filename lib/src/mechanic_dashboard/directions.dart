// ignore_for_file: prefer_const_constructors, unused_field, avoid_function_literals_in_foreach_calls, unused_import, await_only_futures, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motor_rescue/.env.dart';

class Directions extends StatefulWidget {
  const Directions({super.key});

  @override
  State<Directions> createState() => _DirectionsState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final String? userEmail = auth.currentUser!.email;
double? lat = 0;
double? lng = 0;

LatLng destination = LatLng(0, 0);

class _DirectionsState extends State<Directions> {
  final Completer<GoogleMapController> _controller = Completer();

  final CollectionReference _jobs =
      FirebaseFirestore.instance.collection('Jobs');

  void getDriverLocation() async {
    lat = await 0;
    lng = await 0;
    QuerySnapshot requestsQuery = await _jobs
        .where("mechanicEmail", isEqualTo: userEmail)
        .where("jobRequestStatus", isEqualTo: "accepted")
        .get();

    if (requestsQuery.docs.isNotEmpty) {
      lat = await requestsQuery.docs.first['latitude'].toDouble();
      lng = await requestsQuery.docs.first['longitude'].toDouble();
      destination = await LatLng(lat!, lng!);
    }
  }

  //LatLng destination = LatLng(lat!, lng!);

  List<LatLng> polylineCordinates = [];
  LocationData? currentLocation;
  LocationData? sourceLocation;
  int poly = 0;

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) async {
      currentLocation = await location;
      sourceLocation = await location;

      getPolyPoints();
    });

    //GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLocation) async {
        currentLocation = newLocation;

        QuerySnapshot requestsQuery = await _jobs
            .where("mechanicEmail", isEqualTo: userEmail)
            .where("jobRequestStatus", isEqualTo: "accepted")
            .get();

        if (requestsQuery.docs.isNotEmpty) {
          final json = {
            'mechanicLat': newLocation.latitude,
            'mechanicLng': newLocation.longitude,
          };

          var docId = await requestsQuery.docs.first.id;

          await _jobs.doc(docId).update(json);
        }

        /*googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 15,
              target: LatLng(
                newLocation.latitude!,
                newLocation.longitude!,
              ),
            ),
          ),
        );*/

        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void getPolyPoints() async {
    if (lat != 0) {
      PolylinePoints polylinePoints = await PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDMIuR2nZ9hKQzZCy6dWJjvwdO-wm3zyOM",
        PointLatLng(sourceLocation!.latitude!, sourceLocation!.longitude!),
        PointLatLng(destination.latitude, destination.longitude),
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
    getDriverLocation();
    getCurrentLocation();
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
              sourceLocation == null ||
              lat == 0 ||
              poly == 0
          ? Center(child: const Text('Loading'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
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
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: MarkerId('source'),
                  position: LatLng(
                      sourceLocation!.latitude!, sourceLocation!.longitude!),
                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: destination,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
