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

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      sourceLocation = location;

      getPolyPoints();
    });

    //GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLocation) {
        currentLocation = newLocation;

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
      body: currentLocation == null && sourceLocation == null
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
