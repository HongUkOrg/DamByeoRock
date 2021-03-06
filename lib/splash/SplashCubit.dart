import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'SplashState.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void navigateToMain() {
    Stream.value(null)
        .delay(Duration(seconds: 2))
        .listen((_) {
          emit(SplashCompleted());
        });
  }
}
