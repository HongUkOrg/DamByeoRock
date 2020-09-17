part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}
class MainLocationPermissionGranted extends MainState {}
class MainLandmarkUpdated extends MainState {
  final Set<Marker> markers;

  MainLandmarkUpdated(this.markers);

  @override
  List<Object> get props => [markers];
}
class MainLocationChanged extends MainState {
  final double lati;
  final double long;

  MainLocationChanged({this.lati, this.long});

  @override
  List<Object> get props => [lati, long];
}
class MainLandmarkTapped extends MainState {
  final LatLng latLng;

  MainLandmarkTapped(this.latLng);

  List<Object> get props => [latLng];
}