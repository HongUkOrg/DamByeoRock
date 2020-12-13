import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/utils/Utils.dart';

import '../MainCubit.dart';


class MainBottomView extends StatefulWidget {
  @override
  _MainBottomViewState createState() => _MainBottomViewState();
}

class _MainBottomViewState extends State<MainBottomView> {

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<MainCubit>(context);

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _navigateToLandmark(),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: DeviceHelper.screenWidth,
              height: 141,
              child: Container(
                  child: PageView(
                    children: getLandmark(),
                    controller: PageController(
                      viewportFraction: 0.8426,
                      initialPage: 0,
                    ),
                    onPageChanged: (page) {
                      cubit.landmarkChanged(page);
                    },
                  )
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToLandmark() async {
    final cubit = BlocProvider.of<MainCubit>(context);
    Navigator.pushNamed(context, '/landmark', arguments: cubit.currentLandmarkModel);
  }

  List<Widget> getLandmark() {
    final cubit = BlocProvider.of<MainCubit>(context);
    return cubit.landmarks
      .map((landmarkModel) {
        return SizedBox(
          width: 316,
          height: 141,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: Colors.white,
            child: Center(
              child: Text(
                  '${landmarkModel.name}'
              ),
            ),
          ),
        );
    }).toList();
  }
}