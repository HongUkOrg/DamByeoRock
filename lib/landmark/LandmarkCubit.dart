import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/repositories/Repositories.dart';
import 'package:wall/utils/Utils.dart';

part 'LandmarkState.dart';

class LandmarkCubit extends Cubit<LandmarkState> {
  LandmarkCubit(this.landmarkModel) : super(LandmarkInitial());

  final LandmarkModel landmarkModel;
  final LandmarkRepository landmarkRepository = LandmarkRepository();
  List<String> memoList = [];
  String memo = '';

  void fetchMemo() async {

    final memoList = await landmarkRepository.fetchMemo(landmarkName: landmarkModel.name);
    this.memoList = memoList;

    Logger.D('memo list fetched ${memoList}');
    emit(LandmarkUpdated(memoList));
  }

  void updateMemo(String memo) {
    this.memo = memo;
  }

  void addMemo() async {
    final response = await landmarkRepository
        .addMemo(landmarkName: landmarkModel.name, memo: this.memo);
    if (response) fetchMemo();
  }
}
