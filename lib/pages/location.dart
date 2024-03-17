import 'package:flutter/material.dart';
import 'package:women_safety_app/pages/appbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  GoogleMapController? _mapController;

  // Define initial camera position (you can set it to a specific location)
  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco, CA as an example
    zoom: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Location'),
            ),
          ],
        ),
      ),
    );
  }
}
