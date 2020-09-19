part of 'MainCubit.dart';

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
  final double distance;
  final LandmarkModel currentLandmark;

  MainLocationChanged({this.lati, this.long, this.distance, this.currentLandmark});

  @override
  List<Object> get props => [lati, long, distance, currentLandmark];
}
class MainLandmarkTapped extends MainState {
  final LandmarkModel landmarkModel;

  MainLandmarkTapped(this.landmarkModel);

  List<Object> get props => [landmarkModel];
}


class MainDistanceUpdated extends MainState {
  MainDistanceUpdated(this.distance, this.landmarkName);

  final double distance;
  final String landmarkName;

  @override
  List<Object> get props => [distance, landmarkName];
}