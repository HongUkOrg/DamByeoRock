import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/repositories/Repositories.dart';
import 'package:wall/utils/Utils.dart';

part 'MainState.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  final WallRepository wallRepository = WallRepository();
  Set<Marker> markers = {};
  bool _locationPermissionGranted = false;
  BitmapDescriptor _landmarkIcon;

  Set<LandmarkModel> landmarkSet = {};
  LandmarkModel currentLandmark = LandmarkModel(
    name: '연세대학교',
    latLng: LatLng(37.560041, 126.936924)
  );

  void requestLocationPermission() async {
    final result = await Permission.location.request();
    if (result.isGranted) {
      _locationPermissionGranted = true;
      emit(MainLocationPermissionGranted());
    } else {
      Logger.D('location permission denied');
    }
  }

  void initMap(BuildContext context) {
    _createMarkerImageFromAsset(context);
    fetchLandmark();
  }

  void fetchLandmark() {
    wallRepository.fetchLandmark()
        .map((landmarks) {
          Logger.D('map landmarks ${landmarks.length}');
          return landmarks.map((landmark) =>
            Marker(
              markerId: MarkerId(landmark.name),
              position: landmark.latLng,
              infoWindow: InfoWindow(
                title: landmark.name,
              ),
              icon: _landmarkIcon,
              onTap: () {
                currentLandmark = landmark;
                updateLocation();
              },
            )
          ).toSet();
        })
        .handleError((error) => Logger.D('error $error'))
        .listen((markers) {
          emit(MainLandmarkUpdated(markers));
        });
  }

  void trackLocation() {
    if (_locationPermissionGranted == false) {
      print('pls request permission before tracking current location');
      return;
    }

    // update location once
    updateLocation();

    Stream
        .periodic(Duration(seconds: 2), (_) {})
        .listen((_) => updateLocation());
  }

  void updateLocation() {
    getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((location) =>
          emit(MainLocationChanged(
              lati: location.latitude,
              long: location.longitude,
              distance: _getDistance(location),
              currentLandmark: currentLandmark
          ))
        );
  }

  double _getDistance(Position location) {
    if (currentLandmark == null) { return 0; }
    final distance = GeolocatorPlatform.instance
        .distanceBetween(
            currentLandmark.latLng.latitude, currentLandmark.latLng.longitude,
            location.latitude, location.longitude
        );
    return distance;
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_landmarkIcon == null) {
      await AssetExtension.getBitmapDescriptorFromAssetBytes('assets/ic_brick_brown.png', 100)
          .then((value) => _landmarkIcon = value);
    }
  }
}