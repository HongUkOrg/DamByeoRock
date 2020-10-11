import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'LandmarkWidgets.dart';

class MemoCardView extends StatelessWidget {

  List<MemoModel> _memoList;

  MemoCardView(this._memoList);

  double width = 130.0, height = 130.0;

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];

    _memoList.asMap().forEach((index, memoModel) {
      final memoView = MemoSingleView(memoModel, index == _memoList.length - 1);
      result.add(memoView);
    });
    return Stack(
      children: result,
    );
  }
}
