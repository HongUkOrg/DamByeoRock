
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/main/MainCubit.dart';
import 'package:wall/utils/ColorExtensions.dart';
import 'wigets/MainWidgets.dart';
import 'package:wall/utils/Utils.dart';

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {

  static final CameraPosition initialCameraPosition = CameraPosition(
    // Yonsei University
    target: LatLng(37.560041, 126.936924),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final MainCubitType cubit = BlocProvider.of<MainCubit>(context);
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
          // TODO: do anything when tapping each landmark
        }
      },
      builder: (context, state) {
        return new Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  cubit.googleMapController.complete(controller);
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
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 150),
            child: FloatingActionButton(
              backgroundColor: Colors.white.withAlpha(0),
              onPressed: () => cubit.animateToCurrentPosition(),
              child: Image.asset('assets/icPoint.png'),
            )
          ),
        );
      },
    );
  }

  Future<void> _updatePosition(LatLng location) async {
    final cubit = BlocProvider.of<MainCubit>(context);
    final GoogleMapController controller = await cubit.googleMapController.future;
    final currentPosition = CameraPosition(
        zoom: 18,
        target: location
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }
}