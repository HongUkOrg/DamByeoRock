import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/main/MainCubit.dart';
import 'package:wall/utils/Utils.dart';

class MainContentsView extends StatefulWidget {
  @override
  _MainContentsViewState createState() => _MainContentsViewState();
}

class _MainContentsViewState extends State<MainContentsView> {

  String _landmarkName = 'Undefined';
  int _distance;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<MainCubit>(context);
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is MainLocationChanged) {
          Logger.logD('distance updated!! ${state.distance}');
          _landmarkName = state.currentLandmark.name;
          _distance = state.distance.toInt();
          Logger.logD('distance updated after!! ${_distance}');
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Container(
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
                  SizedBox(height: 50),
                  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white60,
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        '${_landmarkName} 까지의 거리 ${_distance}m',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      )
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}