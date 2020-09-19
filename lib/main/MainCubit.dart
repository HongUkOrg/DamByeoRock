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
  LandmarkModel currentLandmark;

  void requestLocationPermission() async {
    final result = await Permission.location.request();
    print('bleo: location permissino requested ${result.isGranted}, ${result.runtimeType}');
    if (result.isGranted) {
      _locationPermissionGranted = true;
      emit(MainLocationPermissionGranted());
    } else {
      Logger.logD('location permission deinied');
    }
  }

  void initMap(BuildContext context) {
    _createMarkerImageFromAsset(context);
    fetchLandmark();
  }

  void fetchLandmark() {
    wallRepository.fetchLandmark()
        .then((Set<LandmarkModel> landmarks) => {
          landmarks.forEach((landmark) {
            if (currentLandmark == null && landmark.name == '연세대학교') currentLandmark = landmark;
            Logger.logD('add latLng ${landmark.latLng.latitude}, ${landmark.latLng.longitude}');
            Logger.logD('landamrk image state $_landmarkIcon');
            markers.add(Marker(
                markerId: MarkerId(landmark.name),
                position: landmark.latLng,
                icon: _landmarkIcon,
                onTap: () => press(landmark),
            ));
            print('current markers ${markers.length}');
            emit(MainLandmarkUpdated(markers));
          })
        });
  }

  void press(LandmarkModel landmarkModel) {
    Logger.logD('marker tapped ${landmarkModel}');
    currentLandmark = landmarkModel;
    emit(MainLandmarkTapped(landmarkModel));
  }

  void trackLocation() {
    if (_locationPermissionGranted == false) {
      print('pls request permission before tracking current location');
      return;
    }
    Logger.logD('track location');
    getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((location) {
      emit(MainLocationChanged(lati: location.latitude, long: location.longitude));
    });

    Stream.periodic(Duration(seconds: 1), (_) {
    })
    .listen((event) {
      getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((location) {
            print('fetch location ${location.latitude}, ${location.longitude}');
            emit(MainLocationChanged(
                lati: location.latitude, 
                long: location.longitude,
                distance: getDistance(location),
                currentLandmark: currentLandmark
            ));
          });
    });
  }

  double getDistance(Position location) {
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
