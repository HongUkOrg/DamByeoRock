import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/WallNavigator.dart';
import 'package:wall/landmark/LandmarkView.dart';
import 'package:wall/main/MainView.dart';
import 'package:wall/SimpleBlocObserver.dart';
import 'package:wall/splash/SplashCubit.dart';
import 'package:wall/utils/Utils.dart';

import 'landmark/LandmarkCubit.dart';
import 'main/MainCubit.dart';
import 'splash/SplashView.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // TODO: make theme data separated class
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.lightGreen,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.lightGreen
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: WallNavigator.makeRoute(),
    );
  }
}
