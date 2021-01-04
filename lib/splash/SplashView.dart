
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/main/MainCubit.dart';
import 'package:wall/main/MainView.dart';
import 'package:wall/splash/SplashCubit.dart';
import 'package:wall/utils/ColorExtensions.dart';
import 'package:wall/utils/Utils.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // should initialize device helper once! for getting size of screen
    DeviceHelper().init(context);
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            Navigator.pushReplacementNamed(context, '/main',);
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
                      child: Image.asset(
                          'assets/img_ghost_yellow.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('꿍시렁',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: DamColors.purpleishBlue,
                      ),
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }
}
