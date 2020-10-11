import 'dart:async';
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
import 'package:rxdart/rxdart.dart';

part 'LandmarkState.dart';

abstract class LandmarkCubitType {

  // MARK: - Network
  void connectWithLandmark();
  void disconnectWithLandmark();
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
  StreamSubscription<List<MemoModel>> currentConnection;

  // MARK: - Methods
  void connectWithLandmark() async {
    currentConnection = landmarkRepository.fetchMemo(landmarkName: landmarkModel.name)
        .listen((memoList) {
          this.memoList = memoList;
          Logger.D('memo list fetched :: count - ${memoList.length}');
          if (memoList.length >= 100) {
            emit(LandmarkBeforeUpdated());
            emitAsync(LandmarkUpdated(memoList));
          } else {
            emit(LandmarkUpdated(memoList));
          }
        });
  }

  void disconnectWithLandmark() async {
    currentConnection.cancel();
  }

  Future<void> emitAsync(LandmarkState state) async {
    Stream
      .value('')
      .delay(Duration(microseconds: 1000))
      .listen((event) {
        emit(state);
      });
  }

  void addMemo({String text}) async {
    MemoModel memoModel = _createRandomMemoModel(text);
    emit(LandmarkUpdating());
    final response = await landmarkRepository
        .addMemo(landmarkName: landmarkModel.name, memoModel: memoModel);
    if (response) connectWithLandmark();
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
