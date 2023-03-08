// ignore_for_file: prefer_const_constructors, unused_field, avoid_function_literals_in_foreach_calls, unused_import, await_only_futures

import 'dart:async';

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

class _DirectionsState extends State<Directions> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng destination = LatLng(6.9368, 79.8525);

  List<LatLng> polylineCordinates = [];
  LocationData? currentLocation;
  LocationData? sourceLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      sourceLocation = location;

      getPolyPoints();
    });

    location.onLocationChanged.listen(
      (newLocation) {
        currentLocation = newLocation;

        //setState(() {});
        if (mounted) {
          setState(() {
            // Your state change code goes here
          });
        }
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDMIuR2nZ9hKQzZCy6dWJjvwdO-wm3zyOM",
      PointLatLng(sourceLocation!.latitude!, sourceLocation!.longitude!),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getCurrentLocation();

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
      body: currentLocation == null && sourceLocation == null
          ? Center(child: const Text('Loading'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13,
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
            ),
    );
  }
}
