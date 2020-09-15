part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}
class MainLocationPermissionGranted extends MainState {}
class MainLocationChanged extends MainState {
  final double lati;
  final double long;

  MainLocationChanged({this.lati, this.long});

  @override
  List<Object> get props => [lati, long];
}