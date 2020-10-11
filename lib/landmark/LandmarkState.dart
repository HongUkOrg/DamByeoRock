part of 'LandmarkCubit.dart';

@immutable
abstract class LandmarkState extends Equatable {

  @override
  List<Object> get props => [];
}

class LandmarkInitial extends LandmarkState {}

class LandmarkUpdating extends LandmarkState {}
class LandmarkBeforeUpdated extends LandmarkState {}

class LandmarkUpdated extends LandmarkState {
  final List<MemoModel> memoList;

  LandmarkUpdated(this.memoList);

  @override
  List<Object> get props => [memoList];
}

class LandmarkMemoViewTypeUpdated extends LandmarkState {
  final MemoViewType memoViewType;

  LandmarkMemoViewTypeUpdated(this.memoViewType);

  @override
  List<Object> get props => [memoViewType];
}