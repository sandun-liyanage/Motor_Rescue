// ignore_for_file: prefer_const_constructors, unused_field, avoid_function_literals_in_foreach_calls, unused_import, avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motor_rescue/.env.dart';

class Directions extends StatefulWidget {
  const Directions({super.key});

  @override
  State<Directions> createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(6.9286, 79.8451);
  static const LatLng destination = LatLng(6.9368, 79.8525);

  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print('sssss');
      print(position);
    }).catchError((e) {
      debugPrint(e);
      print('errrrrrrr');
    });
  }

  List<LatLng> polylineCordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDMIuR2nZ9hKQzZCy6dWJjvwdO-wm3zyOM",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
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
    _getCurrentPosition();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return CircularProgressIndicator();
    } else {
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
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
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
                  _currentPosition!.latitude, _currentPosition!.longitude),
            ),
            Marker(
              markerId: MarkerId('source'),
              position: sourceLocation,
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
}
