import 'package:flutter/material.dart';
import 'package:wall/landmark/model/LandmarkModels.dart';
import 'package:wall/landmark/model/MemoModel.dart';

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
    return Expanded(
      child: _memoViewType == MemoViewType.memo ? MemoCardView(_memoList) : MemoListView(_memoList),
    );
  }
}