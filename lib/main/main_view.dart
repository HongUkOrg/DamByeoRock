
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/WallRepository/WallRepository.dart';
import 'package:wall/main/main_cubit.dart';

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<MainCubit>(context);

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        print('listen state ${state.runtimeType}');
        if (state is MainLocationPermissionGranted) {
          cubit.trackLocation();
        }
        if (state is MainLocationChanged) {
          _updatePosition(state.lati, state.long);
        }
      },
      builder: (context, state) {
        return new Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  cubit.requestLocationPermission();
                },
              ),
              Builder(
                builder: (context) {
                  if (state is MainInitial) {
                    return Center(
                      child: Text('plz grant permission',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  } else {
                    return Center();
                  }
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _goToTheLake,
            label: Text('To the lake!'),
            icon: Icon(Icons.directions_boat),
          ),
        );
      },
    );
  }

  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    final wallRepository = WallRepository();
    wallRepository.add();
  }

  Future<void> _updatePosition(double lati, double long) async {
    final GoogleMapController controller = await _controller.future;
    final currentPosition = CameraPosition(
        zoom: 18,
        target: LatLng(lati, long)
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }
}
