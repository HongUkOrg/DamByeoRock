
import 'package:flutter/material.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/Utils.dart';


class MemoListView extends StatelessWidget {

  final List<MemoModel> _memoList;

  MemoListView(this._memoList);

  @override
  Widget build(BuildContext context) {
    List<ListTile> result = [];
    _memoList.forEach((element) {
      result.add(ListTile(
        title: Text(element.memo,
          style: getRandomElement(googleFonts),
        ),
      ));
    });
    return ListView(
      children: result,
    );
  }
}
