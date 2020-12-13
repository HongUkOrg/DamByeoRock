import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/main/MainCubit.dart';
import 'package:wall/utils/ColorExtensions.dart';
import 'package:wall/utils/Utils.dart';
import 'MainMyRoomView.dart';
import 'MainWidgets.dart';

class MainContentsView extends StatefulWidget {
  @override
  _MainContentsViewState createState() => _MainContentsViewState();
}

class _MainContentsViewState extends State<MainContentsView> {

  String _landmarkName = 'Undefined';
  int _distance;

  @override
  Widget build(BuildContext context) {
    final MainCubitType cubit = BlocProvider.of<MainCubit>(context);
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is MainLocationChanged) {
          _landmarkName = state.currentLandmark.name;
          _distance = state.distance.toInt();
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              MainHeaderView(),
              MainMyRoomView(),
              MainBottomView(),
            ],
          ),
        );
      },
    );
  }
}
