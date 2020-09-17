
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandmarkView extends StatelessWidget {

  LatLng latLng;

  LandmarkView(this.latLng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Landmark Here\n${latLng.latitude}, ${latLng.longitude}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.redAccent
          ),
        ),
      ),
    );
  }
}
