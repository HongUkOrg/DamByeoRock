import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/repositories/Repositories.dart';
import 'package:wall/utils/Utils.dart';
import 'package:rxdart/rxdart.dart';

part 'MainState.dart';

abstract class MainCubitType {
  // MARK: - Methods
  void requestLocationPermission();
  void initMap(BuildContext context);
  void trackLocation();
  void updateLocation();
  void landmarkChanged(int page);
  void animateToCurrentPosition();

  Completer<GoogleMapController> googleMapController;
  LatLng currentLocation;
  List<LandmarkModel> landmarks;

}

class MainCubit extends Cubit<MainState> implements MainCubitType {
  MainCubit() : super(MainInitial());

  // MARK: - Repository
  final WallRepository wallRepository = WallRepository();

  // MARK: - Map
  Set<Marker> markers = {};
  BitmapDescriptor _landmarkIcon;
  Completer<GoogleMapController> googleMapController = Completer();

  // MARK: - Properties
  bool _locationPermissionGranted = false;
  LatLng currentLocation = LatLng(37.560041, 126.936924);
  LandmarkModel currentLandmarkModel;
  List<LandmarkModel> landmarks = [];

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
    wallRepository
        .fetchLandmark()
        .handleError((error) => Logger.D('error $error'))
        .listen((landmarks) {
          Logger.D('map landmarks ${landmarks.length}');
          // TODO: set default landmark model - set first model as default now
          this.landmarks = landmarks;
          this.currentLandmarkModel = landmarks.first;
          emit(MainLandmarkUpdated(landmarks.map((landmark) =>
              Marker(
                markerId: MarkerId(landmark.name),
                position: landmark.latLng,
                infoWindow: InfoWindow(
                  title: landmark.name,
                ),
                icon: _landmarkIcon,
                onTap: () {
                  this.currentLandmarkModel = landmark;
                  emit(MainLandmarkChanged(currentLandmarkModel));
                  updateLocation();
                },
              )).toSet())
          );
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
        .then((location) {
          emit(MainLocationChanged(
              latitude: location.latitude,
              longitude: location.longitude,
              distance: _getDistance(location),
              currentLandmark: currentLandmarkModel));
          currentLocation = LatLng(location.latitude, location.longitude);
    });
  }

  void landmarkChanged(int page) async {
    if ((this.landmarks.length - 1) < page) {
      return;
    }
    // FIXME:
    currentLandmarkModel = landmarks[page];
    emit(MainLandmarkChanged(currentLandmarkModel));
    _animateCamera(currentLandmarkModel.latLng);
  }

  void animateToCurrentPosition() {
    _animateCamera(currentLandmarkModel.latLng);
  }
}

extension MainCubitExtensions on MainCubit {
  // MARK: - Private Methods
  void _animateCamera(LatLng location) async {
    final GoogleMapController controller = await googleMapController.future;
    final currentPosition = CameraPosition(
        zoom: 15,
        target: location
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }

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