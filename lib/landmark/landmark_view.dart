
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/landmark/model/landmark.dart';

class LandmarkView extends StatelessWidget {

  LandmarkModel landmarkModel;

  LandmarkView(this.landmarkModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          Center(
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                  child: Icon(Icons.home)
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                '${landmarkModel.name} 담벼락\n${landmarkModel.latLng.latitude}, ${landmarkModel.latLng.longitude}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.blue
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
