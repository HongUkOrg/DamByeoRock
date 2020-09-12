import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:wall/simple_bloc_observer.dart';
import 'package:wall/splash/splash_cubit.dart';

import 'splash/splash_view.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: BlocProvider(
            create: (context) => SplashCubit()..navigateToMain(),
            child: SplashView()
        ),
      ),
    );
  }
}