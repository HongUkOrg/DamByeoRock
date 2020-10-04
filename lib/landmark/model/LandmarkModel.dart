
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandmarkModel {
  String name;
  LatLng latLng;

  LandmarkModel({this.name, this.latLng});

  static LandmarkModel defaultModel = LandmarkModel(name: '연세대학교', latLng: LatLng(37.560041, 126.936924));
}