import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/repositories/Repositories.dart';
import 'package:wall/utils/DeviceHelper.dart';
import 'package:wall/utils/Utils.dart';
import 'model/LandmarkModels.dart';
import 'model/MemoModel.dart';

part 'LandmarkState.dart';

abstract class LandmarkCubitType {

  // MARK: - Network
  void fetchMemo();
  void addMemo({String text});

  // MARK: - Button Actions
  void tapListModeButton();
  void tapMemoModeButton();

  // MARK: - Properties
  LandmarkModel landmarkModel;
  MemoViewType memoViewType;
}

class LandmarkCubit extends Cubit<LandmarkState> implements LandmarkCubitType {
  LandmarkCubit(this.landmarkModel) : super(LandmarkInitial());

  final LandmarkRepositoryType landmarkRepository = LandmarkRepository();
  final maxHorizontalPosition = DeviceHelper.screenWidth - 150;

  final maxVerticalPosition = DeviceHelper.screenHeight - 400;
  // MARK: - Properties

  List<MemoModel> memoList = [];
  LandmarkModel landmarkModel;
  MemoViewType memoViewType = MemoViewType.memo;

  // MARK: - Methods
  void fetchMemo() async {

    final memoList = await landmarkRepository.fetchMemo(landmarkName: landmarkModel.name);
    this.memoList = memoList;

    Logger.D('memo list fetched :: count - ${memoList.length}');
    emit(LandmarkUpdated(memoList));
  }

  void addMemo({String text}) async {
    MemoModel memoModel = _createRandomMemoModel(text);
    final response = await landmarkRepository
        .addMemo(landmarkName: landmarkModel.name, memoModel: memoModel);
    if (response) fetchMemo();
  }

  void tapListModeButton() {
    memoViewType = MemoViewType.list;
    emit(LandmarkMemoViewTypeUpdated(memoViewType));
  }

  void tapMemoModeButton() {
    memoViewType = MemoViewType.memo;
    emit(LandmarkMemoViewTypeUpdated(memoViewType));
  }
}

extension LandmarkCubitExtensions on LandmarkCubit {
  // MARK: - Private Methods
  MemoModel _createRandomMemoModel(String memoText) {
    return MemoModel(
      memo: memoText,
      color: Random().nextBool() ? Colors.yellow : Colors.lightGreenAccent,
      top: Random().nextDouble() * maxVerticalPosition,
      left: Random().nextDouble() * maxHorizontalPosition,
    );
  }
}
