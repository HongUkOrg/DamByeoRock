part of 'LandmarkCubit.dart';

@immutable
abstract class LandmarkState extends Equatable {

  @override
  List<Object> get props => [];
}

class LandmarkInitial extends LandmarkState {}

class LandmarkUpdated extends LandmarkState {
  final List<MemoModel> memoList;

  LandmarkUpdated(this.memoList);

  @override
  List<Object> get props => [memoList];
}