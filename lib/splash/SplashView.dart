
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/main/MainCubit.dart';
import 'package:wall/main/MainView.dart';
import 'package:wall/splash/SplashCubit.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            child: Text('Welcome to dambuyrock',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blueGrey,
              ),
            )
        );
      },
    );
  }
}
