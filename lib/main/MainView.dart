
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/LandmarkView.dart';
import 'package:wall/logger/Logger.dart';
import 'package:wall/main/MainCubit.dart';

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => MainViewState();


}

class MainViewState extends State<MainView> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.560041, 126.936924),
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
    Set<Marker> _markers = {};

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        print('listen state ${state.runtimeType}');
        if (state is MainLocationPermissionGranted) {
          cubit.fetchLandmark();
          cubit.trackLocation();
        }
        if (state is MainLocationChanged) {
          _updatePosition(state.lati, state.long);
        }
        if (state is MainLandmarkUpdated) {
          _markers = state.markers;
          print('marker update ${_markers.length}');
        }
        if (state is MainLandmarkTapped) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => BlocProvider<LandmarkCubit>(
              create: (context) => LandmarkCubit(state.landmarkModel)..fetchMemo(),
              child: LandmarkView(state.landmarkModel),
            ),
          ));
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
                markers: _markers,
              ),
              Builder(
                builder: (context) {
                  if (state is MainInitial) {
                    return Center(
                      child: Text(
                        'plz grant permission',
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
              ),
              Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 50,
                      child: Center(
                        child: Text(
                          '담벼락 세계에 오신걸 환영합니다!',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _goToTheLake,
            label: Text('Memo'),
            icon: Icon(Icons.directions_boat),
          ),
        );
      },
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _updatePosition(double lati, double long) async {
    final GoogleMapController controller = await _controller.future;
    final currentPosition = CameraPosition(
        zoom: 18,
        target: LatLng(lati, long)
    );
    // controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }
}
