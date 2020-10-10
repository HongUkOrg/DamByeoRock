import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'landmark/LandmarkCubit.dart';
import 'landmark/LandmarkView.dart';
import 'main/MainCubit.dart';
import 'main/MainView.dart';
import 'splash/SplashCubit.dart';
import 'splash/SplashView.dart';

class WallNavigator {

  static RouteFactory makeRoute() {
    return (RouteSettings settings) {
      final args = settings.arguments;
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(
              builder: (context) => BlocProvider<SplashCubit>(
                create: (context) => SplashCubit()..navigateToMain(),
                child: SplashView(),
              )
          );
        case '/main':
          return MaterialPageRoute(
            builder: (context) => BlocProvider<MainCubit>(
              create: (context) => MainCubit(),
              child: MainView(),
            ),
            fullscreenDialog: true,
          );
        case '/landmark':
          return MaterialPageRoute(
            builder: (context) => BlocProvider<LandmarkCubit>(
              create: (context) => LandmarkCubit(args)..fetchMemo(),
              // child: LandmarkView(cubit.currentLandmark),
              child: LandmarkView(),
            ),
          );
      }
      return null;
    };
  }
}