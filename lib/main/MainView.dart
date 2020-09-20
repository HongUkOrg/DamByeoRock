
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/LandmarkView.dart';
import 'package:wall/main/MainCubit.dart';
import 'wigets/MainWidgets.dart';
import 'package:wall/utils/Utils.dart';

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
          cubit.initMap(context);
          cubit.trackLocation();
        }
        if (state is MainLandmarkUpdated) {
          Logger.D('bleo: update markers ${state.markers}');
          _markers = state.markers;
        }
        if (state is MainLandmarkTapped) {
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => BlocProvider<LandmarkCubit>(
          //     create: (context) => LandmarkCubit(state.landmarkModel)..fetchMemo(),
          //     child: LandmarkView(state.landmarkModel),
          //   ),
          // ));
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
              MainContentsView(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _goToLandmark(cubit),
            label: Text('입장'),
            icon: Icon(Icons.account_balance),
          ),
        );
      },
    );
  }

  Future<void> _goToLandmark(MainCubit cubit) async {
    final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => BlocProvider<LandmarkCubit>(
        create: (context) => LandmarkCubit(cubit.currentLandmark)..fetchMemo(),
        child: LandmarkView(cubit.currentLandmark),
      ),
    ));
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
