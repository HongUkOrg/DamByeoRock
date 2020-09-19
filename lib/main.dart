import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/simple_bloc_observer.dart';
import 'package:wall/splash/SplashCubit.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: MultiBlocProvider(
            providers: [
              BlocProvider<SplashCubit>(
                create: (context) => SplashCubit()..navigateToMain(),
              ),
            ],
            child: SplashView()),
      ),
    );
  }
}
