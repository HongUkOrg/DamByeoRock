import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  // final Location locationTracker = Location();
  bool locationPermissionGranted = false;

  void requestLocationPermission() async {
    final result = await Permission.location.request();
    if (result.isDenied) {
      print('user denied permission');
    } else if (result.isGranted) {
      print('granted!! ${result.runtimeType}');
      locationPermissionGranted = true;
      emit(MainLocationPermissionGranted());
    } else {
      print('unknown permission err');
    }

    // bool _serviceEnabled = await locationTracker.serviceEnabled();
    // if (_serviceEnabled == false) {
    //   print('bleo: request service');
    //   _serviceEnabled = await locationTracker.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // } else {
    //   print('bleo: service enable');
    // }
  }

  void trackLocation() {
    if (locationPermissionGranted == false) {
      print('pls request permission before tracking current location');
      return;
    }
    print('track location');

    Stream.periodic(Duration(seconds: 5), (value) {
      print('value $value');
    })
    .listen((event) {
      print('value event $event');
      getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((location) {
            print('get location once ${location.latitude}, ${location.longitude}');
            emit(MainLocationChanged(lati: location.latitude, long: location.longitude));
          });
    });

    // locationTracker
    //     .onLocationChanged
    //     .listen((location) {
    //       emit(MainLocationChanged(lati: location.latitude, long: location.longitude));
    //       print('latitude ${location.latitude}, long: ${location.longitude}');
    //     });
  }
}
