
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/DeviceHelper.dart';
import 'package:wall/utils/Utils.dart';

import 'widgets/MemoView.dart';

class LandmarkMemoView extends StatefulWidget {

  LandmarkMemoView(this.landmarkModel);

  // MARK: - Properties
  LandmarkModel landmarkModel;

  @override
  _LandmarkMemoViewState createState() => _LandmarkMemoViewState();
}

class _LandmarkMemoViewState extends State<LandmarkMemoView> {
  List<MemoModel> _memoList = [];

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LandmarkCubit>(context);
    final GlobalKey<FormState> globalKey = GlobalKey<FormState>(debugLabel: 'hi');
    final TextEditingController _textEditingController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note),
        onPressed: () {
          if (globalKey.currentState.validate()){
            cubit.addMemo();
          }
        },
      ),
      body: BlocConsumer<LandmarkCubit, LandmarkState>(
        listener: (context, state) {
          if (state is LandmarkUpdated) {
            _memoList = state.memoList;
          }
        },
        builder: (context, state) {
          if (state is LandmarkInitial) {
            cubit.initDeviceHelper(context);
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 100,
                    height: 50,
                    child: Center(
                        child: Icon(Icons.home)
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      '${widget.landmarkModel.name} 담벼락',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.blue
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: _getMemoTile(_memoList, context),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 80),
                  height: 60,
                  child: Form(
                    key: globalKey,
                    autovalidate: true,
                    child: TextFormField(
                      validator: (text) {
                        cubit.updateMemo(text);
                        return text.trim().isEmpty ?
                        '메모를 입력해주세요' : null;
                      },
                      decoration: InputDecoration(
                        hintText: '글 남기기',
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getMemoTile(List<MemoModel> memoList, BuildContext context) {
    List<Widget> result = [];
    memoList.forEach((memoModel) {
      final memoView = Positioned(
        top: memoModel.top,
        bottom: memoModel.bottom,
        left: memoModel.left,
        right: memoModel.right,
        child: Container(
            width: 130,
            height: 130,
            child: MemoView(memoModel)
        ),
      ) ;
      result.add(memoView);
    });
    return result;
  }

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  List<TextStyle> _googleFonts = [
    GoogleFonts.lato(fontWeight: FontWeight.w300, fontSize: 15),
    GoogleFonts.actor(fontWeight: FontWeight.w300, fontSize: 15),
    GoogleFonts.aBeeZee(fontWeight: FontWeight.w300, fontSize: 15),
    GoogleFonts.blackHanSans(fontWeight: FontWeight.w300, fontSize: 15),
    GoogleFonts.thasadith(fontWeight: FontWeight.w300, fontSize: 15),
  ];
}
