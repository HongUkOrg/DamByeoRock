import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/main/MainCubit.dart';
import 'package:wall/utils/Utils.dart';
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
        return Column(
          children: [
            SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  MainHeaderView(),
                  SizedBox(height: 50),
                  MainLocationTrackingView(landmarkName: _landmarkName, distance: _distance)
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}