
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/logger/Logger.dart';

class LandmarkView extends StatelessWidget {

  LandmarkView(this.landmarkModel);

  // MARK: - Properties
  LandmarkModel landmarkModel;
  List<String> _memoList = [];

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LandmarkCubit>(context);
    final GlobalKey<FormState> memoKey = GlobalKey<FormState>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note),
        onPressed: () {
          if (memoKey.currentState.validate()){
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
                      '${landmarkModel.name} 담벼락',
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
                  child: ListView(
                    children: getMemoTile(_memoList),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 80),
                  height: 60,
                  child: Form(
                    key: memoKey,
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

  List<ListTile> getMemoTile(List<String> memoList) {
    List<ListTile> result = [];
    memoList.forEach((element) {
      result.add(ListTile(
        title: Text(element,
          style: getRandomElement(_googleFonts),
        ),
      ));
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
