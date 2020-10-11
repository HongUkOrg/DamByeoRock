import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/model/LandmarkModels.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/Utils.dart';

import 'LandmarkWidgets.dart';

class LandmarkMemoView extends StatelessWidget {
  const LandmarkMemoView({
    Key key,
    @required MemoViewType memoViewType,
    @required List<MemoModel> memoList,
  }) : _memoViewType = memoViewType, _memoList = memoList, super(key: key);

  final MemoViewType _memoViewType;
  final List<MemoModel> _memoList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandmarkCubit, LandmarkState>(
      builder: (context, state) {
        if (state is LandmarkBeforeUpdated) {
          _memoList.add(MemoModel(memo: 'updating..', color: Colors.black, top: 1000, left: -500));
          return Container(
            child: Expanded(
              child: _memoViewType == MemoViewType.memo ? MemoCardView(_memoList) : MemoListView(_memoList),
            ),
          );
        }
        return Expanded(
          child: _memoViewType == MemoViewType.memo ? MemoCardView(_memoList) : MemoListView(_memoList),
        );
      },
    );
  }
}