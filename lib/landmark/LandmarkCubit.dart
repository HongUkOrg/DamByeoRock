import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meta/meta.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/repositories/Repositories.dart';
import 'package:wall/utils/DeviceHelper.dart';
import 'package:wall/utils/Utils.dart';

import 'model/MemoModel.dart';

part 'LandmarkState.dart';

class LandmarkCubit extends Cubit<LandmarkState> {
  LandmarkCubit(this.landmarkModel) : super(LandmarkInitial());

  final LandmarkModel landmarkModel;
  final LandmarkRepository landmarkRepository = LandmarkRepository();
  List<MemoModel> memoList = [];
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
    MemoModel memoModel = _createRandomMemoModel();
    final response = await landmarkRepository
        .addMemo(landmarkName: landmarkModel.name, memoModel: memoModel);
    if (response) fetchMemo();
  }

  void initDeviceHelper(BuildContext context) {
    DeviceHelper().init(context);
  }

  MemoModel _createRandomMemoModel() {

    final maxHorizontalPosition = DeviceHelper.screenHeight - 150;
    final maxVerticalPosition = DeviceHelper.screenHeight - 400;
    return MemoModel(
      memo: this.memo,
      color: Random().nextBool() ? Colors.yellow : Colors.lightGreenAccent,
      top: Random().nextDouble() * maxVerticalPosition,
      left: Random().nextDouble() * maxHorizontalPosition,
    );
  }
}
