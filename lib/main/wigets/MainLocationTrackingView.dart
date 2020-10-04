import 'package:flutter/material.dart';

class MainLocationTrackingView extends StatelessWidget {
  const MainLocationTrackingView({
    Key key,
    @required String landmarkName,
    @required int distance,
  }) : _landmarkName = landmarkName, _distance = distance, super(key: key);

  final String _landmarkName;
  final int _distance;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white60,
        ),
        padding: EdgeInsets.all(20),
        child: Text(
          '${_landmarkName} 까지의 거리 ${_distance}m',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600
          ),
        )
    );
  }
}