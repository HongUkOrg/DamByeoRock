import 'package:flutter/material.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'MemoWidgets.dart';

class MemoCardView extends StatelessWidget {

  final List<MemoModel> _memoList;

  MemoCardView(this._memoList);

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];

    _memoList.asMap().forEach((index, memoModel) {
      final memoView = Positioned(
        top: memoModel.top,
        bottom: memoModel.bottom,
        left: memoModel.left,
        right: memoModel.right,
        child: Container(
          width: 130,
          height: 130,
          decoration: index == _memoList.length - 1 ? BoxDecoration(color: Colors.blueAccent) : null,
          child: MemoView(memoModel),
        ),
      ) ;
      result.add(memoView);
    });
    return Stack(
      children: result,
    );
  }
}
