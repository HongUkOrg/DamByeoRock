import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/logger/Logger.dart';
import 'package:wall/repositories/Repositories.dart';

part 'MainState.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  final WallRepository wallRepository = WallRepository();
  Set<Marker> markers = {};
  bool locationPermissionGranted = false;

  void requestLocationPermission() async {
    final result = await Permission.location.request();
    print('bleo: location permissino requested ${result.isGranted}, ${result.runtimeType}');
    if (result.isGranted) {
      locationPermissionGranted = true;
      emit(MainLocationPermissionGranted());
    } else {
      Logger.logD('location permission deinied');
    }
  }

  void fetchLandmark() {
    wallRepository.fetchLandmark()
        .then((Set<LandmarkModel> landmarks) => {
          landmarks.forEach((landmark) {
            Logger.logD('add latLng ${landmark.latLng.latitude}, ${landmark.latLng.longitude}');
            markers.add(Marker(
                markerId: MarkerId(landmark.name),
                position: landmark.latLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(300),
                onTap: () => press(landmark),
            ));
            print('current markers ${markers.length}');
            emit(MainLandmarkUpdated(markers));
          })
        });
  }

  void press(LandmarkModel landmarkModel) {
    Logger.logD('marker tapped ${landmarkModel}');
    emit(MainLandmarkTapped(landmarkModel));
  }

  void trackLocation() {
    if (locationPermissionGranted == false) {
      print('pls request permission before tracking current location');
      return;
    }
    Logger.logD('track location');
    getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((location) {
      emit(MainLocationChanged(lati: location.latitude, long: location.longitude));
    });

    Stream.periodic(Duration(seconds: 5), (_) {
    })
    .listen((event) {
      getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((location) {
            // print('fetch location ${location.latitude}, ${location.longitude}');
            emit(MainLocationChanged(lati: location.latitude, long: location.longitude));
          });
    });

  }
}
