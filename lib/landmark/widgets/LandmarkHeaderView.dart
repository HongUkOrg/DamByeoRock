import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../LandmarkCubit.dart';

class LandmarkHeaderView extends StatelessWidget {
  const LandmarkHeaderView({
    Key key,
    @required this.landmarkName,
  }) : super(key: key);

  final String landmarkName;

  @override
  Widget build(BuildContext context) {
    
    final LandmarkCubitType cubit = BlocProvider.of<LandmarkCubit>(context);

    return Container(
      height: 100,
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Center(
            child: Text(
              '$landmarkName 담벼락',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.lightGreen,
              ),
            ),
          ),
          Expanded(child: Container(),),
          IconButton(
            icon: Icon(Icons.list, color: Colors.black45,),
            onPressed: () {
              cubit.tapListModeButton();
            },
          ),
          IconButton(
            icon: Icon(Icons.note_add, color: Colors.black45,),
            onPressed: () {
              cubit.tapMemoModeButton();
            },
          )
        ],
      ),
    );
  }
}
