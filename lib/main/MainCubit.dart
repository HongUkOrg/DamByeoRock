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

abstract class MainCubitType {
  // MARK: - Methods
  void requestLocationPermission();
  void initMap(BuildContext context);
  void trackLocation();
  void updateLocation();
}

class MainCubit extends Cubit<MainState> implements MainCubitType {
  MainCubit() : super(MainInitial());

  // MARK: - Repository
  final WallRepository wallRepository = WallRepository();

  // MARK: - Map
  Set<Marker> markers = {};
  BitmapDescriptor _landmarkIcon;
  // MARK: - Properties

  bool _locationPermissionGranted = false;
  LandmarkModel currentLandmarkModel;

  // MARK: - Methods
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
          // TODO: set default landmark model - set first model as default now
          currentLandmarkModel = landmarks.first;
          return landmarks.map((landmark) =>
            Marker(
              markerId: MarkerId(landmark.name),
              position: landmark.latLng,
              infoWindow: InfoWindow(
                title: landmark.name,
              ),
              icon: _landmarkIcon,
              onTap: () {
                currentLandmarkModel = landmark;
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
              currentLandmark: currentLandmarkModel
          ))
        );
  }


}

extension MainCubitExtensions on MainCubit {
  // MARK: - Private Methods
  double _getDistance(Position location) {
    if (currentLandmarkModel == null) { return 0; }
    final distance = GeolocatorPlatform.instance
        .distanceBetween(
        currentLandmarkModel.latLng.latitude, currentLandmarkModel.latLng.longitude,
        location.latitude, location.longitude
    );
    return distance;
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_landmarkIcon == null) {
      await AssetExtension.getBitmapDescriptorFromAssetBytes('assets/ic_brick_brown.png', 130)
          .then((value) => _landmarkIcon = value);
    }
  }
}