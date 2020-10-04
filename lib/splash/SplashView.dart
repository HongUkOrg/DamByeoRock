
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/main/MainCubit.dart';
import 'package:wall/main/MainView.dart';
import 'package:wall/splash/SplashCubit.dart';
import 'package:wall/utils/Utils.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // should initialize device helper once! for getting size of screen
    DeviceHelper().init(context);
    return BlocConsumer<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => BlocProvider<MainCubit>(
              create: (context) => MainCubit(),
              child: MainView(),
            ),
            fullscreenDialog: true,
          ));
        }
      },
      builder: (context, state) {
        return Center(
            child: Container(
              height: 400,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 130,
                    height: 130,
                    child: Image.asset(
                        'assets/ic_grass.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('풀틈',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
